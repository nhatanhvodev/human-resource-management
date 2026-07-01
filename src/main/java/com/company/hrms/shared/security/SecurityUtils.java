package com.company.hrms.shared.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;

import java.util.UUID;

public final class SecurityUtils {

    private SecurityUtils() {
    }

    /**
     * Gets the current authenticated user's ID from the JWT {@code sub} claim.
     *
     * @return the user ID, or {@code null} if not authenticated or claim missing
     */
    public static UUID getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            String userId = jwtAuth.getToken().getSubject();
            if (userId != null && !userId.isBlank()) {
                try {
                    return UUID.fromString(userId);
                } catch (IllegalArgumentException ignored) {
                    // subject is not a UUID (e.g., local dev token "admin")
                    return null;
                }
            }
        }
        return null;
    }

    /**
     * Gets the display name of the current authenticated user from JWT claims.
     * Checks {@code display_name}, {@code name}, then {@code preferred_username} claims in order.
     *
     * @return the display name, or {@code null} if not authenticated or no claim found
     */
    public static String getCurrentUserDisplayName() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            String displayName = jwtAuth.getToken().getClaimAsString("display_name");
            if (displayName != null && !displayName.isBlank()) {
                return displayName;
            }
            String name = jwtAuth.getToken().getClaimAsString("name");
            if (name != null && !name.isBlank()) {
                return name;
            }
            String preferredUsername = jwtAuth.getToken().getClaimAsString("preferred_username");
            if (preferredUsername != null && !preferredUsername.isBlank()) {
                return preferredUsername;
            }
        }
        return null;
    }

    /**
     * Gets the current authenticated user's employee ID from the JWT {@code employee_id} claim.
     *
     * @return the employee ID, or {@code null} if not authenticated or claim missing
     */
    public static UUID getCurrentEmployeeId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            String empId = jwtAuth.getToken().getClaimAsString("employee_id");
            if (empId != null) {
                return UUID.fromString(empId);
            }
        }
        return null;
    }

    /**
     * Gets the preferred username of the current authenticated user from JWT claims.
     *
     * @deprecated Use {@link #getCurrentUserDisplayName()} for a more robust display-name resolution.
     * @return the preferred username, or {@code null} if not authenticated or claim missing
     */
    @Deprecated
    public static String getCurrentEmployeeName() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            String name = jwtAuth.getToken().getClaimAsString("preferred_username");
            if (name != null) {
                return name;
            }
        }
        return null;
    }
}
