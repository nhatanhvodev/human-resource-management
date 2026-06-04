package com.company.hrms.payroll.domain;

import com.company.hrms.employee.domain.Employee;
import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "salary_structure")
public class SalaryStructure extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @Column(name = "basic_salary", nullable = false, precision = 15, scale = 2)
    private BigDecimal basicSalary;

    @Column(name = "allowance", nullable = false, precision = 15, scale = 2)
    private BigDecimal allowance;

    @Column(name = "deduction", nullable = false, precision = 15, scale = 2)
    private BigDecimal deduction;

    @Column(name = "effective_from", nullable = false)
    private LocalDate effectiveFrom;

    @Column(name = "effective_to")
    private LocalDate effectiveTo;

    protected SalaryStructure() {}

    public SalaryStructure(UUID id, String tenantId, Employee employee, BigDecimal basicSalary,
                           BigDecimal allowance, BigDecimal deduction, LocalDate effectiveFrom, LocalDate effectiveTo) {
        this.id = id;
        this.tenantId = tenantId;
        this.employee = employee;
        this.basicSalary = basicSalary;
        this.allowance = allowance;
        this.deduction = deduction;
        this.effectiveFrom = effectiveFrom;
        this.effectiveTo = effectiveTo;
    }

    public UUID getId() { return id; }
    public Employee getEmployee() { return employee; }
    public BigDecimal getBasicSalary() { return basicSalary; }
    public BigDecimal getAllowance() { return allowance; }
    public BigDecimal getDeduction() { return deduction; }
    public LocalDate getEffectiveFrom() { return effectiveFrom; }
    public LocalDate getEffectiveTo() { return effectiveTo; }
}
