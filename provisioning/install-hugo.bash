#!/bin/env bash

HUGO_VERSION=0.148.1

## terraform docs
echo -e "\033[1;33m===>\033[0m Install gohugo.io"
mkdir /tmp/hugo
cd /tmp/hugo
curl -sL --output ./hugo-e.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb
sudo dpkg -i hugo-e.deb
cd -
rm -fr /tmp/terraform-docs
