#! /bin/bash

# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This volume is assumed to exist and is shared with parent of the init
# container. It contains the mysq config.
CONFIG_VOLUME="/etc/mysql"

# This volume is assumed to exist and is shared with the peer-finder
# init container. It contains on-start/change configuration scripts.
WORKDIR_VOLUME="/work-dir"

for i in "$@"
do
case $i in
    -c=*|--config=*)
    CONFIG_VOLUME="${i#*=}"
    shift
    ;;
    -w=*|--work-dir=*)
    WORKDIR_VOLUME="${i#*=}"
    shift
    ;;
    *)
    # unknown option
    ;;
esac
done

echo installing config scripts into "${WORKDIR_VOLUME}"
mkdir -p "${WORKDIR_VOLUME}"
cp /on-start.sh "${WORKDIR_VOLUME}"/
cp /peer-finder "${WORKDIR_VOLUME}"/

echo installing my-galera.cnf into "${CONFIG_VOLUME}"
mkdir -p "${CONFIG_VOLUME}"
chown -R 27.0 "${CONFIG_VOLUME}"
chmod g+w -R "${CONFIG_VOLUME}"
#chown -R mysql.0 "${CONFIG_VOLUME}"
cp /my-galera.cnf "${CONFIG_VOLUME}"/
