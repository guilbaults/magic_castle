#!/bin/bash
ssh-keygen -f id_rsa -t rsa -N ''
eval $(ssh-agent)
ssh-add id_rsa
terraform init

# patch the url for ACME
sed -i 's+https://acme-v02.api.letsencrypt.org/directory+https://localhost:14000/dir+g' .terraform/modules/dns/dns/acme/main.tf

virtualenv-3 env
source env/bin/activate
pip install python-openstackclient

# grab the fake certs from pebble
curl -s https://raw.githubusercontent.com/letsencrypt/pebble/master/test/certs/pebble.minica.pem > pebble.minica.pem
cp pebble.minica.pem chain.pem
curl -s --cacert pebble.minica.pem https://localhost:15000/roots/0 >> chain.pem
curl -s --cacert pebble.minica.pem https://localhost:15000/intermediates/0 >> chain.pem
