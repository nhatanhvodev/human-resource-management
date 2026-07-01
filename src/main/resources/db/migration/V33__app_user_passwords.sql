alter table app_user add column if not exists password_hash varchar(100);

update app_user
set password_hash = '$2a$10$e.qUI24nV40WQ6F9aoNquei39xrMN2SZKOOiG6R0Wn7yaNRUkIRGC',
    updated_at = now()
where tenant_id = 'default'
  and username = 'admin';

update app_user
set password_hash = '$2a$10$1C58Y6v1k4qOefFtyqzXEupOkmRcGG7C1n36IxSOywNWPvvzKuDYu',
    updated_at = now()
where tenant_id = 'default'
  and username = 'hr-manager';

update app_user
set password_hash = '$2a$10$JvMmNAmhjjHa9y7ZBwYiueChCBbygj/p33XufwZKACWIGZfHxo2qu',
    updated_at = now()
where tenant_id = 'default'
  and username = 'line-manager';

update app_user
set password_hash = '$2a$10$0ARSyO9LXj1VNYITaTceX.dWOyecPtJ1ZEwi6mA1JbzoK.JlDpuRi',
    updated_at = now()
where tenant_id = 'default'
  and username = 'employee002';
