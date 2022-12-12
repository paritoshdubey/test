#!/bin/bash
set -oe pipefail

object=$1
key=$2

func () {
    echo "object is : $object"
    echo "key is :$key"
    temp=$(echo "x/y/z" | grep -o "/" | wc -l)
    length=$(($temp + 1))
    echo "number of keys : $length"
    final_value=$(echo $key | awk -F/ '{print $NF}')
    echo $final_value
    jq 
}

func