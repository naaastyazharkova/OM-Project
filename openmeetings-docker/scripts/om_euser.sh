#!/bin/bash
if [[ `id -u ${DAEMON_USER} 2>/dev/null || echo -1` < 0 ]]; then
	useradd -l -u ${DAEMON_UID} ${DAEMON_USER}
fi
if [ ! -d "${OM_HOME}/logs" ]; then
	mkdir ${OM_HOME}/logs
fi
chown -R ${DAEMON_USER} ${OM_HOME}

if [ "${OM_TYPE}" != "min" ]; then
	if [ ! -d "/var/run/mysqld" ]; then
		mkdir /var/run/mysqld
	fi
	
	if [ -f "/var/run/mysqld/mysqld.sock.lock" ]; then
		rm -rf /var/run/mysqld/mysqld.sock.lock
	fi
	usermod -d /var/lib/mysql mysql
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && service mysql restart
fi

echo "${DAEMON_USER}          hard     nofile          16384" >> /etc/security/limits.conf
echo "${DAEMON_USER}          soft     nofile          16384" >> /etc/security/limits.conf

