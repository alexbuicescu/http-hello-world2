#!/usr/bin/env bash

# Define a timestamp function
timestamp() {
  date +"%s"
}

dateString() {
  date +"%T"
}

startTs=$(timestamp)
echo "started at $(dateString) ($(timestamp))"

for i in "$@"
do
case $i in
    --url=*)
    url="${i#*=}"
    ;;
    *)
    echo "unknown option ${i}"
    echo "ended at $(dateString) ($(timestamp)) (duration: $(($(timestamp)-${startTs})) seconds)"
    exit -1
    ;;
esac
done

if [[ -z "${url}" ]]; then
echo "url is missing, set it as environment variable or pass it as argument ('./health_check.sh --url=http://localhost:8000' or 'export url=http://localhost:8000')"
echo "ended at $(dateString) ($(timestamp)) (duration: $(($(timestamp)-${startTs})) seconds)"
exit -1
fi


echo "health checking for $0"

response="0"

while [ $response -ne "200" ]
do
    response=$(curl --write-out "%{http_code}\n" --silent --output /dev/null "$url")
    sleep 1
    echo "response waiting for '200', got: '$response'"
done
