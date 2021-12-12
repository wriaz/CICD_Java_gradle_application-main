FROM openjdk:11 AS base
WORKDIR /app
COPY . .
RUN chmod +x gradlew && ./gradlew build

FROM tomcat:9
WORKDIR webapps
COPY --from=base /app/build/libs/sampleWeb-0.0.1-SNAPSHOT.war .
RUN rm -rf ROOT && mv sampleWeb.war ROOT.war