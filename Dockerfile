FROM openjdk:11-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the .war file from the Jenkins workspace into the Docker container
COPY SimpleWebApplication-9.1.14.war /app/SimpleWebApplication-9.1.14.war

EXPOSE 8080

# Run the application
CMD ["java", "-jar", "SimpleWebApplication-9.1.14.war"]
