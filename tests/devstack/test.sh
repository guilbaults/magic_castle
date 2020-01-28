#!/usr/bin/env bats
LOGIN_IPADDR=$(jq -j '.outputs.public_ip.value[0]' terraform.tfstate)
GUEST_PASSWD=$(jq -j '.outputs.guest_passwd.value' terraform.tfstate)

ssh_user () {
  echo -n "$(sshpass -p "${GUEST_PASSWD}" ssh -o StrictHostKeyChecking=no user01@${LOGIN_IPADDR} "$1" )"
}

ssh_centos_login1 () {
  echo -n "$(ssh -o StrictHostKeyChecking=no centos@${LOGIN_IPADDR} "$1" )"
}

ssh_centos_mgmt1 () {
  echo -n "$(ssh -A -o StrictHostKeyChecking=no centos@${LOGIN_IPADDR} "ssh centos@mgmt1 $1" )"
}

ssh_centos_node1 () {
  echo -n "$(ssh -A -o StrictHostKeyChecking=no centos@${LOGIN_IPADDR} "ssh centos@node1 $1" )"
}

@test "checking puppet failed action on login1" {
  result=$(ssh_centos_login1 "sudo grep "failed:" /opt/puppetlabs/puppet/cache/state/last_run_summary.yaml | awk '{ print \$2 }'")
  [ "$result" -eq 0 ]
}

@test "checking puppet failed action on mgmt1" {
  result=$(ssh_centos_mgmt1 "sudo grep "failed:" /opt/puppetlabs/puppet/cache/state/last_run_summary.yaml | awk '{ print \$2 }'")
  [ "$result" -eq 0 ]
}

@test "checking puppet failed action on node1" {
  result=$(ssh_centos_node1 "sudo grep "failed:" /opt/puppetlabs/puppet/cache/state/last_run_summary.yaml | awk '{ print \$2 }'")
  [ "$result" -eq 0 ]
}

@test "loading python from cvmfs" {
  result=$(ssh_user "module load python/3.7.4; python -V")
  [ "$result" == "Python 3.7.4" ]
}

@test "node1 is IDLE in slurm" {
  result=$(ssh_user "scontrol show node node1 | grep State | awk '{print \$1}'")
  [ "$result" == "State=IDLE" ]
}

@test "mgmt1 is up" {
  result=$(ssh_centos_mgmt1 "hostname")
  [ "$result" == "mgmt1.int.foufounes.calculquebec.cloud" ]
}

@test "jupyter is up" {
  result=$(curl https://jupyter.foufounes.calculquebec.cloud)
  [ "$?" -eq 0 ]
}

