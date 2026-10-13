#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="${ROOT_DIR}/docker-compose.yml"

cd "${ROOT_DIR}"

compose() {
  if docker compose version >/dev/null 2>&1; then
    docker compose -f "${COMPOSE_FILE}" "$@"
  else
    docker-compose -f "${COMPOSE_FILE}" "$@"
  fi
}

wait_for_mysql() {
  printf "Waiting for MySQL"
  for _ in {1..60}; do
    if docker exec ruoyi-mysql mysqladmin ping -h 127.0.0.1 -uroot -ppassword --silent >/dev/null 2>&1; then
      printf " ok\n"
      return 0
    fi
    printf "."
    sleep 2
  done
  printf "\nMySQL did not become ready in time.\n" >&2
  return 1
}

wait_for_redis() {
  printf "Waiting for Redis"
  for _ in {1..60}; do
    if docker exec ruoyi-redis redis-cli ping 2>/dev/null | grep -q PONG; then
      printf " ok\n"
      return 0
    fi
    printf "."
    sleep 2
  done
  printf "\nRedis did not become ready in time.\n" >&2
  return 1
}

wait_for_minio() {
  printf "Waiting for MinIO"
  for _ in {1..60}; do
    if curl -fsS "http://127.0.0.1:9000/minio/health/live" >/dev/null 2>&1; then
      printf " ok\n"
      return 0
    fi
    printf "."
    sleep 2
  done
  printf "\nMinIO did not become ready in time.\n" >&2
  return 1
}

wait_for_nacos() {
  printf "Waiting for Nacos"
  for _ in {1..90}; do
    if curl -fsS "http://127.0.0.1:8848/nacos/actuator/health" 2>/dev/null | grep -q UP; then
      printf " ok\n"
      return 0
    fi
    printf "."
    sleep 2
  done
  printf "\nNacos did not become ready in time.\n" >&2
  return 1
}

echo "Starting PhotoNest local dependencies..."
compose up -d ruoyi-mysql ruoyi-redis ruoyi-minio ruoyi-nacos

wait_for_mysql
wait_for_redis
wait_for_minio
wait_for_nacos

cat <<'INFO'

PhotoNest local dependencies are ready.

Nacos:
  Console:  http://localhost:18080/
  API:      http://localhost:8848/nacos
  Username: nacos
  Password: nacos

MySQL:
  Host:     localhost
  Port:     3306
  Database: ry-cloud
  Username: root
  Password: password

Redis:
  Host: localhost
  Port: 6379

MinIO:
  API:      http://localhost:9000
  Console:  http://localhost:9001
  Username: minioadmin
  Password: minioadmin
  Bucket:   photonest

Please check these Nacos configs:
  - application-dev.yml
  - ruoyi-gateway-dev.yml
  - ruoyi-file-dev.yml
  - ruoyi-photo-dev.yml

The gateway config should include:
  - /photo/** -> lb://ruoyi-photo
  - /file/** -> lb://ruoyi-file
  - /photo/app/auth/wechat-login in security.ignore.whites

Typical backend startup order from this project root:
  JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home mvn -pl ruoyi-gateway spring-boot:run
  JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home mvn -pl ruoyi-modules/ruoyi-file spring-boot:run
  JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home mvn -pl ruoyi-modules/ruoyi-photo spring-boot:run

After gateway, ruoyi-file, and ruoyi-photo are running, execute:
  bash scripts/test-photonest-api.sh

INFO
