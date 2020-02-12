#!/bin/bash
export LOGIN_IPADDR=$(jq -j '.outputs.public_ip.value[0]' terraform.tfstate)
export GUEST_PASSWD=$(jq -j '.outputs.guest_passwd.value' terraform.tfstate)

function ssh_user {
  echo -n "$(sshpass -p "${GUEST_PASSWD}" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null user01@${LOGIN_IPADDR} "$1" )"
}

function ssh_centos_login1 {
  echo -n "$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null centos@${LOGIN_IPADDR} "$1" )"
}

function ssh_centos_mgmt1 {
  echo -n "$(ssh -A -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null centos@${LOGIN_IPADDR} "ssh centos@mgmt1 $1" )"
}

function ssh_centos_node1 {
  echo -n "$(ssh -A -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null centos@${LOGIN_IPADDR} "ssh centos@node1 $1" )"
}

export -f ssh_user
export -f ssh_centos_login1
export -f ssh_centos_mgmt1
export -f ssh_centos_node1
