#!/bin/bash

. ${work}/om_euser.sh
echo "OM server of type ${OM_TYPE} will be run"
CLASSES_HOME=${OM_HOME}/webapps/openmeetings/WEB-INF/classes
if [ "${OM_TYPE}" == "min" ]; then
	DB_CFG_HOME=${CLASSES_HOME}/META-INF
	cp ${DB_CFG_HOME}/${OM_DB_TYPE}_persistence.xml ${DB_CFG_HOME}/persistence.xml
	case ${OM_DB_TYPE} in
		db2)
			sed -i "s|localhost:50000/openmeet|${OM_DB_HOST}:${OM_DB_PORT}/${OM_DB_NAME}|g" ${DB_CFG_HOME}/persistence.xml
		;;
		mssql)
			sed -i "s|localhost:1433;databaseName=openmeetings|${OM_DB_HOST}:${OM_DB_PORT};databaseName=${OM_DB_NAME}|g" ${DB_CFG_HOME}/persistence.xml
		;;
		mysql)
			sed -i "s|localhost:3306/openmeetings?|${OM_DB_HOST}:${OM_DB_PORT}/${OM_DB_NAME}?serverTimezone=${SERVER_TZ}\&amp;|g" ${DB_CFG_HOME}/persistence.xml
		;;
		postgresql)
			sed -i "s|localhost:5432/openmeetings|${OM_DB_HOST}:${OM_DB_PORT}/${OM_DB_NAME}|g" ${DB_CFG_HOME}/persistence.xml
		;;
	esac
	sed -i "s/Username=/Username=${OM_DB_USER}/g; s/Password=/Password=${OM_DB_PASS}/g" ${DB_CFG_HOME}/persistence.xml
	if [ ! -d "${OM_DATA_DIR}" ]; then
		echo "Make data dir ${OM_DATA_DIR}"
		mkdir "${OM_DATA_DIR}"
	fi

	export CATALINA_OPTS="-DDATA_DIR=${OM_DATA_DIR}"
else
	export GST_REGISTRY=/tmp/.gstcache
	sudo ln -nfs /usr/lib/x86_64-linux-gnu/libopenh264.so.4 /usr/lib/x86_64-linux-gnu/libopenh264.so.0
	service kurento-media-server start
fi

echo Current max open files is $(su nobody --shell /bin/bash --command "ulimit -n")
cd ${OM_HOME}
sudo --preserve-env=CATALINA_OPTS -u ${DAEMON_USER} HOME=/tmp ${OM_HOME}/bin/catalina.sh run

