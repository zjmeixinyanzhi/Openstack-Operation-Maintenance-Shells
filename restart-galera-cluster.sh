#!/bin/sh
ssh controller01 galera_new_cluster
ssh controller02 systemctl restart mariadb
ssh controller03 systemctl restart mariadb
