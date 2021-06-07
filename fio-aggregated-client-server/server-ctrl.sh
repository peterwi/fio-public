#!/bin/bash
#
#

MACHINEFILE=${1}
ACTION=${2}

for server in `cat ${MACHINEFILE} | xargs` ; do
        if [[ "${ACTION}" == "start" ]] ; then
                echo "Starting FIO server on ${server}"
                ssh ${server} "fio --server --daemonize=/tmp/fio.pid"
        elif [[ "${ACTION}" == "stop" ]] ; then
                echo "Stopping FIO server on ${server}"
                ssh ${server} "kill -15 \`cat /tmp/fio.pid\`"
        else
                echo "Valid parameters are \"/path/to/machinefile start\" & \"/path/to/machinefile stop\" (without qoutes)"
                exit 1
        fi
done
