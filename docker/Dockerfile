# ── Stage 1: Build ──────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build

# Copy pom.xml first for dependency caching
COPY pom.xml ./
RUN mvn dependency:go-offline -B -q

# Copy source and build
COPY src src
RUN mvn package -DskipTests -B -q && \
    mv target/*.jar app.jar

# ── Stage 2: Runtime ────────────────────────────────────────
FROM eclipse-temurin:21-jre

# Create non-root user
RUN groupadd --system --gid 1001 appuser && \
    useradd --system --gid appuser --uid 1001 --create-home appuser

# Install curl for healthcheck
RUN apt-get update -qq && apt-get install -y -qq curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy JAR from builder stage
COPY --from=builder /build/app.jar app.jar

# Drop privileges
USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --retries=3 --start-period=60s \
    CMD curl --fail http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS:--Xmx512m -Xms256m} -jar app.jar"]
