# Deploy.sh
setting up a deploy repo to make unix server development less awful.


## Github

1. Create a Github account if you do not have one.
2. Create a public or private repo which will hold your class projects.
3. Add your ssh keys to Github.
    1. Generate your ssh keys on your local machine with `ssh-keygen`
    1. In Github, go to settings -> SSH and GPG Keys -> New SSH key
    1. On your machine `cat .ssh/id_rsa.pub`
    1. Copy this value into the new ssh key slot and name it something useful.
