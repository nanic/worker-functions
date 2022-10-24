#!/bin/bash

echo "$WORKERS"
echo "$BRANCH"

filename="wrangler.toml"

branch_name=$(echo $BRANCH | tr '[:lower:]' '[:upper:]')
tag="_${branch_name}"
echo $tag

default_list="WORKER1;WORKER2"

KEY_PREFIXES="TEST_VARIABLE1;TEST_VARIABLE2"
IFS=';' read -ra PREFIXES <<< "$KEY_PREFIXES"

if [ "$WORKERS" == "$default_list" ]
then
    cfworkers=("soft-flower-7fac")
    for worker in "${cfworkers[@]}"; do
        echo $worker
        cd $worker
        pwd
        sed -i "s/ENVIRONMENT/$BRANCH/" $filename
        for i in "${PREFIXES[@]}"; do
            replace=$i$tag
            eval replace='$'$replace
            sed -i "s/$i/$replace/" $filename
        done
        CLOUDFLARE_API_TOKEN=$CF_KEY wrangler publish
        cd ..
    done
else
    IFS=';' read -ra WORKERSLIST <<< "$WORKERS"
    for i in "${WORKERSLIST[@]}"; do
        echo "$i"
    done
fi