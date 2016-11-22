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

# get idrac dns name
echo "getting host name..."
NAME=$(sshpass -p ${PASS} ssh ${SSHOPTS} ${USER}@${IP} racadm get idrac.nic.dnsracname | grep DNSRacName | cut -d '=' -f2)

if [[ $NAME != *prefix* ]] ; then
  echo "DNSRacName not set properly (expected: prefix-XXXX, found: $NAME)" >&2
  NAME=$IP
fi
echo "host name: ${NAME}"

echo "getting sysinfo -> ${NAME}.info"
sshpass -p ${PASS} ssh ${SSHOPTS} ${USER}@${IP} racadm getsysinfo  >${NAME}.info

echo "getting hwinventory -> ${NAME}.hwinv"
sshpass -p ${PASS} ssh ${SSHOPTS} ${USER}@${IP} racadm hwinventory >${NAME}.hwinv

echo "getting swinventory -> ${NAME}.swinv"
sshpass -p ${PASS} ssh ${SSHOPTS} ${USER}@${IP} racadm swinventory >${NAME}.swinv

