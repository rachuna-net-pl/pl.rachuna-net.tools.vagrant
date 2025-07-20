#!/bin/env bash

export VAGRANT_HOSTNAME="dev-station"
export VAGRANT_VM_MEMORY=4096
export VAGRANT_NUM_CPUS=4
export VAGRANT_VM_BASE_IMAGE="rachuna-net.pl/ubuntu-24-10"
export VAGRANT_REPOSITORIES_DIR="/repo"

cd /repo/pl.rachuna-net/tools/vagrant
vagrant up
cd -