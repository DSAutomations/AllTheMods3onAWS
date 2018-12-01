#!/bin/bash

cd ~
tar -zcvf ~/old-backups.tar.gz minecraft-atm/backups
aws s3 cp ~/old-backups.tar.gz s3://mc-server-main-78009249
rm ~/minecraft-atm/backups/*
rm ~/old-backups.tar.gz
