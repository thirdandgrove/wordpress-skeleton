#!/bin/bash


if [[ -f prod-data.sh ]] ; then
  ./prod-data.sh
fi

if [[ ! -f ~/dump.sql ]] ; then
  echo 'No SQL dump found, aborting. Please set one up in prod-data.sh or place one mdump.sql in your home directory'
  exit
fi

HOST=$(grep -E "ip: ([^[:space:]]+)" config.yaml | tr -d 'ip: ')
mysql -uvagrant -pvagrant -h${HOST} -e "drop database if exists vagrant; create database vagrant;"
mysql -uvagrant -pvagrant -h${HOST} vagrant < ~/dump.sql

rm ~/dump.sql
