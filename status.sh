#!/bin/bash/env bash

# terminus needs to be configured and installed for this to work
#
# Example usage: bash status.sh | tee -a results.txt

# Reading names of all sites from terminus
readarray sitelist < <(terminus site:list --field=name --format=list)

for i in "${sitelist[@]}"; do
    # trim newlines from output
    base=$(echo ${i} | tr -d '\n')

    # Start block of logs
    echo "------------------"
    echo "Checking status of: ${base}";
    echo "------------------"

    # Build url and curl it
    devurl="dev-${base}.pantheonsite.io"
    devresponse=$(curl -L -s -w "%{http_code} %{time_total}\n" -o /dev/null "$devurl")

    # Extract the status code and response time from the response
    dev_status_code=$(echo "$devresponse" | awk '{print $1}')
    dev_response_time=$(echo "$devresponse" | awk '{print $2}')

    # Print the status code and response time
    echo "${devurl} status:"
    echo "\tStatus Code: $dev_status_code"
    echo "\tResponse Time (seconds): $dev_response_time"

    # Build url and curl it
    testurl="test-${base}.pantheonsite.io"
    testresponse=$(curl -L -s -w "%{http_code} %{time_total}\n" -o /dev/null "$testurl")

    # Extract the status code and response time from the response
    test_status_code=$(echo "$testresponse" | awk '{print $1}')
    test_response_time=$(echo "$testresponse" | awk '{print $2}')

    # Print the status code and response time
    echo "${testurl} status:"
    echo "\tStatus Code: $test_status_code"
    echo "\tResponse Time (seconds): $test_response_time"

    # Build url and curl it
    liveurl="live-${base}.pantheonsite.io"
    liveresponse=$(curl -L -s -w "%{http_code} %{time_total}\n" -o /dev/null "$liveurl")

    # Extract the status code and response time from the response
    live_status_code=$(echo "$liveresponse" | awk '{print $1}')
    live_response_time=$(echo "$liveresponse" | awk '{print $2}')

    # Print the status code and response time
    echo "${liveurl} status:"
    echo "\tStatus Code: $live_status_code"
    echo "\tResponse Time (seconds): $live_response_time"

    # End block of logs
    echo "------------------"
    echo "End status of: ${base}";
    echo "------------------"
done
