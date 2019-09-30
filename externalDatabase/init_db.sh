#!/bin/bash
/etc/init.d/mysql start;
sleep 5
mysql -u root -e "create database teamcity collate utf8_bin";
mysql -u root -e "create user teamcity identified by 'password'";
mysql -u root -e "grant all privileges on teamcity.* to teamcity";
mysql -u root -e "grant process on *.* to teamcity";