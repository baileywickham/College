#!/bin/bash
#scp -o RequestTTY=force -r /home/y/workspace/357 wickham@unix1.csc.calpoly.edu:/home/wickham
DIR=CPE315
git add -A && git commit -am "automated deploy by deploy.sh" && git push
ssh -t calpoly "cd ${DIR}; git fetch --all; git reset --hard origin/master;"
