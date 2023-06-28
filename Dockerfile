FROM alpine/git as clone
WORKDIR /app
RUN git clone https://github.com/AndreM4tos/image-of-the-day.git

FROM maven AS builder
WORKDIR /usr/src/iotd
COPY --from=clone /app/ADS4/image-of-the-day/pom.xml .
RUN mvn -B dependency:go-offline
COPY --from=clone /app/ADS4/image-of-the-day .
RUN mvn package

FROM openjdk    
WORKDIR /app
COPY --from=builder /usr/src/iotd/target/iotd-service-0.1.0.jar .
EXPOSE 80
ENTRYPOINT ["java", "-jar", "/app/iotd-service-0.1.0.jar"]
