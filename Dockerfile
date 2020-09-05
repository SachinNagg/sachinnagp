FROM tomcat8.0
MAINTAINER Sachin Kumar
RUN wget -O /usr/local/tomcat/webapps/sampleapp.war docker.for.win.localhost:8081/artifactory/CI-Automation-JAVA/com/nagarro/devops-tools/devops/demosampleapplication/1.0.0-SNAPSHOT/demosampleapplication-1.0.0-SNAPSHOT.war
EXPOSE 8080
CMD [ "/usr/local/tomcat/bin/catalina.sh", "run" ]
