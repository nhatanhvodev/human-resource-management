package com.company.hrms.payroll.domain;

import com.company.hrms.employee.domain.Employee;
import com.company.hrms.shared.domain.AuditableEntity;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "payslip")
public class Payslip extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "payroll_run_id", nullable = false)
    private PayrollRun payrollRun;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @Column(name = "basic_salary", nullable = false, precision = 15, scale = 2)
    private BigDecimal basicSalary;

    @Column(name = "allowance", nullable = false, precision = 15, scale = 2)
    private BigDecimal allowance;

    @Column(name = "deduction", nullable = false, precision = 15, scale = 2)
    private BigDecimal deduction;

    @Column(name = "overtime_pay", nullable = false, precision = 15, scale = 2)
    private BigDecimal overtimePay;

    @Column(name = "net_pay", nullable = false, precision = 15, scale = 2)
    private BigDecimal netPay;

    @Column(name = "issued_at")
    private Instant issuedAt;

    protected Payslip() {}

    public Payslip(UUID id, String tenantId, PayrollRun payrollRun, Employee employee,
                   BigDecimal basicSalary, BigDecimal allowance, BigDecimal deduction,
                   BigDecimal overtimePay, BigDecimal netPay) {
        this.id = id;
        this.tenantId = tenantId;
        this.payrollRun = payrollRun;
        this.employee = employee;
        this.basicSalary = basicSalary;
        this.allowance = allowance;
        this.deduction = deduction;
        this.overtimePay = overtimePay;
        this.netPay = netPay;
        this.issuedAt = Instant.now();
    }

    public UUID getId() { return id; }
    public PayrollRun getPayrollRun() { return payrollRun; }
    public Employee getEmployee() { return employee; }
    public BigDecimal getBasicSalary() { return basicSalary; }
    public BigDecimal getAllowance() { return allowance; }
    public BigDecimal getDeduction() { return deduction; }
    public BigDecimal getOvertimePay() { return overtimePay; }
    public BigDecimal getNetPay() { return netPay; }
    public Instant getIssuedAt() { return issuedAt; }
}
