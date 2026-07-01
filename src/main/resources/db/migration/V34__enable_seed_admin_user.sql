update app_user
set enabled = true,
    updated_at = now()
where tenant_id = 'default'
  and username = 'admin';
