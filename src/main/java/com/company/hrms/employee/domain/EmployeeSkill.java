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

import java.util.UUID;

@Entity
@Table(name = "employee_skill")
public class EmployeeSkill extends AuditableEntity {
    @Id
    private UUID id;

    @Column(name = "tenant_id", nullable = false, length = 64)
    private String tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @Column(name = "skill_name", nullable = false, length = 100)
    private String skillName;

    @Enumerated(EnumType.STRING)
    @Column(name = "proficiency_level", nullable = false, length = 20)
    private ProficiencyLevel proficiencyLevel;

    protected EmployeeSkill() {}

    public EmployeeSkill(UUID id, String tenantId, Employee employee, String skillName, ProficiencyLevel proficiencyLevel) {
        this.id = id;
        this.tenantId = tenantId;
        this.employee = employee;
        this.skillName = skillName;
        this.proficiencyLevel = proficiencyLevel;
    }

    public UUID getId() { return id; }
    public Employee getEmployee() { return employee; }
    public String getSkillName() { return skillName; }
    public ProficiencyLevel getProficiencyLevel() { return proficiencyLevel; }
}
