# Build Stage
FROM gradle:jdk17 as builder

# Set working directory inside the container
WORKDIR /app

# Copy the Gradle configuration files separately to leverage Docker cache
COPY build.gradle.kts settings.gradle.kts gradle.properties ./

# Copy the rest of the application code
COPY src ./src

# Run Gradle build, skipping tests for faster builds (remove '-x test' if tests are needed)
RUN gradle build -x test

# Runtime Stage
FROM eclipse-temurin:21-jre-alpine

# Set deployment directory
WORKDIR /app

# Copy the built artifact from the builder stage
COPY --from=builder /app/build/libs/*-all.jar /app/app.jar

# Expose the port the application runs on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "/app/app.jar"]
