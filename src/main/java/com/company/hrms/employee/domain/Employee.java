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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "position_id")
    private Position position;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "manager_id")
    private Employee manager;

    @Column(name = "hire_date", nullable = false)
    private LocalDate hireDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "employment_status", nullable = false, length = 30)
    private EmploymentStatus employmentStatus;

    @Column(name = "email", length = 255)
    private String email;

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Enumerated(EnumType.STRING)
    @Column(name = "gender", length = 10)
    private Gender gender;

    @Column(name = "national_id", length = 20)
    private String nationalId;

    @Column(name = "address")
    private String address;

    @Column(name = "bank_account", length = 30)
    private String bankAccount;

    @Column(name = "tax_code", length = 20)
    private String taxCode;

    protected Employee() {
    }

    public Employee(UUID id, String tenantId, String employeeNo, String fullName,
                    Department department, LocalDate hireDate, EmploymentStatus employmentStatus) {
        this.id = id;
        this.tenantId = tenantId;
        this.employeeNo = employeeNo;
        this.fullName = fullName;
        this.department = department;
        this.hireDate = hireDate;
        this.employmentStatus = employmentStatus;
    }

    public UUID getId() { return id; }
    public String getTenantId() { return tenantId; }
    public String getEmployeeNo() { return employeeNo; }
    public String getFullName() { return fullName; }
    public Department getDepartment() { return department; }
    public Position getPosition() { return position; }
    public Employee getManager() { return manager; }
    public UUID getManagerId() { return manager != null ? manager.getId() : null; }
    public LocalDate getHireDate() { return hireDate; }
    public EmploymentStatus getEmploymentStatus() { return employmentStatus; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public Gender getGender() { return gender; }
    public String getNationalId() { return nationalId; }
    public String getAddress() { return address; }
    public String getBankAccount() { return bankAccount; }
    public String getTaxCode() { return taxCode; }

    public void updateProfile(String fullName, Department department, LocalDate hireDate) {
        this.fullName = fullName;
        this.department = department;
        this.hireDate = hireDate;
    }

    public void updateExtendedProfile(String email, String phone, Position position, LocalDate dateOfBirth,
                                       Gender gender, String nationalId, String address,
                                       String bankAccount, String taxCode) {
        this.email = email;
        this.phone = phone;
        this.position = position;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.nationalId = nationalId;
        this.address = address;
        this.bankAccount = bankAccount;
        this.taxCode = taxCode;
    }

    public void changeStatus(EmploymentStatus status) {
        this.employmentStatus = status;
    }

    public void assignManager(Employee manager) {
        this.manager = manager;
    }
}
