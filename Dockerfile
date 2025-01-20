FROM adoptopenjdk/openjdk11 
     
LABEL maintainer="Asif Ahmad Khan"
 
EXPOSE 8080
 
ENV APP_HOME /usr/src/app

COPY target/*.jar $APP_HOME/app.jar

WORKDIR $APP_HOME

CMD ["java", "-jar", "app.jar"]
