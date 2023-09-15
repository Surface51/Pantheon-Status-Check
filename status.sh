#!/bin/bash/env bash

# terminus needs to be configured and installed for this to work
#
# Example usage: bash status.sh | tee results.txt

# Helper function to log... urls
logURL()
{
    # readable variables
    en=$1
    base=$2

    # Build url and curl it
    url="${en}-${base}.pantheonsite.io"
    response=$(curl -L -s -w "%{http_code} %{time_total}\n" -o /dev/null "$url")

    # Extract the status code and response time from the response
    status_code=$(echo "$response" | awk '{print $1}')
    response_time=$(echo "$response" | awk '{print $2}')

    # Print the status code and response time
    echo "${url} status:"
    echo -e "\tStatus Code: $status_code"
    echo -e "\tResponse Time (seconds): $response_time"
    echo -e '\n'
}

# Reading names of all sites from terminus
initialSitelist=$(terminus sites --format=csv --fields=name,frozen)
nonFrozenSites=()

# Parse from csv format
while IFS=, read -r name frozen
do
    # add to arry if not frozen
    if [[ $frozen = "false" ]]; then
        # trim commas from read names 
        realname=$(echo ${name} | tr -d ',')
        # add to final list
        nonFrozenSites+=($realname)
    fi
done <<< "$initialSitelist"

for i in "${nonFrozenSites[@]}"; do
    # trim newlines from output
    base=$(echo ${i} | tr -d '\n')

    # Start block of logs
    echo "------------------"
    echo "Checking status of: ${base}";
    echo "------------------"

    # Log urls w/different envs
    logURL 'dev' $base
    logURL 'test' $base
    logURL 'live' $base
done

