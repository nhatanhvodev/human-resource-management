package com.company.hrms.shared.security;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Types;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class RbacAuthorityService {
    private final JdbcTemplate jdbcTemplate;

    public RbacAuthorityService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

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

    @Transactional
    public void replaceRolePermissions(String tenantId, UUID roleId, List<String> permissionCodes) {
        assertRoleInTenant(tenantId, roleId);
        jdbcTemplate.update("delete from security_role_permission where role_id = ?", roleId);
        jdbcTemplate.batchUpdate(
            "insert into security_role_permission (role_id, permission_code) values (?, ?)",
            permissionCodes.stream().distinct().map(code -> new Object[] { roleId, code }).toList()
        );
    }

    @Transactional
    public void replaceUserRoles(String tenantId, UUID userId, List<UUID> roleIds) {
        assertUserInTenant(tenantId, userId);
        roleIds.stream().distinct().forEach(roleId -> assertRoleInTenant(tenantId, roleId));
        jdbcTemplate.update("delete from security_user_role where user_id = ?", userId);
        jdbcTemplate.batchUpdate(
            "insert into security_user_role (user_id, role_id) values (?, ?)",
            roleIds.stream().distinct().map(roleId -> new Object[] { userId, roleId }).toList()
        );
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
