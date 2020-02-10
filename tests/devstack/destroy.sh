#!/bin/bash
if [ -f "terraform.tfstate" ]; then
    SSL_CERT_FILE=pebble.minica.pem terraform destroy -auto-approve
fi
