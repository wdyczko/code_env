#!/usr/bin/env bash

cd $CODE
FILE_NAME=./cscope.files
echo "Removing old cscope database"
rm -rf cscope.out cscope.in.out cscope.po.out cscope.files
echo "Generating file list"
find . -iname "*.c" > $FILE_NAME
find . -iname "*.cpp" >> $FILE_NAME
find . -iname "*.cxx" >> $FILE_NAME
find . -iname "*.cc" >> $FILE_NAME
find . -iname "*.h" >> $FILE_NAME
find . -iname "*.hpp" >> $FILE_NAME
find . -iname "*.hxx" >> $FILE_NAME
find . -iname "*.hh" >> $FILE_NAME
echo "Generating new cscope database"
cscope -b -q -R
