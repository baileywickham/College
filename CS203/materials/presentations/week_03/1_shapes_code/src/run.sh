#!/bin/bash
cd `dirname $0`

#
# Compile the program:
#
rm -f *.class
javac -Xlint:unchecked -Xmaxerrs 5 *.java
if [ $? != 0 ] ; then
    exit 1
fi

java -ea MyGUI
rm -f *.class
