FROM tomcat:alpine
MAINTAINER Sachin Kumar
RUN ["wget", "-O", "C:\\tomcat\\webapps\\launchstation04.war", "docker.for.win.localhost:8081/artifactory/CI-Automation-JAVA/com/nagarro/devops-tools/devops/demosampleapplication/1.0.0-SNAPSHOT"]
EXPOSE 8080
CMD ["C:\tomcat\bin\catalina.bat", "run"]
