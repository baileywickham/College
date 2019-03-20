#!/bin/sh -x

javac *.java
if [ $? != 0 ] ; then
    exit 1
fi
time java Point
