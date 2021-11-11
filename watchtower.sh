#!/bin/bash
# set -x

DNS_SERVERS="1.1.1.1 8.8.8.8 9.9.9.9"
DNS_PORT=53
POLL_SLOW=60
POLL_FAST=5
let FAIL_AFTER_TIME=(3*60) # 3 minutes
let RECOVER_WAIT_TIME=5 # 5 minutes

STATUS="STARTING"

function checkInternet {
        DNS_SERVERS=$1
        DNS_PORT=$2
        while :
        do
                for server in $DNS_SERVERS
                do
                        timeout 1 bash -c "echo -n > /dev/tcp/$server/$DNS_PORT;"
                        if [[ $? = 0 ]]; then
                                return 0
                        fi
                        sleep $POLL_FAST
                done
        done
}

export -f checkInternet


function isInternetConnected {
        timeout $FAIL_AFTER_TIME bash -c "checkInternet \"$DNS_SERVERS\" $DNS_PORT"
        return $?
}

## Main watchtower loop
function main {

        if [[ "$STATUS" = "STARTING" ]]; then
                echo "Starting..."
                sleep $RECOVER_WAIT_TIME
        fi


        ## check for internet
        if isInternetConnected; then
                if [[ "$STATUS" != "CONNECTED" ]]; then
                        echo "Internet connected at `date`"
                        STATUS="CONNECTED"
                fi

                sleep $POLL_SLOW

        else
                echo "Lost internet connectivity! `date`"
                STATUS="CONNECTED"
                ## perform action on confirmed lost internet here.
        fi

}

while :
do
        main
done
