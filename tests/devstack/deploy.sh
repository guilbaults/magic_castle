#!/bin/bash
export LOGIN_IPADDR=$(jq -j '.outputs.public_ip.value[0]' terraform.tfstate)
export GUEST_PASSWD=$(jq -j '.outputs.guest_passwd.value' terraform.tfstate)
source ./common.sh

terraform plan

eval $(ssh-agent)
ssh-add id_rsa

SSL_CERT_FILE=pebble.minica.pem terraform apply -auto-approve

# wait until the VM are ready
for vm in login1 mgmt1 node1;
do
    echo checking if $vm is waiting at the prompt
    retry -t 50 -s 30 "./env/bin/openstack console log show $vm | grep '$vm login:' > /dev/null"
    echo vm $vm is done booting, checking if puppet ran once
    retry -t 50 ssh_centos_$vm "sudo test -f /opt/puppetlabs/puppet/cache/state/last_run_summary.yaml"
done

