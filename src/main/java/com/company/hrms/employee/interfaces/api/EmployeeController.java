package com.company.hrms.employee.interfaces.api;

import com.company.hrms.employee.application.EmployeeService;
import com.company.hrms.employee.domain.Employee;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/employees")
@Validated
public class EmployeeController {
    private final EmployeeService employeeService;

    public EmployeeController(EmployeeService employeeService) {
        this.employeeService = employeeService;
    }

    @GetMapping
    @PreAuthorize("hasAuthority('employee:read')")
    public List<EmployeeResponse> list() {
        return employeeService.list().stream().map(EmployeeController::toResponse).toList();
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('employee:read')")
    public EmployeeResponse getById(@PathVariable UUID id) {
        return toResponse(employeeService.getById(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('employee:create')")
    public EmployeeResponse create(@RequestBody CreateEmployeeRequest request) {
        return toResponse(employeeService.create(
            request.employeeNo(),
            request.fullName(),
            request.departmentId(),
            request.hireDate()
        ));
    }

    @PatchMapping("/{id}")
    @PreAuthorize("hasAuthority('employee:update')")
    public EmployeeResponse patch(@PathVariable UUID id) {
        return toResponse(employeeService.getById(id));
    }

    private static EmployeeResponse toResponse(Employee employee) {
        return new EmployeeResponse(
            employee.getId(),
            employee.getEmployeeNo(),
            employee.getFullName(),
            employee.getDepartment().getId(),
            employee.getEmploymentStatus().name(),
            employee.getHireDate()
        );
    }

    public record CreateEmployeeRequest(@NotBlank String employeeNo,
                                        @NotBlank String fullName,
                                        @NotNull UUID departmentId,
                                        @NotNull LocalDate hireDate) {
    }

    public record EmployeeResponse(UUID id,
                                   String employeeNo,
                                   String fullName,
                                   UUID departmentId,
                                   String employmentStatus,
                                   LocalDate hireDate) {
    }
}
