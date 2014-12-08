FROM elcolio/openjdk7
ADD supervisor.conf /etc/supervisor/conf.d/rundeck.conf
ADD http://dl.bintray.com/rundeck/rundeck-maven/rundeck-launcher-2.3.2.jar /rundeck.jar
