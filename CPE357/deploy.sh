#!/bin/bash
#scp -o RequestTTY=force -r /home/y/workspace/357 wickham@unix1.csc.calpoly.edu:/home/wickham
git add -A && git commit -am "automated deploy by deploy.sh" && git push
ssh -t calpoly "cd 357; git fetch --all; git reset --hard origin/master;"
