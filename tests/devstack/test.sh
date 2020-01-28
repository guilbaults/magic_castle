#!/usr/bin/env bats
LOGIN_IPADDR=$(jq -j '.outputs.public_ip.value[0]' terraform.tfstate)
GUEST_PASSWD=$(jq -j '.outputs.guest_passwd.value' terraform.tfstate)

ssh_user () {
  echo -n "$(sshpass -p "${GUEST_PASSWD}" ssh -o StrictHostKeyChecking=no user01@${LOGIN_IPADDR} "$1" )"
}

ssh_centos_login () {
  echo -n "$(ssh -o StrictHostKeyChecking=no centos@${LOGIN_IPADDR} "$1" )"
}

@test "checking puppet failed action on login node" {
  result=$(ssh_centos_login "sudo grep "failed:" /opt/puppetlabs/puppet/cache/state/last_run_summary.yaml | awk '{ print \$2 }'")
  [ "$result" -eq 0 ]
}

@test "loading python from cvmfs" {
  result=$(ssh_user "module load python/3.7.4; python -V")
  [ "$result" == "Python 3.7.4" ]
}

@test "node1 is IDLE" {
  result=$(ssh_user "scontrol show node node1 | grep State | awk '{print \$1}'")
  [ "$result" == "State=IDLE" ]
}

