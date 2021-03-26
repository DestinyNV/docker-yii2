#!/bin/sh
set -e

cd /opt/app/

# Run all the init scripts
ENVIRONMENT=$ENVIRONMENT run-parts --exit-on-error docker/init

# Start supervisor
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
