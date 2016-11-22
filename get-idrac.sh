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
NAME=$(sshpass -p ${PASS} ssh ${SSHOPTS} ${USER}@${IP} racadm get idrac.nic.dnsracname | grep DNSRacName | cut -d '=' -f2)
VER=$(sshpass -p ${PASS} ssh ${SSHOPTS} ${USER}@${IP} racadm get idrac.info.version | grep Version | cut -d '=' -f2)
echo "${NAME} (${IP}): ${VER}"
