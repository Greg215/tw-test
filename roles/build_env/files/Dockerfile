# Dockerfile This is a Dockerfile for a simple Java application, no maven installed here.
FROM java:8  

MAINTAINER  Greg Hu

COPY . /var/www/java  

WORKDIR /var/www/java  

RUN javac Hello.java  

CMD ["java", "Hello"]  
