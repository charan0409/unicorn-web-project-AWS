# unicorn-web-project-AWS
unicorn-web-project-AWS-workshop

# Install Maven & Java
Apache Maven  is a build automation tool used for Java projects. In this workshop we will use Maven to help initialize our sample application and package it into a Web Application Archive (WAR) file.

# Install Apache Maven using the commands below:
```
sudo wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo 
sudo yum install -y apache-maven
```
Maven comes with Java 7. 
For the build image that we're going to use later on we will need to use at least Java 8. Therefore we are going to install Java 8, or more specifically Amazon Correto 8 , which is a free, production-ready distribution of the Open Java Development Kit (OpenJDK) provided by Amazon:
```
sudo amazon-linux-extras enable corretto8
sudo yum install -y java-1.8.0-amazon-corretto-devel
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64
export PATH=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64/jre/bin/:$PATH
```
# Verify that Java 8 and Maven are installed correctly:
```
java -version
mvn -v
```
# Important
If the command above doesn't return openjdk version 1.8 (=> Java 8), then run the following command that allows you to choose the correct Java version:
```
sudo alternatives --config java
```
# Create the Application
Use mvn to generate a sample Java web app
```
mvn archetype:generate \
    -DgroupId=com.wildrydes.app \
    -DartifactId=unicorn-web-project \
    -DarchetypeArtifactId=maven-archetype-webapp \
    -DinteractiveMode=false
```
mvn Create Success

Verify the folder structure has been created for the application. You should have index.jsp file and a pom.xml.
```
├── README.md
└── unicorn-web-project
    ├── pom.xml
    └── src
        └── main
            ├── resources
            └── webapp
                ├── index.jsp
                └── WEB-INF
                    └── web.xml

6 directories, 4 files
```
Modify the index.jsp file to customize the HTML code (just to make it your own!). You can modify the file by double-clicking on it in the Cloud9 IDE. We will be modifying this further to include the full Unicorn branding later.
```
<html>
<body>
<h2>Hello Unicorn World!</h2>
<p>This is my first version of the Wild Rydes application!</p>
</body>
</html>
```
# Install Tomcat on Amazon linux 2023
# Download Tomcat Binary file.
```
# Become a root
sudo su -
cd /opt
wget wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.23/bin/apache-tomcat-10.0.23.tar.gz
# unzip tomcat binary
tar -xvzf apache-tomcat-10.0.23.tar.gz 
# Rename for simplicity if required
mv apache-tomcat-10.0.23.tar.gz tomcat
```
# Create a tomcat user.
its not a good practice to run tomcat using root user.
```
# Become a root,no need to execute this cmd if your already root user.
sudo su -
# create a tomcat user
adduser tomcat
# create a password for tomcat user
passwd tomcat 
# enter the New password then Retype new password, you should see passwd: all authentication tokens updated successfully.
```
# Now change the ownership of /opt/tomcat file from root to tomcat being a root user.
```
# Become a root, no need to execute this cmd if your already root user.
sudo su - 
chown -R tomcat:tomcat /opt/tomcat
```
![image](https://github.com/user-attachments/assets/5e3d04c2-7199-4512-97fd-7dbfe6c314f9)

# In tomcat-10 Execute Permission are already present to catalina.sh, startup.sh & shutdown.sh
if not follow below steps
```
# Go to bin directory.
cd /opt/tomcat/bin
chmod +x catalina.sh startup.sh  shutdown.sh
```
# Create a link files for Tomcat Server up and Down.
```
ln -s /opt/tomcat/bin/startup.sh /usr/local/bin/tomcatup
ln -s /opt/tomcat/bin/shutdown.sh /usr/local/bin/tomcatdown
# Now start the tomcat. 
tomcatup
```
# The default Tomcat environment in the image is:
```
CATALINA_BASE:   /usr/local/tomcat
CATALINA_HOME:   /usr/local/tomcat
CATALINA_TMPDIR: /usr/local/tomcat/temp
JRE_HOME:        /usr
CLASSPATH:       /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar
```
The configuration files are available in /usr/local/tomcat/conf/. By default, no user is included in the "manager-gui" role required to operate the "/manager/html" web application. If you wish to use this app, you must define such a user in tomcat-users.xml
# Now access the tomcat by web-browser.
open a new tab and enter http://Public IPv4 address:8080/
![image](https://github.com/user-attachments/assets/904c63d4-58d5-4e47-9d21-3ef293e60885)

**********************************************************************************************************************
# Containarization
# Create a Dockerfile with below docker instructions
```
FROM tomcat:9.0

COPY ./unicorn-web-project-AWS/unicorn-web-project/target/unicorn-web-project.war /usr/local/tomcat/webapps/ROOT.war    # copy war file from host to container path /usr/local/tomcat/webapps/*

CMD ["catalina.sh", "run"]
```
# Build the docker image
docker build -t "name-of-the-image" /path/to/Dockerfile
```
docker build -t unicorn .
```
# Run the image as container
```
docker run -it -p 8080:8080 unicorn:latest
```
# Verify application by hitting <ip>:8080 in browser
![image](https://github.com/user-attachments/assets/98007026-d99e-48ca-a90d-6c9bf4a535cc)
