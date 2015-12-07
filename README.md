Rundeck
=======

A simple Rundeck container on the OpenJDK7 JRE. Rundeck uses the hostname as the server URL (for absolute URLs, it listens on `0.0.0.0`), so make sure you set the container hostname to whatever domain/subdomain is hosting it.

    docker run -d --name rundeck -h rundeck.example.com -p 4440:4440 elcolio/rundeck

I recently switched this to Alpine Linux as the base, so the image size is a little smaller and I added ENV variables for a few parameters:
  - `SERVER_MEMORY`: default is 1024
  - `SERVER_PORT`: default is 4440
  - `DEFAULT_USER`: default is `admin`
  - `DEFAULT_PASSWORD`: default is `admin`
