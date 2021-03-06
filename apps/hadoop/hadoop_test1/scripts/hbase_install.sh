#!/bin/bash

. ${APP_ROOT}/toolset/setup/basic_cmd.sh
######################################################################################
# Notes:
#  To install HBase
#
#####################################################################################
BUILD_DIR="./"$(tool_get_build_dir $1)
VERSION="1.3.0"
INSTALL_DIR="/u01/hbase"
TARGET_DIR=$(tool_get_first_dirname ${BUILD_DIR})
SERVER_FILENAME=${BUILD_DIR}/${TARGET_DIR}/hbase-dist/target/hbase-${VERSION}.tar.gz

#######################################################################################
if [ ! "$(tool_check_exists ${SERVER_FILENAME})"  == 0 ]; then
      echo "HBase-${VERSION} has not been built successfully"
      exit -1
fi

TARGET_DIR=$(tool_get_first_dirname ${INSTALL_DIR})
if [ "$(tool_check_exists ${INSTALL_DIR}/${TARGET_DIR}/bin/hadoop)"  == 0 ]; then
      echo "HBase-${VERSION} has been installed successfully"
      exit 0
fi

####################################################################################
# Prepare for install
####################################################################################
$(tool_add_sudo) useradd hbase
$(tool_add_sudo) passwd hbase hbasetest
$(tool_add_sudo) mkdir -p ${INSTALL_DIR}
$(tool_add_sudo) chown hbase.$(whoami) ${INSTALL_DIR}

tar -zxvf ${SERVER_FILENAME} -C ${INSTALL_DIR}
TARGET_DIR=$(tool_get_first_dirname ${INSTALL_DIR})
source /etc/profile
echo "Finish install preparation......"

######################################################################################
# Install HBase
######################################################################################

if [ -z "$(grep HBASE_INSTALL /etc/profile)" ] ; then
    echo "export HBASE_INSTALL=${INSTALL_DIR}/${TARGET_DIR}" >> /etc/profile
    echo 'export PATH=${HBASE_INSTALL}/bin:${HBASE_INSTALL}/sbin:${PATH}' >> /etc/profile
    echo 'export PATH=$HBASE_INSTALL/bin:$PATH' >> /etc/profile
fi
source /etc/profile

