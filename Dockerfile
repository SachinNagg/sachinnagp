FROM tomcat:alpine
MAINTAINER Sachin Kumar
RUN wget -O /usr/local/tomcat/webapps/launchstation04.war http://localhost:8082/artifactory/CI-Automation-JAVA/com/nagarro/devops-tools/devops/demosampleapplication/1.0.0-SNAPSHOT
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run
