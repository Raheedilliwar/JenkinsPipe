FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:17-alpine
WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8081


HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail http://localhost:8081/health || exit 1 

CMD ["java" , "-jar" , "app.jar"]

