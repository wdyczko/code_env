#!/usr/bin/env bash

if [ $# -eq 1 ]
then
    docker run -v $1:/code -i -d --name dev dev
else
    docker run -i -d --name dev dev
fi;

