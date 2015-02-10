#!/bin/bash
mount smilio-assets-frankfurt

keepgoing=1
trap '{ echo "sigint"; keepgoing=0; }' SIGINT

while (( keepgoing )); do
    echo "sleeping"
    sleep 5
done

