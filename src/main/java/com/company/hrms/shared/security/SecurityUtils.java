package com.company.hrms.shared.security;

import com.company.hrms.shared.exception.ForbiddenException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;

import java.util.Optional;
import java.util.UUID;

public final class SecurityUtils {

    private SecurityUtils() {
    }

    public static Optional<UUID> getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            String userId = jwtAuth.getToken().getSubject();
            if (userId != null && !userId.isBlank()) {
                try {
                    return Optional.of(UUID.fromString(userId));
                } catch (IllegalArgumentException ignored) {
                    return Optional.empty();
                }
            }
        }
        return Optional.empty();
    }

    public static Optional<String> getCurrentUserDisplayName() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            String displayName = jwtAuth.getToken().getClaimAsString("display_name");
            if (displayName != null && !displayName.isBlank()) {
                return Optional.of(displayName);
            }
            String name = jwtAuth.getToken().getClaimAsString("name");
            if (name != null && !name.isBlank()) {
                return Optional.of(name);
            }
            String preferredUsername = jwtAuth.getToken().getClaimAsString("preferred_username");
            if (preferredUsername != null && !preferredUsername.isBlank()) {
                return Optional.of(preferredUsername);
            }
        }
        return Optional.empty();
    }

    public static Optional<UUID> getCurrentEmployeeId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            String empId = jwtAuth.getToken().getClaimAsString("employee_id");
            if (empId != null && !empId.isBlank()) {
                try {
                    return Optional.of(UUID.fromString(empId.trim()));
                } catch (IllegalArgumentException ignored) {
                    return Optional.empty();
                }
            }
        }
        return Optional.empty();
    }

    /**
     * Resolve the employee id for "mine"/self endpoints.
     * P0 IDOR fix: the JWT claim wins. The legacy {@code X-Employee-Id} header
     * is only honored when the JWT carries no employee_id (tests, service
     * accounts) — never as an override.
     */
    public static UUID resolveSelfEmployeeId(UUID headerEmployeeId) {
        Optional<UUID> jwtEmployeeId = getCurrentEmployeeId();
        if (jwtEmployeeId.isPresent()) {
            return jwtEmployeeId.get();
        }
        if (headerEmployeeId != null) {
            return headerEmployeeId;
        }
        throw new ForbiddenException("Missing employee identity");
    }

    public static UUID requireCurrentEmployeeId() {
        return getCurrentEmployeeId()
                .orElseThrow(() -> new ForbiddenException("Missing employee identity"));
    }

    @Deprecated
    public static Optional<String> getCurrentEmployeeName() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            String name = jwtAuth.getToken().getClaimAsString("preferred_username");
            if (name != null) {
                return Optional.of(name);
            }
        }
        return Optional.empty();
    }
}
