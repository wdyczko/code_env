#!/usr/bin/env bash

cd $CODE
echo "Removing old tags"
rm -rf tags
echo "Generating new tags"
ctags -R
