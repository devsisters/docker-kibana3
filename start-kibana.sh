#!/bin/sh
#
# start-kibana.sh
#
# Renders a config.js for Kibana 3 and starts Nginx
#
set -eu

test -n "${ES_PROTO}" || exit 1
test -n "${ES_HOST}"  || exit 1
test -n "${ES_PORT}"  || exit 1

CONTAINER_KIBANA_ROOT=/src/kibana
LOCAL_KIBANA_VOLUME=/var/lib/kibana
cat > ${CONTAINER_KIBANA_ROOT}/config.js <<EOS
define(['settings'],
function (Settings) {
  "use strict";

  return new Settings({
    elasticsearch: "${ES_PROTO}://${ES_HOST}:${ES_PORT}",
    kibana_index: "kibana-int",
    panel_names: [
      'histogram',
      'map',
      'pie',
      'table',
      'filtering',
      'timepicker',
      'text',
      'fields',
      'hits',
      'dashcontrol',
      'column',
      'derivequeries',
      'trends',
      'bettermap',
      'query',
      'terms',
      'sparklines'
    ]
  });
});
EOS

# This gives an installer the ability to overwrite the container's
# Kibana code with a local copy, mounted as a Docker volume to
# $LOCAL_KIBANA_VOLUME.
#
# For example, set the default dashboard by creating a file called
# /var/lib/kibana/dashboards/default.json
if [ -d ${LOCAL_KIBANA_VOLUME} ]; then
  rsync -av ${LOCAL_KIBANA_VOLUME}/* ${CONTAINER_KIBANA_ROOT}/src/app/
fi

exec /usr/sbin/nginx -c /etc/nginx/nginx.conf
