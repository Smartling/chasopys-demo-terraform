#!/usr/bin/env bash

#This script uses the exec Bash command so that the final running application becomes the container’s PID 1.
#This allows the application to receive any Unix signals sent to the container.
#CTRL-C will stop application with container.

exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar
