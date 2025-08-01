# -------- Stage 1: Build the Spring Boot App using Maven --------
FROM maven:3.9.4-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy all files to builder container
COPY . .

# Build the application (skip tests for speed)
RUN mvn clean package -DskipTests

# -------- Stage 2: Create minimal runtime image --------
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

# Copy the built JAR from the previous stage
COPY --from=builder /app/target/Apigateway-0.0.1-SNAPSHOT.jar app.jar

# Set the profile to docker explicitly
ENV SPRING_PROFILES_ACTIVE=docker

# Expose port used by API Gateway
EXPOSE 4040

# Start the application
ENTRYPOINT ["java", "-jar", "app.jar"]
