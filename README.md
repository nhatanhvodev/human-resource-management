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

## Auth model

- Login (`POST /api/v1/auth/login`) returns a short-lived RS256 access token
  (15 min default) **and** sets an `HttpOnly; SameSite=Lax` refresh cookie
  (`hrms_refresh`, 7 days, rotating on every use).
- The SPA keeps the access token **in memory only**; reloads and 401s
  silently refresh via the cookie (`POST /api/v1/auth/refresh`).
  `localStorage` is only a manual dev-token override (DevSettings page).
- Logout (`POST /api/v1/auth/logout`) revokes the refresh token server-side.

## Production checklist

```powershell
# 1. Generate dedicated JWT keys (never use src/main/resources/keys/* in prod)
openssl genrsa -out jwt-private.pem 2048
openssl rsa -in jwt-private.pem -pubout -out jwt-public.pem

# 2. Point the app at them (docker secret files or env)
$env:APP_JWT_PRIVATE_KEY_LOCATION = "file:/run/secrets/jwt-private.pem"
$env:APP_JWT_PUBLIC_KEY_LOCATION = "file:/run/secrets/jwt-public.pem"
$env:APP_CORS_ALLOWED_ORIGINS = "https://hrms.example.com"
```

- `SPRING_PROFILES_ACTIVE=prod` disables the dev-token bypass, enables
  `Secure` refresh cookies and CSRF, and runs **only** `db/migration`
  (demo seeds live under `db/demo`, dev profile only).
- Access-token TTL: `APP_ACCESS_TOKEN_TTL_SECONDS` (default 900).

github repo: https://github.com/nhatanhvodev/human-resource-management.git