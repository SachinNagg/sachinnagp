# escape=`

FROM tomcat:alpine
MAINTAINER Sachin Kumar
# Create app directory
# WORKDIR /usr/builds
RUN wget -O C:\launchstation04.war docker.for.win.localhost:8081/artifactory/CI-Automation-JAVA/com/nagarro/devops-tools/devops/demosampleapplication/1.0.0-SNAPSHOT/demosampleapplication-1.0.0-SNAPSHOT.war
# COPY launchstation04.war C:\tomcat\webapps
EXPOSE 8080
CMD ["C:\tomcat\bin\catalina.bat", "run"]
