FROM java:8u66-jdk
MAINTAINER Spock Team "spock_team@smartling.com "

ADD build/libs/chasopys_demo-0.1.jar app.jar
ADD keystore.jks keystore.jks
RUN bash -c 'touch /app.jar'

COPY src/docker/docker-entrypoint.sh /

EXPOSE 8443 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
