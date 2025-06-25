#!/bin/env bash

echo -e "\033[1;33m===>\033[0m Upgrade system packages and distribution"
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y ubuntu-release-upgrader-core
sudo apt-get dist-upgrade -y