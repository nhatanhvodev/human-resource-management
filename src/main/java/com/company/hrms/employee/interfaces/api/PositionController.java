package com.company.hrms.employee.interfaces.api;

import com.company.hrms.employee.domain.Position;
import com.company.hrms.employee.infrastructure.PositionRepository;
import com.company.hrms.shared.exception.NotFoundException;
import com.company.hrms.shared.interfaces.api.PageResponse;
import com.company.hrms.shared.tenant.TenantContext;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/positions")
public class PositionController {
    private final PositionRepository positionRepository;

    public PositionController(PositionRepository positionRepository) {
        this.positionRepository = positionRepository;
    }

    @GetMapping
    @PreAuthorize("hasAuthority('employee:read')")
    public PageResponse<PositionResponse> list(Pageable pageable) {
        return PageResponse.from(
            positionRepository.findAllByTenantId(TenantContext.get(), pageable)
                .map(PositionController::toResponse)
        );
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('employee:read')")
    public PositionResponse getById(@PathVariable UUID id) {
        return positionRepository.findByIdAndTenantId(id, TenantContext.get())
            .map(PositionController::toResponse)
            .orElseThrow(() -> new NotFoundException("POSITION_NOT_FOUND"));
    }

    private static PositionResponse toResponse(Position position) {
        return new PositionResponse(
            position.getId(),
            position.getCode(),
            position.getTitle(),
            position.getDepartment().getId()
        );
    }

    public record PositionResponse(UUID id, String code, String title, UUID departmentId) {
    }
}
