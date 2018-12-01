#!/bin/bash

#zip and upload to s3
cd ~
tar -zcf ~/mc-server-backup.tar.gz minecraft-atm
aws s3 cp ~/mc-server-backup.tar.gz s3://mc-server-main-78009249
