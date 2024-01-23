#!/bin/bash

echo "OM server of type ${OM_TYPE} will be set-up"

	apt-get update
	apt-get install -y --no-install-recommends gnupg2 dirmngr
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 234821A61B67740F89BFD669FC8A16625AFA7A83

	KURENTO_LIST="/etc/apt/sources.list.d/kurento.list"
	echo "# Kurento Media Server - Release packages" > ${KURENTO_LIST}
	echo "deb [arch=amd64] http://ubuntu.openvidu.io/7.0.0 focal main" >> ${KURENTO_LIST}

	echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

	apt-get update
	apt-get install -y --no-install-recommends \
		kurento-media-server 
	apt-get clean
	rm -rf /var/lib/apt/lists/*
	sed -i "s/DAEMON_USER=\"kurento\"/DAEMON_USER=\"${DAEMON_USER}\"/g" /etc/default/kurento-media-server

echo "session required pam_limits.so" >> /etc/pam.d/common-session

