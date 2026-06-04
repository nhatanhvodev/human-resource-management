package com.company.hrms.employee.domain;

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

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "employee_contract")
public class EmployeeContract extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @Enumerated(EnumType.STRING)
    @Column(name = "contract_type", nullable = false, length = 20)
    private ContractType contractType;

    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    @Column(name = "salary", nullable = false, precision = 15, scale = 2)
    private BigDecimal salary;

    protected EmployeeContract() {}

    public EmployeeContract(UUID id, String tenantId, Employee employee, ContractType contractType,
                           LocalDate startDate, LocalDate endDate, BigDecimal salary) {
        this.id = id;
        this.tenantId = tenantId;
        this.employee = employee;
        this.contractType = contractType;
        this.startDate = startDate;
        this.endDate = endDate;
        this.salary = salary;
    }

    public UUID getId() { return id; }
    public Employee getEmployee() { return employee; }
    public ContractType getContractType() { return contractType; }
    public LocalDate getStartDate() { return startDate; }
    public LocalDate getEndDate() { return endDate; }
    public BigDecimal getSalary() { return salary; }
}
