ALTER TABLE leave_request ADD COLUMN leave_type varchar(20) NOT NULL DEFAULT 'ANNUAL';
ALTER TABLE leave_request ADD COLUMN approved_by uuid;
ALTER TABLE leave_request ADD COLUMN reason text;
