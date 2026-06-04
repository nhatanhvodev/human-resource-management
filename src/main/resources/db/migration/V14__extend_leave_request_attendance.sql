ALTER TABLE leave_request
  ADD COLUMN IF NOT EXISTS leave_type varchar(20) NOT NULL DEFAULT 'ANNUAL',
  ADD COLUMN IF NOT EXISTS approved_by uuid,
  ADD COLUMN IF NOT EXISTS reason text;
