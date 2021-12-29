FROM openjdk

WORKDIR /var/sites/app

COPY target/toDoAppWithLogin.jar ./app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
