docker rm -f $(docker ps -aq --filter "name=scan-redis")
docker rm -f temporal temporal-admin-tools temporal-ui
docker compose up -d temporal temporal-admin-tools temporal-ui scan-redis
mvn clean install
java -jar -Dspring.profiles.active=local ./target/temporal-client-0.0.1-SNAPSHOT.jar
