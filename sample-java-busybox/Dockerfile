# Image for IRIS JDBC Consumer
FROM intersystemsdc/irisdemo-base-mavenc:version-1.6.4

# WORKDIR /irislib

# COPY ./irislib/*.jar /irislib/

# RUN /bin/sh -c mvn install:install-file -Dfile=/irislib/intersystems-jdbc-3.2.0.jar -DgroupId=com.intersystems -DartifactId=intersystems-jdbc -Dversion=3.2.0 -Dpackaging=jar -DcreateChecksum=true

# WORKDIR /usr/projects

# COPY ./java-project /usr/projects

ADD ./java-project /usr/projects

RUN make

FROM openjdk:8-jdk-alpine

LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Defaul Java options - You can override this when running the container
ENV JAVA_OPTS=-Xmx256M

WORKDIR /app

COPY --from=0 /usr/projects/app.jar /app/app.jar

CMD java -jar /app/app.jar

HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl -f http://localhost:8080/actuator/health || exit 1