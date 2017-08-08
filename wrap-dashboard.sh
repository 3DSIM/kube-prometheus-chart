#!/bin/bash -eu

#
# Use this script to wrap an exported grafana dashboard with the fields necessary to succesfully be consumed by
# the kube-prometheus Grafana.
#
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path-to-dashboard.json"
    exit 1
fi

json=$1
temp=$(mktemp -t tempjsonfile)

cat >> $temp <<EOF
{
  "dashboard":
EOF

cat $json >> $temp

cat >> $temp <<EOF
,
  "inputs": [
    {
      "name": "DS_PROMETHEUS",
      "pluginId": "prometheus",
      "type": "datasource",
      "value": "prometheus"
    }
  ],
  "overwrite": true
}
EOF

mv $temp $json

echo "Successfully wrapped the dashboard.  The original file has been updated."