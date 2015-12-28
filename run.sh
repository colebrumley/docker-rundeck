#!/bin/bash

# OPTIONS:
#   DEFAULT_ADMIN_USER          Set the default admin user (defaults to "admin")
#   DEFAULT_ADMIN_PASSWORD      Set the default admin's password (defaults to "admin")
#   DEFAULT_USER                Set the default user (defaults to "docker")
#   DEFAULT_PASSWORD            Set the default user's password (defaults to "docker")
#   SERVER_MEMORY               Because Java is stupid
#   SERVER_PORT                 Sets Rundeck's listening port (defaults to "4440")
#   SERVER_URL                  Sets Rundeck's grails.serverURL
#   MYSQL_USER                  MySQL username
#   MYSQL_PASSWORD              MySQL password
#   MYSQL_ADDR                  MySQL address (defaults to "mysql")
#   MYSQL_DB                    MySQL database name (defaults to "rundeck")
#   USE_INTERNAL_IP             When SERVER_URL is undefined, use the container's eth0 address (otherwise try to guess external)

config_properties=$RDECK_BASE/server/config/rundeck-config.properties
mem=${SERVER_MEMORY:-1024}
perm=$(($mem/4))

function install_rundeck() {
    java -jar $RDECK_JAR --installonly
    echo "${DEFAULT_ADMIN_USER:-docker}:${DEFAULT_ADMIN_PASSWORD:-docker},user,admin" > $RDECK_BASE/server/config/realm.properties
    echo "${DEFAULT_USER:-docker}:${DEFAULT_PASSWORD:-docker},user" >> $RDECK_BASE/server/config/realm.properties
}

function config_grails_url() {
    # Get eth0's IP
    if [ -z ${SERVER_URL} ]; then
        ext_ip=$(curl --silent http://ipv4bot.whatismyipaddress.com)
        int_ip=$(ip -4 -o addr show scope global eth0 | awk '{gsub(/\/.*/,"",$4); print $4}')
        if [ -z ${USE_INTERNAL_IP} ]; then
            SERVER_URL=http://${ext_ip}:${SERVER_PORT:-4440}
        else
            SERVER_URL=http://${int_ip}:${SERVER_PORT:-4440}
        fi
    fi
    sed -i "s,^grails\.serverURL.*\$,grails\.serverURL=${SERVER_URL}," $config_properties
}

function config_mysql() {
    sql_datasource="dataSource.url = jdbc:mysql://${MYSQL_ADDR:-mysql}/${MYSQL_DB:-rundeck}?autoReconnect=true"
    sql_un="dataSource.username = ${MYSQL_USER}"
    sql_pw="dataSource.password = ${MYSQL_PASSWORD}"
    extra_crap_for_sql="rundeck.projectsStorageType=db\nrundeck.storage.provider.1.type=db\nrundeck.storage.provider.1.path=keys"
    sed -i "s,^dataSource\.url.*\$,${sql_datasource}," $config_properties
    echo $sql_un >> $config_properties; echo $sql_pw >> $config_properties
    echo -e $extra_crap_for_sql >> $config_properties
}

install_rundeck
config_grails_url

if ! [ -z ${MYSQL_USER} ] && ! [ -z ${MYSQL_PASSWORD} ]; then
    config_mysql
fi

echo "STARTING RUNDECK"
exec java -Xmx${mem}m \
  -XX:MaxPermSize=${perm}m \
  -Drundeck.jetty.connector.forwarded=true \
  -Dserver.http.host=0.0.0.0 \
  -Dserver.hostname=$(hostname) \
  -Dserver.http.port=${SERVER_PORT:-4440} \
  -jar $RDECK_JAR --skipinstall &
rd_pid=$!

wait $rd_pid
echo "RUNDECK HAS DIED :("