# ====== build args는 반드시 FROM보다 위에 선언 ======
# 도커 빌드 시 사용할 빌드/런타임 이미지 이름을 변수로 지정
# ARG는 선언된 이후부터만 유효하므로 반드시 FROM보다 위에 있어야 함
ARG BUILDER_IMAGE=gradle:7.6.0-jdk17
ARG RUNTIME_IMAGE=amazoncorretto:17.0.7-alpine

# ============ (1) Builder ============
# 빌더 스테이지 시작: 지정한 Gradle + JDK 환경을 사용
FROM ${BUILDER_IMAGE} AS builder

USER root
WORKDIR /app
ENV GRADLE_USER_HOME=/home/gradle/.gradle

RUN mkdir -p /app /home/gradle/.gradle \
    && chown -R gradle:gradle /app /home/gradle

USER gradle

COPY --chown=gradle:gradle gradlew ./
COPY --chown=gradle:gradle gradle ./gradle
COPY --chown=gradle:gradle build.gradle settings.gradle ./

RUN sed -i 's/\r$//' ./gradlew && chmod +x ./gradlew
RUN ./gradlew --no-daemon --refresh-dependencies dependencies || true

COPY --chown=gradle:gradle src ./src
RUN ./gradlew clean build --no-daemon --no-parallel -x test

# ============ (2) Runtime ============
# 런타임 스테이지: 빌드 결과 실행에 필요한 최소한의 경량 이미지 사용
FROM ${RUNTIME_IMAGE}
# 앱 실행 디렉토리 지정
WORKDIR /app

# 빌드 스테이지에서 생성한 JAR 파일만 복사
COPY --from=builder /app/build/libs/*.jar app.jar
# 애플리케이션이 사용하는 포트 노출
EXPOSE 8080
# Spring Boot 프로필을 운영(prod)으로 설정
ENV SPRING_PROFILES_ACTIVE=prod
# 컨테이너 시작 시 JAR 실행
ENTRYPOINT ["java","-jar","app.jar"]
