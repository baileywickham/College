#!/bin/sh

javac -Xlint:unchecked *.java
if [ $? != 0 ] ; then
    exit 1
fi
java StreamDemo
rm *.class
