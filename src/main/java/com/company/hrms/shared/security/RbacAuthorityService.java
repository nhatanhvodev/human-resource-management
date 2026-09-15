package com.company.hrms.shared.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.company.hrms.shared.interfaces.api.PageResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import org.springframework.security.crypto.password.PasswordEncoder;

import java.security.SecureRandom;
import java.sql.Types;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class RbacAuthorityService {
    private static final Logger log = LoggerFactory.getLogger(RbacAuthorityService.class);
    private final JdbcTemplate jdbcTemplate;
    private final PasswordEncoder passwordEncoder;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public RbacAuthorityService(JdbcTemplate jdbcTemplate, PasswordEncoder passwordEncoder) {
        this.jdbcTemplate = jdbcTemplate;
        this.passwordEncoder = passwordEncoder;
    }

    /**
     * P1: cached — this runs on every authenticated request (3-4 queries).
     * Evicted by all role/user/permission mutations below.
     */
    @Cacheable(value = "rbacAccess", key = "#tenantId + '|' + #subject + '|' + #employeeId")
    public AccessSnapshot currentAccess(String tenantId, String subject, String employeeId) {
        Optional<UserRow> user = findUser(tenantId, subject, employeeId);
        if (user.isEmpty()) {
            return new AccessSnapshot(null, subject, subject, null, List.of(), List.of(), List.of());
        }

        UUID userId = user.get().id();
        return new AccessSnapshot(
            userId,
            user.get().username(),
            user.get().displayName(),
            user.get().employeeId(),
            listRoleCodes(userId),
            listPermissionCodes(userId),
            listScopedDepartmentIds(userId)
        );
    }

    public List<PermissionResponse> listPermissions() {
        return jdbcTemplate.query("""
            select code, module, action, description
            from security_permission
            order by module, action, code
            """, (rs, rowNum) -> new PermissionResponse(
            rs.getString("code"),
            rs.getString("module"),
            rs.getString("action"),
            rs.getString("description")
        ));
    }

    public List<RoleResponse> listRoles(String tenantId) {
        return jdbcTemplate.query("""
            select id, code, name, description, system_role
            from security_role
            where tenant_id = ?
            order by code
            """, (rs, rowNum) -> {
            UUID roleId = rs.getObject("id", UUID.class);
            return new RoleResponse(
                roleId,
                rs.getString("code"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getBoolean("system_role"),
                listPermissionCodesForRole(roleId)
            );
        }, tenantId);
    }

    public List<UserResponse> listUsers(String tenantId) {
        return jdbcTemplate.query("""
            select id, username, display_name, employee_id, enabled
            from app_user
            where tenant_id = ?
            order by username
            """, (rs, rowNum) -> {
            UUID userId = rs.getObject("id", UUID.class);
            return new UserResponse(
                userId,
                rs.getString("username"),
                rs.getString("display_name"),
                rs.getObject("employee_id", UUID.class),
                rs.getBoolean("enabled"),
                listRoleIds(userId)
            );
        }, tenantId);
    }

    @CacheEvict(value = {"rbacAccess", "rbacIdp"}, allEntries = true)
    @Transactional
    public void replaceRolePermissions(String tenantId, UUID roleId, List<String> permissionCodes) {
        assertRoleInTenant(tenantId, roleId);
        jdbcTemplate.update("delete from security_role_permission where role_id = ?", roleId);
        jdbcTemplate.batchUpdate(
            "insert into security_role_permission (role_id, permission_code) values (?, ?)",
            permissionCodes.stream().distinct().map(code -> new Object[] { roleId, code }).toList()
        );
        UUID actorId = currentUserId();
        if (actorId != null) {
            try {
                auditLog(tenantId, actorId, "ROLE_PERMISSIONS_CHANGED", "ROLE", roleId,
                    "{\"permissionCodes\": " + objectMapper.writeValueAsString(permissionCodes) + "}");
            } catch (Exception e) { log.warn("Failed to write audit log", e); }
        }
    }

    @CacheEvict(value = {"rbacAccess", "rbacIdp"}, allEntries = true)
    @Transactional
    public void replaceUserRoles(String tenantId, UUID userId, List<UUID> roleIds) {
        assertUserInTenant(tenantId, userId);
        roleIds.stream().distinct().forEach(roleId -> assertRoleInTenant(tenantId, roleId));
        jdbcTemplate.update("delete from security_user_role where user_id = ?", userId);
        jdbcTemplate.batchUpdate(
            "insert into security_user_role (user_id, role_id) values (?, ?)",
            roleIds.stream().distinct().map(roleId -> new Object[] { userId, roleId }).toList()
        );
        UUID actorId = currentUserId();
        if (actorId != null) {
            try {
                auditLog(tenantId, actorId, "USER_ROLES_CHANGED", "USER", userId,
                    "{\"roleIds\": " + objectMapper.writeValueAsString(roleIds) + "}");
            } catch (Exception e) { log.warn("Failed to write audit log", e); }
        }
    }

    // ── Task 5: Role CRUD + User management ──

    @CacheEvict(value = {"rbacAccess", "rbacIdp"}, allEntries = true)
    @Transactional
    public RoleResponse createRole(String tenantId, String code, String name, String description, UUID templateRoleId) {
        UUID id = UUID.randomUUID();
        jdbcTemplate.update(
            "insert into security_role (id, tenant_id, code, name, description, system_role, created_at, updated_at) values (?, ?, ?, ?, ?, false, now(), now())",
            id, tenantId, code, name, description
        );
        if (templateRoleId != null) {
            List<String> templatePermissions = listPermissionCodesForRole(templateRoleId);
            if (!templatePermissions.isEmpty()) {
                jdbcTemplate.batchUpdate(
                    "insert into security_role_permission (role_id, permission_code) values (?, ?)",
                    templatePermissions.stream().map(pc -> new Object[] { id, pc }).toList()
                );
            }
        }
        UUID actorId = currentUserId();
        if (actorId != null) {
            try {
                auditLog(tenantId, actorId, "ROLE_CREATED", "ROLE", id,
                    "{\"code\": \"" + code + "\", \"name\": \"" + name + "\"}");
            } catch (Exception e) { log.warn("Failed to write audit log", e); }
        }
        return new RoleResponse(id, code, name, description, false, templateRoleId != null ? listPermissionCodesForRole(id) : List.of());
    }

    @CacheEvict(value = {"rbacAccess", "rbacIdp"}, allEntries = true)
    @Transactional
    public void deleteRole(String tenantId, UUID roleId) {
        Integer isSystem = jdbcTemplate.queryForObject(
            "select count(*) from security_role where tenant_id = ? and id = ? and system_role = true",
            Integer.class, tenantId, roleId
        );
        if (isSystem != null && isSystem > 0) {
            throw new IllegalArgumentException("Cannot delete system role");
        }
        jdbcTemplate.update("delete from security_role where tenant_id = ? and id = ?", tenantId, roleId);
        UUID actorId = currentUserId();
        if (actorId != null) {
            try {
                auditLog(tenantId, actorId, "ROLE_DELETED", "ROLE", roleId, null);
            } catch (Exception e) { log.warn("Failed to write audit log", e); }
        }
    }

    @CacheEvict(value = {"rbacAccess", "rbacIdp"}, allEntries = true)
    @Transactional
    public UserResponse createUser(String tenantId, String username, String displayName, UUID employeeId) {
        UUID id = UUID.randomUUID();
        String initialPassword = generateInitialPassword();
        String passwordHash = passwordEncoder.encode(initialPassword);
        jdbcTemplate.update(
            "insert into app_user (id, tenant_id, username, display_name, employee_id, password_hash, enabled, created_at, updated_at) values (?, ?, ?, ?, ?, ?, true, now(), now())",
            id, tenantId, username, displayName, employeeId, passwordHash
        );
        UUID actorId = currentUserId();
        if (actorId != null) {
            try {
                auditLog(tenantId, actorId, "USER_CREATED", "USER", id,
                    "{\"username\": \"" + username + "\"}");
            } catch (Exception e) { log.warn("Failed to write audit log", e); }
        }
        return new UserResponse(id, username, displayName, employeeId, true, List.of());
    }

    @CacheEvict(value = {"rbacAccess", "rbacIdp"}, allEntries = true)
    @Transactional
    public void setUserEnabled(String tenantId, UUID userId, boolean enabled) {
        assertUserInTenant(tenantId, userId);
        jdbcTemplate.update("update app_user set enabled = ?, updated_at = now() where id = ?", enabled, userId);
        UUID actorId = currentUserId();
        if (actorId != null) {
            try {
                auditLog(tenantId, actorId, enabled ? "USER_ENABLED" : "USER_DISABLED", "USER", userId, null);
            } catch (Exception e) { log.warn("Failed to write audit log", e); }
        }
    }

    // ── Task 6: Department scope management ──

    public List<UUID> getUserScopes(String tenantId, UUID userId) {
        assertUserInTenant(tenantId, userId);
        return listScopedDepartmentIds(userId);
    }

    @CacheEvict(value = {"rbacAccess", "rbacIdp"}, allEntries = true)
    @Transactional
    public void setUserScopes(String tenantId, UUID userId, List<UUID> departmentIds) {
        assertUserInTenant(tenantId, userId);
        jdbcTemplate.update("delete from security_role_scope where user_id = ?", userId);
        if (departmentIds != null && !departmentIds.isEmpty()) {
            jdbcTemplate.batchUpdate(
                "insert into security_role_scope (id, user_id, department_id) values (?, ?, ?)",
                departmentIds.stream().distinct().map(deptId -> new Object[] { UUID.randomUUID(), userId, deptId }).toList()
            );
        }
        UUID actorId = currentUserId();
        if (actorId != null) {
            try {
                auditLog(tenantId, actorId, "USER_SCOPES_CHANGED", "USER", userId,
                    "{\"departmentIds\": " + objectMapper.writeValueAsString(departmentIds) + "}");
            } catch (Exception e) { log.warn("Failed to write audit log", e); }
        }
    }

    // ── Task 8: Audit trail ──

    private void auditLog(String tenantId, UUID actorId, String action, String targetType, UUID targetId, String detailJson) {
        jdbcTemplate.update(
            "insert into security_audit_log (id, tenant_id, actor_id, action, target_type, target_id, detail) values (?, ?, ?, ?, ?, ?, ?::jsonb)",
            UUID.randomUUID(), tenantId, actorId, action, targetType, targetId, detailJson
        );
    }

    public record AuditEntry(UUID id, UUID actorId, String action, String targetType, UUID targetId, String detail, Instant createdAt) {}

    public PageResponse<AuditEntry> listAudit(String tenantId, Pageable pageable) {
        List<AuditEntry> items = jdbcTemplate.query(
            "select id, actor_id, action, target_type, target_id, detail, created_at from security_audit_log where tenant_id = ? order by created_at desc limit ? offset ?",
            (rs, rowNum) -> new AuditEntry(
                rs.getObject("id", UUID.class),
                rs.getObject("actor_id", UUID.class),
                rs.getString("action"),
                rs.getString("target_type"),
                rs.getObject("target_id", UUID.class),
                rs.getString("detail"),
                rs.getTimestamp("created_at").toInstant()
            ),
            tenantId, pageable.getPageSize(), pageable.getOffset()
        );
        Long total = jdbcTemplate.queryForObject("select count(*) from security_audit_log where tenant_id = ?", Long.class, tenantId);
        long totalItems = total != null ? total : 0;
        int totalPages = pageable.getPageSize() > 0 ? (int) Math.ceil((double) totalItems / pageable.getPageSize()) : 0;
        return new PageResponse<>(items, pageable.getPageNumber(), pageable.getPageSize(), totalItems, totalPages);
    }

    private UUID currentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            String subject = jwtAuth.getToken().getSubject();
            return parseUuid(subject);
        }
        return null;
    }

    // ── Task 9: IdP group-to-role mapping ──

    @Cacheable(value = "rbacIdp", key = "'groups|' + #tenantId + '|' + #idpGroups")
    public List<UUID> resolveIdpRoleIds(String tenantId, List<String> idpGroups) {
        if (idpGroups == null || idpGroups.isEmpty()) return List.of();
        return jdbcTemplate.queryForList(
            "select distinct role_id from security_idp_mapping where tenant_id = ? and idp_group = any(?)",
            UUID.class, tenantId, (Object) idpGroups.toArray(new String[0])
        );
    }

    @Cacheable(value = "rbacIdp", key = "'perms|' + #roleIds")
    public List<String> listPermissionCodesForRoles(List<UUID> roleIds) {
        if (roleIds == null || roleIds.isEmpty()) return List.of();
        return jdbcTemplate.queryForList(
            "select distinct rp.permission_code from security_role_permission rp where rp.role_id = any(?) order by rp.permission_code",
            String.class, (Object) roleIds.toArray(new UUID[0])
        );
    }

    public record IdpMappingResponse(UUID id, String idpGroup, UUID roleId, String roleCode) {}

    public List<IdpMappingResponse> listIdpMappings(String tenantId) {
        return jdbcTemplate.query(
            "select im.id, im.idp_group, im.role_id, r.code from security_idp_mapping im join security_role r on r.id = im.role_id where im.tenant_id = ? order by im.idp_group",
            (rs, rowNum) -> new IdpMappingResponse(
                rs.getObject("id", UUID.class),
                rs.getString("idp_group"),
                rs.getObject("role_id", UUID.class),
                rs.getString("code")
            ),
            tenantId
        );
    }

    @CacheEvict(value = {"rbacAccess", "rbacIdp"}, allEntries = true)
    @Transactional
    public IdpMappingResponse createIdpMapping(String tenantId, String idpGroup, UUID roleId) {
        assertRoleInTenant(tenantId, roleId);
        UUID id = UUID.randomUUID();
        jdbcTemplate.update(
            "insert into security_idp_mapping (id, tenant_id, idp_group, role_id) values (?, ?, ?, ?)",
            id, tenantId, idpGroup, roleId
        );
        String roleCode = jdbcTemplate.queryForObject("select code from security_role where id = ?", String.class, roleId);
        UUID actorId = currentUserId();
        if (actorId != null) {
            try {
                auditLog(tenantId, actorId, "IDP_MAPPING_CREATED", "IDP_MAPPING", id,
                    "{\"idpGroup\": " + objectMapper.writeValueAsString(idpGroup) + ", \"roleId\": \"" + roleId + "\"}");
            } catch (Exception e) { log.warn("Failed to write audit log", e); }
        }
        return new IdpMappingResponse(id, idpGroup, roleId, roleCode);
    }

    @CacheEvict(value = {"rbacAccess", "rbacIdp"}, allEntries = true)
    @Transactional
    public void deleteIdpMapping(String tenantId, UUID mappingId) {
        jdbcTemplate.update("delete from security_idp_mapping where tenant_id = ? and id = ?", tenantId, mappingId);
        UUID actorId = currentUserId();
        if (actorId != null) {
            try {
                auditLog(tenantId, actorId, "IDP_MAPPING_DELETED", "IDP_MAPPING", mappingId, null);
            } catch (Exception e) { log.warn("Failed to write audit log", e); }
        }
    }

    private Optional<UserRow> findUser(String tenantId, String subject, String employeeId) {
        UUID subjectUuid = parseUuid(subject);
        UUID employeeUuid = parseUuid(employeeId);
        if (subjectUuid == null && employeeUuid == null) {
            return jdbcTemplate.query("""
                select id, username, display_name, employee_id
                from app_user
                where tenant_id = ? and enabled = true and username = ?
                """, (rs, rowNum) -> userRow(rs.getObject("id", UUID.class), rs.getString("username"),
                rs.getString("display_name"), rs.getObject("employee_id", UUID.class)), tenantId, subject)
                .stream().findFirst();
        }

        return jdbcTemplate.query(con -> {
            var ps = con.prepareStatement("""
                select id, username, display_name, employee_id
                from app_user
                where tenant_id = ? and enabled = true and (username = ? or id = ? or employee_id = ?)
                """);
            ps.setString(1, tenantId);
            ps.setString(2, subject == null ? "" : subject);
            if (subjectUuid == null) {
                ps.setNull(3, Types.OTHER);
            } else {
                ps.setObject(3, subjectUuid);
            }
            if (employeeUuid == null) {
                ps.setNull(4, Types.OTHER);
            } else {
                ps.setObject(4, employeeUuid);
            }
            return ps;
        }, (rs, rowNum) -> userRow(rs.getObject("id", UUID.class), rs.getString("username"),
            rs.getString("display_name"), rs.getObject("employee_id", UUID.class))).stream().findFirst();
    }

    private List<String> listRoleCodes(UUID userId) {
        return jdbcTemplate.queryForList("""
            select r.code
            from security_role r
            join security_user_role ur on ur.role_id = r.id
            where ur.user_id = ?
            order by r.code
            """, String.class, userId);
    }

    private List<UUID> listRoleIds(UUID userId) {
        return jdbcTemplate.queryForList("""
            select r.id
            from security_role r
            join security_user_role ur on ur.role_id = r.id
            where ur.user_id = ?
            order by r.code
            """, UUID.class, userId);
    }

    private List<String> listPermissionCodes(UUID userId) {
        return jdbcTemplate.queryForList("""
            select distinct rp.permission_code
            from security_role_permission rp
            join security_user_role ur on ur.role_id = rp.role_id
            where ur.user_id = ?
            order by rp.permission_code
            """, String.class, userId);
    }

    private List<UUID> listScopedDepartmentIds(UUID userId) {
        return jdbcTemplate.queryForList(
            "select department_id from security_role_scope where user_id = ?",
            UUID.class, userId
        );
    }

    private List<String> listPermissionCodesForRole(UUID roleId) {
        return jdbcTemplate.queryForList("""
            select permission_code
            from security_role_permission
            where role_id = ?
            order by permission_code
            """, String.class, roleId);
    }

    private void assertRoleInTenant(String tenantId, UUID roleId) {
        Integer count = jdbcTemplate.queryForObject(
            "select count(*) from security_role where tenant_id = ? and id = ?",
            Integer.class,
            tenantId,
            roleId
        );
        if (count == null || count == 0) {
            throw new IllegalArgumentException("Role not found in tenant");
        }
    }

    private void assertUserInTenant(String tenantId, UUID userId) {
        Integer count = jdbcTemplate.queryForObject(
            "select count(*) from app_user where tenant_id = ? and id = ?",
            Integer.class,
            tenantId,
            userId
        );
        if (count == null || count == 0) {
            throw new IllegalArgumentException("User not found in tenant");
        }
    }

    @Transactional
    public void setUserPassword(String tenantId, UUID userId, String rawPassword) {
        assertUserInTenant(tenantId, userId);
        String passwordHash = passwordEncoder.encode(rawPassword);
        jdbcTemplate.update("update app_user set password_hash = ?, updated_at = now() where id = ?", passwordHash, userId);
        UUID actorId = currentUserId();
        if (actorId != null) {
            try {
                auditLog(tenantId, actorId, "PASSWORD_CHANGED", "USER", userId, null);
            } catch (Exception e) { log.warn("Failed to write audit log", e); }
        }
    }

    private static String generateInitialPassword() {
        byte[] bytes = new byte[6];
        new SecureRandom().nextBytes(bytes);
        return java.util.Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    private static UUID parseUuid(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return UUID.fromString(value);
        } catch (IllegalArgumentException ignored) {
            return null;
        }
    }

    private static UserRow userRow(UUID id, String username, String displayName, UUID employeeId) {
        return new UserRow(id, username, displayName, employeeId);
    }

    private record UserRow(UUID id, String username, String displayName, UUID employeeId) {
    }

    public record AccessSnapshot(
        UUID userId,
        String username,
        String displayName,
        UUID employeeId,
        List<String> roles,
        List<String> authorities,
        List<UUID> scopedDepartmentIds
    ) {
    }

    public record PermissionResponse(String code, String module, String action, String description) {
    }

    public record RoleResponse(
        UUID id,
        String code,
        String name,
        String description,
        boolean systemRole,
        List<String> permissionCodes
    ) {
    }

    public record UserResponse(
        UUID id,
        String username,
        String displayName,
        UUID employeeId,
        boolean enabled,
        List<UUID> roleIds
    ) {
    }
}
