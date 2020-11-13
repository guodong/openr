#!/bin/bash

#
# Copyright (c) 2014-present, Facebook, Inc.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

source "$(dirname "$0")/common.sh"

if [ "$1" -ne "nogetdeps"]; then
  "$PYTHON3" "$GETDEPS" --allow-system-packages install-system-deps --recursive fbthrift
  errorCheck "Failed to install-system-deps for fbthrift"

  "$PYTHON3" "$GETDEPS" --allow-system-packages build --no-tests --install-prefix "$INSTALL_PREFIX" fbthrift
  errorCheck "Failed to build fbthrift"

  # TODO: Maybe fix src-dir to be absolute reference to dirname $0's parent
  #"$PYTHON3" "$GETDEPS" fixup-dyn-deps --strip --src-dir=. openr _artifacts/linux  --project-install-prefix openr:"$INSTALL_PREFIX" --final-install-prefix "$INSTALL_PREFIX"
  #errorCheck "Failed to fixup-dyn-deps for openr"
fi

THRIFT_BIN_DIR="/opt/facebook/fbthrift/bin"
if [ ! -d "${THRIFT_BIN_DIR}" ]; then
  echo "No ${THRIFT_BIN_DIR} dir ... exiting ..."
  exit 2
fi

if [ "$PIP3" == "" ]; then
  echo "ERROR: No \`pip3\` in PATH"
  exit 3
fi

export PATH="${PATH}:${THRIFT_BIN_DIR}"
"$PIP3" --no-cache-dir install --upgrade pip setuptools wheel
"$PYTHON3" setup.py install
