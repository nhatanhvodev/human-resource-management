# HRMS Platform

Modular monolith HRMS skeleton using Java 21 and Spring Boot 4.

## Run tests

```powershell
.tools/apache-maven-3.9.11/bin/mvn.cmd test
```

## Local runtime dependencies

Use Docker Compose for PostgreSQL, Redis, and RabbitMQ:

```powershell
docker compose -f docker/compose.yml up -d
```
