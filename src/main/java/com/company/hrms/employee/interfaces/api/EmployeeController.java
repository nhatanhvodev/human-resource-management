package com.company.hrms.employee.interfaces.api;

import com.company.hrms.employee.application.EmployeeService;
import com.company.hrms.employee.domain.Employee;
import com.company.hrms.employee.domain.EmploymentStatus;
import com.company.hrms.shared.interfaces.api.PageResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
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
    public PageResponse<EmployeeResponse> list(@RequestParam(required = false) String q,
                                               @RequestParam(required = false) String status,
                                               Pageable pageable) {
        return PageResponse.from(
            employeeService.list(q, status, pageable)
                .map(EmployeeController::toResponse)
        );
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('employee:read')")
    public EmployeeResponse getById(@PathVariable UUID id) {
        return toResponse(employeeService.getById(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('employee:create')")
    public EmployeeResponse create(@Valid @RequestBody CreateEmployeeRequest request) {
        return toResponse(employeeService.create(
            request.employeeNo(), request.fullName(), request.departmentId(), request.hireDate()
        ));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('employee:update')")
    public EmployeeResponse update(@PathVariable UUID id, @Valid @RequestBody UpdateEmployeeRequest request) {
        return toResponse(employeeService.update(
            id, request.fullName(), request.departmentId(), request.hireDate()
        ));
    }

    @PutMapping("/{id}/profile")
    @PreAuthorize("hasAuthority('employee:update')")
    public EmployeeResponse updateExtended(@PathVariable UUID id, @Valid @RequestBody UpdateExtendedRequest request) {
        return toResponse(employeeService.updateExtended(
            id, request.fullName(), request.departmentId(), request.hireDate(),
            request.email(), request.phone(), request.positionId(), request.dateOfBirth(),
            request.gender(), request.nationalId(), request.address(),
            request.bankAccount(), request.taxCode()
        ));
    }

    @PatchMapping("/{id}/status")
    @PreAuthorize("hasAuthority('employee:update')")
    public EmployeeResponse patchStatus(@PathVariable UUID id, @Valid @RequestBody UpdateStatusRequest request) {
        return toResponse(employeeService.changeStatus(id, request.employmentStatus()));
    }

    private static EmployeeResponse toResponse(Employee e) {
        return new EmployeeResponse(
            e.getId(), e.getEmployeeNo(), e.getFullName(),
            e.getDepartment().getId(), e.getEmploymentStatus().name(), e.getHireDate(),
            e.getEmail(), e.getPhone(),
            e.getPosition() != null ? e.getPosition().getId() : null,
            e.getPosition() != null ? e.getPosition().getTitle() : null,
            e.getDateOfBirth(), e.getGender() != null ? e.getGender().name() : null,
            e.getNationalId(), e.getAddress(), e.getBankAccount(), e.getTaxCode()
        );
    }

    public record CreateEmployeeRequest(@NotBlank String employeeNo, @NotBlank String fullName,
                                        @NotNull UUID departmentId, @NotNull LocalDate hireDate) {}

    public record UpdateEmployeeRequest(@NotBlank String fullName, @NotNull UUID departmentId,
                                        @NotNull LocalDate hireDate) {}

    public record UpdateExtendedRequest(@NotBlank String fullName, @NotNull UUID departmentId,
                                         @NotNull LocalDate hireDate, String email, String phone,
                                         UUID positionId, LocalDate dateOfBirth, String gender,
                                         String nationalId, String address,
                                         String bankAccount, String taxCode) {}

    public record UpdateStatusRequest(@NotNull EmploymentStatus employmentStatus) {}

    public record EmployeeResponse(UUID id, String employeeNo, String fullName,
                                    UUID departmentId, String employmentStatus, LocalDate hireDate,
                                    String email, String phone, UUID positionId, String positionTitle,
                                    LocalDate dateOfBirth, String gender,
                                    String nationalId, String address,
                                    String bankAccount, String taxCode) {}
}
