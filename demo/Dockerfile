# Stage 1: Build the application using a full JDK and Maven image
FROM maven:3.9-eclipse-temurin-17 AS build

# Set the working directory
WORKDIR /app

# Copy pom.xml first to leverage Docker layer caching
COPY demo/pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy the rest of the source code
COPY demo/src ./src

# Build the application and create the JAR file
RUN mvn clean package -DskipTests


# Stage 2: Create the final, lightweight runtime image
FROM eclipse-temurin:17-jre-alpine

# Set the working directory
WORKDIR /app

# Install curl, which is needed for the HEALTHCHECK command
RUN apk --no-cache add curl

# Create a dedicated, non-root user and group for better security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy the compiled JAR file from the build stage
# Note: This assumes your build produces a single JAR in the target/ directory
COPY --from=build /app/target/*.jar app.jar

# Expose the port the application will run on
EXPOSE 8080

# Health check to ensure the application is running correctly
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# Entrypoint command to run the application
ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT:-8080} -jar /app/app.jar"]
