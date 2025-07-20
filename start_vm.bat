@echo off

set VAGRANT_HOSTNAME=dev-station
set VAGRANT_VM_MEMORY=4096
set VAGRANT_NUM_CPUS=4
set VAGRANT_VM_BASE_IMAGE=rachuna-net.pl/ubuntu-24-10
set VAGRANT_REPOSITORIES_DIR=/repo

cd C:\Repo\pl.rachuna-net\tools\vagrant
vagrant up
cd -
