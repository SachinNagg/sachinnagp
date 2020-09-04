FROM tomcat:alpine
MAINTAINER Sachin Kumar
RUN wget -O launchstation04.war docker.for.win.localhost:8081/artifactory/CI-Automation-JAVA/com/nagarro/devops-tools/devops/demosampleapplication/1.0.0-SNAPSHOT
COPY ["launchstation04.war", "C:/Program Files/Apache Software Foundation/Tomcat 10.0/webapps"]
EXPOSE 8080
CMD ["C:/Program Files/Apache Software Foundation/Tomcat 10.0/bin/catalina.bat", "run"]
