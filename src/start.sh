#!/bin/sh

# Defaults
if [ -z ${SMTPHOST} ]; then
    echo "SMTPHOST set to smtp-out"
	export SMTPHOST="smtp-out"
fi

if [ -z ${SMTPPORT} ]; then
    echo "SMTPPORT set to 25"
	export SMTPPORT=25
fi

if [ -z ${DOMAIN} ]; then
    echo "DOMAIN set to example.com"
	export DOMAIN="example.com"
fi

if [ -z ${MYHOSTNAME} ]; then
    echo "MYHOSTNAME set to amavis.${DOMAIN}"
	export MYHOSTNAME="amavis.${DOMAIN}"
fi

BACKGROUND_TASKS="$!"
amavisd -c /etc/amavisd.conf -c /etc/amavisd-local.conf foreground &
BACKGROUND_TASKS="${BACKGROUND_TASKS} $!"

while true; do
	for bg_task in ${BACKGROUND_TASKS}; do
		if ! kill -0 ${bg_task} 1>&2; then
			echo "Worker ${bg_task} died, stopping container waiting for respawn..."
			kill -TERM 1
		fi
		sleep 10
	done
done
