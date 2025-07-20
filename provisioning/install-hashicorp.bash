#!/bin/bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update 
sudo apt install consul packer terraform vault -y

sudo systemctl disable --now consul
sudo systemctl disable --now vault

## terraform docs
mkdir /tmp/terraform-docs
cd /tmp/terraform-docs
curl -sLo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.20.0/terraform-docs-v0.20.0-linux-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs
sudo cp terraform-docs /usr/local/bin/terraform-docs
cd -
rm -fr /tmp/terraform-docs

## terraform lint
mkdir /tmp/tflint
cd /tmp/tflint
curl -sLo ./tflint_linux_amd64.zip https://github.com/terraform-linters/tflint/releases/download/v0.58.1/tflint_linux_amd64.zip
unzip tflint_linux_amd64.zip
chmod +x tflint
sudo cp tflint /usr/local/bin/tflint
cd -
rm -fr /tmp/tflint