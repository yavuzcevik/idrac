#!/bin/bash

# debug
#set -x

IP=$1
USER=${2:-root}
PASS=${3:-calvin}
SSHOPTS="-q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

if [ ! -x "/usr/bin/sshpass" ] ; then
  echo "sshpass command is needed to run this script" >&2
  exit 2
fi

if [ -z $IP ] ; then
  echo "Usage: $0 ip_address [login [password]]" >&2
  exit 3
fi

sshpass -p ${PASS} ssh ${SSHOPTS} ${USER}@${IP} << EOF
  racadm jobqueue delete -i JID_CLEARALL
  racadm set BIOS.OneTimeBoot.OneTimeBootMode OneTimeBootSeq
  racadm set BIOS.OneTimeBoot.OneTimeBootSeqDev NIC.Integrated.1-1-1
  racadm jobqueue create BIOS.Setup.1-1 -r pwrcycle
EOF
