FROM gradle:8.7.0-jdk17-alpine AS builder

WORKDIR /app
VOLUME /tmp
ARG JAR_FILE=/build/libs/*.jar
COPY ${JAR_FILE} app.jar

# Spring 소스 코드를 이미지에 복사
COPY . .

# 빌드
RUN ./gradlew clean build

# 백엔드 서버 실행
FROM openjdk:17-alpine

WORKDIR /app
COPY --from=builder /app/app.jar app.jar

# 백엔드 서버 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
CMD ["--spring.profiles.active=dev"]
