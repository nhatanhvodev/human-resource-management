-- V44: performance indexes for hot paths (login, per-request RBAC, ESS).
-- Plain CREATE INDEX IF NOT EXISTS: valid on both PostgreSQL and H2 (test).

CREATE INDEX IF NOT EXISTS idx_app_user_tenant_username
    ON app_user (tenant_id, username);
CREATE INDEX IF NOT EXISTS idx_app_user_employee
    ON app_user (employee_id);

CREATE INDEX IF NOT EXISTS idx_security_role_tenant_code
    ON security_role (tenant_id, code);
CREATE INDEX IF NOT EXISTS idx_security_user_role_user
    ON security_user_role (user_id);
CREATE INDEX IF NOT EXISTS idx_security_user_role_role
    ON security_user_role (role_id);
CREATE INDEX IF NOT EXISTS idx_security_role_permission_role
    ON security_role_permission (role_id);
CREATE INDEX IF NOT EXISTS idx_security_role_permission_code
    ON security_role_permission (permission_code);
CREATE INDEX IF NOT EXISTS idx_security_idp_mapping_tenant_group
    ON security_idp_mapping (tenant_id, idp_group);
CREATE INDEX IF NOT EXISTS idx_security_role_scope_user
    ON security_role_scope (user_id);
-- NOTE: security_audit_log(tenant_id, created_at) already indexed in V30.

CREATE INDEX IF NOT EXISTS idx_leave_balance_employee
    ON leave_balance (employee_id);
CREATE INDEX IF NOT EXISTS idx_payslip_employee
    ON payslip (employee_id);
CREATE INDEX IF NOT EXISTS idx_time_entry_employee
    ON time_entry (employee_id);
