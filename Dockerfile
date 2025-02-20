FROM tomcat:9.0

COPY ./unicorn-web-project-AWS/unicorn-web-project/target/unicorn-web-project.war /usr/local/tomcat/webapps/ROOT.war

CMD ["catalina.sh", "run"]
