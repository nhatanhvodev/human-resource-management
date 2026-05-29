package com.company.hrms.employee.domain;

import com.company.hrms.organization.domain.Department;
import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "employee")
public class Employee extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @Column(name = "employee_no", nullable = false, length = 50)
    private String employeeNo;

    @Column(name = "full_name", nullable = false, length = 255)
    private String fullName;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @Column(name = "hire_date", nullable = false)
    private LocalDate hireDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "employment_status", nullable = false, length = 30)
    private EmploymentStatus employmentStatus;

    protected Employee() {
    }

    public Employee(UUID id,
                    String tenantId,
                    String employeeNo,
                    String fullName,
                    Department department,
                    LocalDate hireDate,
                    EmploymentStatus employmentStatus) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeNo = employeeNo;
        this.fullName = fullName;
        this.department = department;
        this.hireDate = hireDate;
        this.employmentStatus = employmentStatus;
    }

    public UUID getId() {
        return id;
    }

    public String getTenantId() {
        return tenantId;
    }

    public String getEmployeeNo() {
        return employeeNo;
    }

    public String getFullName() {
        return fullName;
    }

    public Department getDepartment() {
        return department;
    }

    public LocalDate getHireDate() {
        return hireDate;
    }

    public EmploymentStatus getEmploymentStatus() {
        return employmentStatus;
    }
}
