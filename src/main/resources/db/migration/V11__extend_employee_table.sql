ALTER TABLE employee
  ADD COLUMN IF NOT EXISTS position_id uuid,
  ADD COLUMN IF NOT EXISTS email varchar(255),
  ADD COLUMN IF NOT EXISTS phone varchar(20),
  ADD COLUMN IF NOT EXISTS date_of_birth date,
  ADD COLUMN IF NOT EXISTS gender varchar(10),
  ADD COLUMN IF NOT EXISTS national_id varchar(20),
  ADD COLUMN IF NOT EXISTS address text,
  ADD COLUMN IF NOT EXISTS bank_account varchar(30),
  ADD COLUMN IF NOT EXISTS tax_code varchar(20);
