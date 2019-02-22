#!/usr/bin/env bash

if [ $# -eq 1 ]
then
    docker run -v ~/.vim/UltiSnips:/root/.vim/UltiSnips -v $1:/code -i -d --name env env
else
    docker run -i -d -v ~/.vim/UltiSnips:/root/.vim/UltiSnips --name env env
fi;

