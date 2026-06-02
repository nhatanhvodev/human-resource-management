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

## Run backend

```powershell
docker compose -f docker/compose.yml up -d
.tools/apache-maven-3.9.11/bin/mvn.cmd spring-boot:run -Dspring-boot.run.profiles=dev
```

## Run frontend

```powershell
cd web-admin
npm install
npm run dev
```

The frontend runs at `http://127.0.0.1:5173` and proxies `/api` to `http://localhost:8080`.

## Frontend checks

```powershell
npm --prefix web-admin run test -- --run
npm --prefix web-admin run build
npm --prefix web-admin run test:e2e
```
