#!/bin/bash

# debug
#set -x

IP=$1
NAME=$2
USER=${3:-root}
PASS=${4:-calvin}
SSHOPTS="-q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

if [ ! -x "/usr/bin/sshpass" ] ; then
  echo "sshpass command is needed to run this script"
  exit 2
fi

if [ -z $IP ] || [ -z $NAME ] ; then
  echo "Usage: $0 ip_address hostname [login [password]]"
  exit 3
fi

sshpass -p ${PASS} ssh ${SSHOPTS} ${USER}@${IP} << EOF
  racadm set System.LCD.UserDefinedString ${NAME}
  racadm set System.LCD.Configuration 0
  racadm set iDRAC.NIC.DNSRacName ${NAME}
EOF
