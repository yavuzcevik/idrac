#!/bin/bash

# debug
#set -x

IP=$1
USER=${2:-root}
PASS=${3:-calvin}
SSHOPTS="-q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

if [ ! -x "/usr/bin/sshpass" ] ; then
  echo "sshpass command is needed to run this script"
  exit 2
fi

if [ -z $IP ] ; then
  echo "Usage: $0 ip_address [login [password]]"
  exit 3
fi

echo "=== previous vnc configuration ==="
sshpass -p ${PASS} ssh ${SSHOPTS} ${USER}@${IP} racadm get idrac.vncserver
echo
echo "reconfiguring..."
sshpass -p ${PASS} ssh ${SSHOPTS} ${USER}@${IP} >/dev/null << EOF
  racadm get idrac.vncserver
  racadm set idrac.vncserver.enable 1
  racadm set idrac.vncserver.password ${PASS}
  racadm set idrac.vncserver.port 5901
  racadm set idrac.vncserver.timeout 600
  racadm set idrac.vncserver.SSLEncryptionBitLength 0
EOF
echo
echo "=== new vnc configuration ==="
sshpass -p ${PASS} ssh ${SSHOPTS} ${USER}@${IP} racadm get idrac.vncserver
echo
