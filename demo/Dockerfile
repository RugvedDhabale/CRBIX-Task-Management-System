# Use a lightweight Java 17 image
FROM eclipse-temurin:17-jdk-alpine

# Set working directory inside the container
WORKDIR /app

# Copy the Spring Boot jar from target folder
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose the port (Render will assign PORT dynamically)
EXPOSE 8080

# Command to run the Spring Boot jar
ENTRYPOINT ["java", "-jar", "app.jar"]
