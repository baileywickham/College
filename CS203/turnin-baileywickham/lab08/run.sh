#!/bin/bash -x
cd `dirname $0`
if [ "$MATERIALS_DIR_203" = "" ] ; then
    # You can set MATERIALS_DIR_203 in you .mybashrc or
    # .bashrc or wherever if you don't want to have to edit
    # this script when you copy the directory.
    echo "Please set the MATERIALS_DIR_203 environment variable"
    exit 1
fi
LIBS=$MATERIALS_DIR_203/lib/testy.jar:$MATERIALS_DIR_203/lib/spritely.jar

#
# Compile the program:
#
rm -rf out
mkdir out
javac -Xlint:unchecked -Xmaxerrs 5 -sourcepath src  \
	-cp $LIBS -d out src/*.java
if [ $? != 0 ] ; then
    exit 1
fi

#
# If ^C is entered, make sure we get out of "stty cbreak" mode,
# as set below:
#
function reset_tty {
    stty sane
}
trap reset_tty INT
HEADLESS=""
# To test headless mode, set this:
# HEADLESS=-Djava.awt.headless=true

stty -echo cbreak

java $HEADLESS -cp out:$LIBS -ea Main $*
reset_tty
