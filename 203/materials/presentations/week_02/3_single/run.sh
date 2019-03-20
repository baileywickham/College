#!/bin/bash
cd `dirname $0`
if [ "$MATERIALS_DIR_203" = "" ] ; then
    # You can set MATERIALS_DIR_203 in you .mybashrc or
    # .bashrc or wherever if you don't want to have to edit
    # this script when you copy the directory.
    MATERIALS_DIR_203=../../..
fi
LIBS=$MATERIALS_DIR_203/lib/testy.jar

#
# Compile the program:
#
rm -f *.class
javac -Xlint:unchecked -Xmaxerrs 5 -cp $LIBS *.java
if [ $? != 0 ] ; then
    exit 1
fi

java -cp $LIBS:. -ea Main $*
rm -f *.class
