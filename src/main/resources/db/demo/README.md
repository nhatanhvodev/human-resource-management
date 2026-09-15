# Demo seeds (dev profile only)

This directory holds **demo/sample data** migrations. They run only with the
`dev` Spring profile (`application-dev.yml` adds `classpath:db/demo` to
`spring.flyway.locations`).

## Policy

- `src/main/resources/db/migration/` (`V1__…`) = **schema + mandatory data only**.
  Everything here runs in production. Never put demo people/departments here.
- `src/main/resources/db/demo/` = **sample data for local development**.
  Naming: `R__demo_<topic>.sql` (repeatable) or `V9000+__…` (versioned, runs once).
- The historical `V7__…V43__` demo seeds stay in `db/migration/` untouched:
  moving already-applied migrations would break Flyway checksums on existing
  databases. New demo data goes here.
