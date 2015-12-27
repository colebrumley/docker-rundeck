Rundeck
=======

A simple Rundeck container on the OpenJDK7 JRE. Rundeck uses the hostname as the server URL (for absolute URLs, it listens on `0.0.0.0`), so make sure you set the container hostname to whatever domain/subdomain is hosting it.

    docker run -d --name rundeck -h rundeck.example.com -p 4440:4440 elcolio/rundeck

Alternatively, you can override the `grails.serverURL` value altogether by setting `SERVER_URL`. You can also set `USE_INTERNAL_IP` to set the server URL to whatever the container's `eth0` IP is. If none of the server URL options are set, the container makes an attempt to determine the host's IP address (won't work behind NATs).

I recently switched this to Alpine Linux as the base, so the image size is a little smaller and I added ENV variables for a few parameters:
  - `DEFAULT_ADMIN_USER` - default: `admin`
  - `DEFAULT_ADMIN_PASSWORD` - default: `admin`
  - `DEFAULT_USER` - default: `docker`
  - `DEFAULT_PASSWORD` - default: `docker`
  - `SERVER_MEMORY` - default: `1024`
  - `SERVER_PORT` - default: `4440`
  - `SERVER_URL` - default: `http://$(hostname):4440` (Override Rundeck's grails.serverURL)
  - `MYSQL_USER`
  - `MYSQL_PASSWORD`
  - `MYSQL_ADDR` - default: `mysql`
  - `MYSQL_DB` - default: `rundeck`
  - `USE_INTERNAL_IP` When SERVER_URL is undefined, use the container's eth0 address (otherwise try to guess external)
