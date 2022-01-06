FROM openjdk

WORKDIR /var/sites/app

COPY ./wait-for-it.sh ./wait-for-it.sh
RUN ["chmod", "+x", "./wait-for-it.sh"]

COPY target/toDoAppWithLogin.jar ./app.jar

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "-c", "./wait-for-it.sh -t 30 mysql_server:3306 -- java -jar app.jar"]
