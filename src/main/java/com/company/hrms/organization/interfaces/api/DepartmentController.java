package com.company.hrms.organization.interfaces.api;

import com.company.hrms.organization.application.DepartmentService;
import com.company.hrms.organization.domain.Department;
import jakarta.validation.constraints.NotBlank;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/departments")
@Validated
public class DepartmentController {
    private final DepartmentService departmentService;

    public DepartmentController(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    @PostMapping
    @PreAuthorize("hasAuthority('department:create')")
    public ResponseEntity<DepartmentResponse> create(@RequestBody CreateDepartmentRequest request) {
        Department department = departmentService.create(request.code(), request.name());
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(new DepartmentResponse(department.getId(), department.getCode(), department.getName()));
    }

    public record CreateDepartmentRequest(@NotBlank String code, @NotBlank String name) {
    }

    public record DepartmentResponse(UUID id, String code, String name) {
    }
}
