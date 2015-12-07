FROM    alpine
ENV     RDECK_BASE=/opt/rundeck
ENV     RDECK_JAR=$RDECK_BASE/app.jar
ENV     PATH=$PATH:$RDECK_BASE/tools/bin
COPY    run.sh /bin/rundeck
RUN     apk add --update openjdk7-jre bash && \
        mkdir -p $RDECK_BASE && \
        wget -O $RDECK_JAR \
            http://dl.bintray.com/rundeck/rundeck-maven/rundeck-launcher-2.6.2.jar && \
        chmod a+x /bin/rundeck
EXPOSE  4440
VOLUME  /opt/rundeck
COPY    rundeck /opt/rundeck
CMD     rundeck
