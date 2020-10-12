#!/bin/bash

if [[ " $@ " =~ " --delete-persistent-volumes " ]];
then
    echo "WARNING, this will delete UKC persistent volumes"
    read -p "Continue? [y/n] " -n 1 -r
    echo   
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
fi

./ukc/stop.sh $@
./other/mongodb/stop.sh $@
