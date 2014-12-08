Rundeck
=======

A simple Rundeck container on the OpenJDK7 JRE. Rundeck uses the hostname as the server URL, so make sure you set the container hostname to whatever domain/subdomain is hosting it. This container is using ports 80 & 443 (but is not currently set up for SSL)

    docker run -d --name rundeck -h rundeck.example.com -p 80:80 -p 443:443 elcolio/rundeck
