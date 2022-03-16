#!/bin/bash
#This file validates if a docker conteiner exists and if it's up. 
var=$(docker ps -a --filter name=ml-service -q)
up=$(docker ps -a --filter name=ml-service --filter status=running -q)
exited=$(docker ps -a --filter name=ml-service --filter status=exited -q)

if [ ! -z "$var" ];
then
	if [ ! -z "$up" ];
	then
		echo "existe y esta corriendo"
		docker stop $up
		docker rm $up
	elif [ ! -z "$exited" ];
	then
		echo "exite y no esta corriendo"
		docker rm $exited
	fi
fi

