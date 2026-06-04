package com.company.hrms.organization.interfaces.api;

import com.company.hrms.organization.application.DepartmentService;
import com.company.hrms.organization.domain.Department;
import com.company.hrms.shared.interfaces.api.PageResponse;
import jakarta.validation.constraints.NotBlank;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/departments")
@Validated
public class DepartmentController {
    private final DepartmentService departmentService;

    public DepartmentController(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    @GetMapping
    @PreAuthorize("hasAuthority('department:read')")
    public PageResponse<DepartmentResponse> list(@RequestParam(required = false) String q, Pageable pageable) {
        return PageResponse.from(
            departmentService.list(q, pageable)
                .map(department -> new DepartmentResponse(department.getId(), department.getCode(), department.getName()))
        );
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('department:read')")
    public DepartmentResponse getById(@PathVariable UUID id) {
        Department department = departmentService.getById(id);
        return new DepartmentResponse(department.getId(), department.getCode(), department.getName());
    }

    @PostMapping
    @PreAuthorize("hasAuthority('department:create')")
    public ResponseEntity<DepartmentResponse> create(@RequestBody CreateDepartmentRequest request) {
        Department department = departmentService.create(request.code(), request.name());
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(new DepartmentResponse(department.getId(), department.getCode(), department.getName()));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('department:update')")
    public DepartmentResponse update(@PathVariable UUID id, @RequestBody CreateDepartmentRequest request) {
        Department department = departmentService.update(id, request.code(), request.name());
        return new DepartmentResponse(department.getId(), department.getCode(), department.getName());
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('department:delete')")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable UUID id) {
        departmentService.delete(id);
    }

    @GetMapping("/tree")
    @PreAuthorize("hasAuthority('department:read')")
    public List<DepartmentService.DepartmentTreeNode> tree() {
        return departmentService.tree();
    }

    public record CreateDepartmentRequest(@NotBlank String code, @NotBlank String name) {
    }

    public record DepartmentResponse(UUID id, String code, String name) {
    }
}
