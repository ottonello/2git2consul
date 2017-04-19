#!/bin/bash

if [ -z "$1"  ]
then
    echo "Missing output directory"
    exit
fi

if [ -z "$2"  ]
then
    echo "Missing Consul URL"
fi

pushd $1

curl $2/v1/kv/$FROM\?recurse 2>/dev/null |
jq -r '.[] | [.Key, .Value] | join(" ")' |
while read line; do
    echo
    echo $line
    #KEY=$(echo $line | awk '{print $1}' | sed "s/$FROM/$TO/")
    KEY=$(echo $line | awk '{print $1}' )
    VAL=$(echo $line | awk '{print $2}' | base64 --decode)
    FILENAME=$(basename "${KEY}")
    PATH_=$(dirname "${KEY}")

    if [ -z "$VAL" ]
    then
        continue
    fi
    echo "Filename:" $FILENAME "Path:" $PATH_
 
   if [ "$PATH_" != "." ]
    then
        mkdir -p $PATH_
    fi

    echo "$VAL" > $PATH_/$FILENAME
done;

popd


