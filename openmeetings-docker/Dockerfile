FROM ubuntu:20.04
ENV OM_VER_MAJ='8'
ENV OM_VER_MIN='0'
ENV OM_VER_MIC='0'
ENV OM_VERSION="${OM_VER_MAJ}.${OM_VER_MIN}.${OM_VER_MIC}"
LABEL version="${OM_VERSION}"

ENV DB_ROOT_PASS '12345'
ENV OM_USER="omadmin"
ENV OM_PASS="StrongPass"
ENV DAEMON_USER="nobody"
ENV DAEMON_UID="65534"
ENV OM_KURENTO_WS_URL="ws://127.0.0.1:8888/kurento"
ENV OM_DATA_DIR="/opt/omdata"
ENV work=/opt
ENV OM_HOME=/opt/openmeetings
ENV MYSQL_J_VER="8.2.0"
ENV DB2_J_VER="11.5.9.0"
ENV PORTS=5443
ENV SERVER_TZ=UTC

WORKDIR ${OM_HOME}
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
  && apt-get install -y --no-install-recommends \
    software-properties-common \
    gnupg2 \
    dirmngr \
    unzip \
    wget \
    ghostscript \
    libgs-dev \
    imagemagick \
    sox \
    sudo \
    openjdk-17-jre

RUN apt-get install -y --no-install-recommends \
    libreoffice \
    ffmpeg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  \
  && wget https://ci-builds.apache.org/job/OpenMeetings/job/openmeetings/lastSuccessfulBuild/artifact/openmeetings-server/target/apache-openmeetings-${OM_VERSION}-SNAPSHOT.tar.gz -O ${work}/om.tar.gz \
  && tar -xzf ${work}/om.tar.gz --strip-components=1 -C ${OM_HOME}/ \
  && rm -rf ${work}/om.tar.gz \
  && wget https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/${MYSQL_J_VER}/mysql-connector-j-${MYSQL_J_VER}.jar -P ${OM_HOME}/webapps/openmeetings/WEB-INF/lib \
  && wget https://repo1.maven.org/maven2/com/ibm/db2/jcc/${DB2_J_VER}/jcc-${DB2_J_VER}.jar -P ${OM_HOME}/webapps/openmeetings/WEB-INF/lib \
  && sed -i 's|<policy domain="coder" rights="none" pattern="PS" />|<!--policy domain="coder" rights="none" pattern="PS" />|g; s|<policy domain="coder" rights="none" pattern="XPS" />|<policy domain="coder" rights="none" pattern="XPS" /-->|g' /etc/ImageMagick-6/policy.xml

WORKDIR ${work}
COPY scripts/*.sh ./

RUN chmod a+x ${work}/*.sh

ARG BUILD_TYPE="min"
ENV OM_TYPE=${BUILD_TYPE}

RUN cat /etc/issue \
  \
  && echo "OM server of type ${OM_TYPE} will be built" \
  \
  && ./om_install.sh

EXPOSE ${PORTS}

ENTRYPOINT [ "bash", "-c", "${work}/om.sh" ]

