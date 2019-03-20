#!/bin/sh

javac -Xlint:unchecked *.java
# javac *.java
if [ $? != 0 ] ; then
    exit 1
fi
java -ea Main
rm *.class
