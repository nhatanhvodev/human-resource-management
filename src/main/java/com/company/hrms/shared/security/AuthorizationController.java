package com.company.hrms.shared.security;

import com.company.hrms.shared.interfaces.api.PageResponse;
import com.company.hrms.shared.security.RbacAuthorityService.AccessSnapshot;
import com.company.hrms.shared.security.RbacAuthorityService.AuditEntry;
import com.company.hrms.shared.security.RbacAuthorityService.IdpMappingResponse;
import com.company.hrms.shared.security.RbacAuthorityService.PermissionResponse;
import com.company.hrms.shared.security.RbacAuthorityService.RoleResponse;
import com.company.hrms.shared.security.RbacAuthorityService.UserResponse;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/authz")
public class AuthorizationController {
    private final RbacAuthorityService rbacAuthorityService;

    public AuthorizationController(RbacAuthorityService rbacAuthorityService) {
        this.rbacAuthorityService = rbacAuthorityService;
    }

    @GetMapping("/me")
    public AccessSnapshot currentAccess(Authentication authentication) {
        Jwt jwt = ((JwtAuthenticationToken) authentication).getToken();
        return rbacAuthorityService.currentAccess(tenantId(), jwt.getSubject(), jwt.getClaimAsString("employee_id"));
    }

    @GetMapping("/permissions")
    @PreAuthorize("hasAuthority('authz:read')")
    public List<PermissionResponse> listPermissions() {
        return rbacAuthorityService.listPermissions();
    }

    @GetMapping("/roles")
    @PreAuthorize("hasAuthority('authz:read')")
    public List<RoleResponse> listRoles() {
        return rbacAuthorityService.listRoles(tenantId());
    }

    @PostMapping("/roles")
    @PreAuthorize("hasAuthority('authz:update')")
    public ResponseEntity<RoleResponse> createRole(@RequestBody CreateRoleRequest request) {
        RoleResponse role = rbacAuthorityService.createRole(tenantId(), request.code(), request.name(), request.description(), request.templateRoleId());
        return ResponseEntity.created(URI.create("/api/v1/authz/roles/" + role.id())).body(role);
    }

    @DeleteMapping("/roles/{roleId}")
    @PreAuthorize("hasAuthority('authz:update')")
    public void deleteRole(@PathVariable UUID roleId) {
        rbacAuthorityService.deleteRole(tenantId(), roleId);
    }

    @PutMapping("/roles/{roleId}/permissions")
    @PreAuthorize("hasAuthority('authz:update')")
    public void replaceRolePermissions(@PathVariable UUID roleId, @RequestBody ReplaceRolePermissionsRequest request) {
        rbacAuthorityService.replaceRolePermissions(tenantId(), roleId, request.permissionCodes());
    }

    @GetMapping("/users")
    @PreAuthorize("hasAuthority('authz:read')")
    public List<UserResponse> listUsers() {
        return rbacAuthorityService.listUsers(tenantId());
    }

    @PostMapping("/users")
    @PreAuthorize("hasAuthority('authz:update')")
    public ResponseEntity<UserResponse> createUser(@RequestBody CreateUserRequest request) {
        UserResponse user = rbacAuthorityService.createUser(tenantId(), request.username(), request.displayName(), request.employeeId());
        return ResponseEntity.created(URI.create("/api/v1/authz/users/" + user.id())).body(user);
    }

    @PutMapping("/users/{userId}/roles")
    @PreAuthorize("hasAuthority('authz:update')")
    public void replaceUserRoles(@PathVariable UUID userId, @RequestBody ReplaceUserRolesRequest request) {
        rbacAuthorityService.replaceUserRoles(tenantId(), userId, request.roleIds());
    }

    @PutMapping("/users/{userId}/enabled")
    @PreAuthorize("hasAuthority('authz:update')")
    public void toggleUserEnabled(@PathVariable UUID userId, @RequestBody ToggleEnabledRequest request) {
        rbacAuthorityService.setUserEnabled(tenantId(), userId, request.enabled());
    }

    @GetMapping("/users/{userId}/scopes")
    @PreAuthorize("hasAuthority('authz:read')")
    public List<UUID> getUserScopes(@PathVariable UUID userId) {
        return rbacAuthorityService.getUserScopes(tenantId(), userId);
    }

    @PutMapping("/users/{userId}/scopes")
    @PreAuthorize("hasAuthority('authz:update')")
    public void setUserScopes(@PathVariable UUID userId, @RequestBody SetScopesRequest request) {
        rbacAuthorityService.setUserScopes(tenantId(), userId, request.departmentIds());
    }

    @GetMapping("/audit")
    @PreAuthorize("hasAuthority('authz:read')")
    public PageResponse<AuditEntry> listAudit(Pageable pageable) {
        return rbacAuthorityService.listAudit(tenantId(), pageable);
    }

    @GetMapping("/idp-mappings")
    @PreAuthorize("hasAuthority('authz:read')")
    public List<IdpMappingResponse> listIdpMappings() {
        return rbacAuthorityService.listIdpMappings(tenantId());
    }

    @PostMapping("/idp-mappings")
    @PreAuthorize("hasAuthority('authz:update')")
    public ResponseEntity<IdpMappingResponse> createIdpMapping(@RequestBody CreateIdpMappingRequest request) {
        IdpMappingResponse mapping = rbacAuthorityService.createIdpMapping(tenantId(), request.idpGroup(), request.roleId());
        return ResponseEntity.created(URI.create("/api/v1/authz/idp-mappings/" + mapping.id())).body(mapping);
    }

    @DeleteMapping("/idp-mappings/{mappingId}")
    @PreAuthorize("hasAuthority('authz:update')")
    public void deleteIdpMapping(@PathVariable UUID mappingId) {
        rbacAuthorityService.deleteIdpMapping(tenantId(), mappingId);
    }

    private static String tenantId() {
        String tenantId = TenantContext.get();
        return tenantId == null || tenantId.isBlank() ? "default" : tenantId;
    }

    public record ReplaceRolePermissionsRequest(List<String> permissionCodes) {}
    public record ReplaceUserRolesRequest(List<UUID> roleIds) {}
    public record CreateRoleRequest(String code, String name, String description, UUID templateRoleId) {}
    public record CreateUserRequest(String username, String displayName, UUID employeeId) {}
    public record ToggleEnabledRequest(boolean enabled) {}
    public record SetScopesRequest(List<UUID> departmentIds) {}
    public record CreateIdpMappingRequest(String idpGroup, UUID roleId) {}
}
