#!/bin/bash
#assign variables if cli params are passed in
if [ $# -gt 1 ]
then
    dir=$2
    cmd=$1
else
    dir=$1
fi

if [ -z "$dir" ] || [ ! -d $dir ]
then
    # Check to see if it is being turned in correctly
    echo "must supply valid dest dir"
    echo "valid options are --ssh <p#>"
    exit
else
    # cp files
    rm -rf $HOME/workspace/203/turnin-baileywickham/$dir
    mkdir $HOME/workspace/203/turnin-baileywickham/$dir
    cp -r $HOME/workspace/203/turnin-baileywickham/cs203game/project/given_code/* $HOME/workspace/203/turnin-baileywickham/$dir

    # if ssh, turn in assignment
    if [ "$cmd" == "--ssh" ]
    then
        git add $dir && git commit -am "automated commit by deploy.sh" && git push
        ssh -t calPoly "/home/wffoote/public/bin/checkgit -log -ssh baileywickham 203 $dir"
    fi
fi
