#!/bin/bash

URL="http://$(minikube ip):30007"

REQUESTS=200
CONCURRENCY=10

payload='3
1 2 3
4 5 6
7 8 9'

echo "Target: $URL"
echo "Requests: $REQUESTS"
echo "Concurrency: $CONCURRENCY"
echo ""

for ((i=1;i<=REQUESTS;i++))
do
(
    curl -s -X POST "$URL/process" -d "$payload" > /dev/null
    echo "request $i"
) &

if (( i % CONCURRENCY == 0 ))
then
    wait
fi

done

wait

echo ""
echo "Load test finished"
