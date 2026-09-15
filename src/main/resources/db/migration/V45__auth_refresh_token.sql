-- V45: server-side refresh tokens (rotating, httpOnly cookie transport).
-- Only the SHA-256 hash is stored; the raw token never touches the database.

CREATE TABLE IF NOT EXISTS auth_refresh_token (
  id uuid PRIMARY KEY,
  tenant_id varchar(64) NOT NULL,
  user_id uuid NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
  token_hash varchar(64) NOT NULL UNIQUE,
  expires_at timestamp with time zone NOT NULL,
  revoked boolean NOT NULL DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_auth_refresh_token_user
    ON auth_refresh_token (tenant_id, user_id);
