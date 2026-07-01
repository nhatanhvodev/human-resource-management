alter table recruitment_application
    add column if not exists application_no varchar(32);

update recruitment_application application
set application_no = (
    select 'HS' || lpad(cast(count(*) as varchar), 6, '0')
    from recruitment_application earlier
    where earlier.tenant_id = application.tenant_id
      and (
          earlier.created_at < application.created_at
          or (
              earlier.created_at = application.created_at
              and cast(earlier.id as varchar) <= cast(application.id as varchar)
          )
      )
)
where (application.application_no is null or application.application_no = '');

alter table recruitment_application
    alter column application_no set not null;

create unique index if not exists ux_recruitment_application_tenant_application_no
    on recruitment_application (tenant_id, application_no);

update audit_log
set details = 'Scheduled technical interview for application HS000001.'
where tenant_id = 'default'
  and details = 'Scheduled technical interview for application e1000000-0000-4000-8000-000000000001.';
