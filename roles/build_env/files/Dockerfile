# Dockerfile This is a Dockerfile for a simple Java application, no maven installed here.
FROM openjdk:8-jdk

MAINTAINER greg hu

EXPOSE 5000 5001

VOLUME /tmp/javaserver

COPY Hello.java /var/www/service/  
COPY Hello.war /var/www/service/
COPY Hello.zip /var/www/service/

WORKDIR /var/www/service

RUN javac Hello.java 

CMD ["java", "Hello", "/var/www/service/Hello.zip", "/var/www/service/Hello.war"]

