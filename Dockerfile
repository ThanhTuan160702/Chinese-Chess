FROM gradle:8.2.1-jdk17 AS build

# Sử dụng bộ đệm cache của Gradle để tăng tốc độ build
COPY --chown=gradle:gradle . /home/gradle/project
WORKDIR /home/gradle/project

# Chạy Gradle để build file JAR
RUN gradle bootJar --no-daemon

# Sử dụng hình ảnh JDK nhẹ hơn cho phần chạy ứng dụng
FROM openjdk:17-jdk-slim
EXPOSE 8080

# Copy file JAR đã build từ giai đoạn build trước
COPY --from=build /home/gradle/project/build/libs/demo-1.jar app.jar

# Khởi chạy ứng dụng Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]