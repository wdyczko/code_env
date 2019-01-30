#!/usr/bin/env bash

cd /code

array=()
while IFS=  read -r -d $'\0'; do
    array+=("$REPLY")
done < <(find . -type f -name "$1" -print0)

len=${#array[@]}

if [ $len -eq 0 ]; then
    echo "File with filter $1 not found"
elif [ $len -eq 1 ]; then
    vim "${array[0]}"
else
    counter=0
    for i in "${array[@]}"
    do
        echo "${counter} $i"
        counter=$(( $counter+1 ))
    done
    echo "Found multiple files, choose one: "
    read choose
    vim "${array[$choose]}"
fi
