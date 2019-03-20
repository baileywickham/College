#!/bin/sh -x

javac *.java
if [ $? != 0 ] ; then
    exit 1
fi
java foo

java -ea foo            # -ea is "enable assertions"

rm *.class
