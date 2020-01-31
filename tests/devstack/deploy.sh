#!/bin/bash
terraform plan

# grab the fake certs from pebble
curl -s https://raw.githubusercontent.com/letsencrypt/pebble/master/test/certs/pebble.minica.pem > pebble.minica.pem
curl -s --cacert pebble.minica.pem https://localhost:15000/roots/0 >> pebble.minica.pem
curl -s --cacert pebble.minica.pem https://localhost:15000/intermediates/0 >> pebble.minica.pem

# patch the url for ACME
sed -i 's+https://acme-v02.api.letsencrypt.org/directory+https://localhost:14000/dir+g' .terraform/modules/dns/dns/acme/main.tf

SSL_CERT_FILE=pebble.minica.pem terraform apply -auto-approve
