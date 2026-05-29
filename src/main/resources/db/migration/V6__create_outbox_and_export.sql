create table if not exists outbox_event (
  id uuid primary key,
  tenant_id varchar(64) not null,
  event_type varchar(120) not null,
  payload varchar(2000) not null,
  status varchar(20) not null,
  created_at timestamp with time zone not null,
  updated_at timestamp with time zone not null
);
