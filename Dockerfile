FROM tomcat:alpine
MAINTAINER Sachin Kumar
COPY target/devopssampleapplication.war /usr/local/tomcat/webapps/sachinkumar08.war
EXPOSE 8080
CMD [ "/usr/local/tomcat/bin/catalina.sh", "run" ]
