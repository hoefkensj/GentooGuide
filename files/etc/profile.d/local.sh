#!/usr/bin/env bash
# ############################################################################
# # PATH: /etc/profile.d                          AUTHOR: Hoefkens.j@gmail.com
# # FILE: local.sh
# ############################################################################
#
export LOCAL_HOME="/opt/local"
export LOCAL_CONFIG="${LOCAL_HOME}/config"
export LOCAL_RC="${LOCAL_CONFIG}/rc"
export LOCAL_BIN="${LOCAL_HOME}/bin"
export LOCAL_CACHEDIR="${LOCAL_HOME}/cache"

export USER_CONFIG="${HOME}/.config"
export USER_RC="${USER_CONFIG}/rc"
export USER_BIN="${HOME}/.bin"
export USER_CACHEDIR="${HOME}/.cache"


[[ ":${PATH}:" != *":/opt/bin:"* ]]  && export  PATH="/opt/bin}:${PATH}"
[[ ":${PATH}:" != *":${LOCAL_BIN}:"* ]]  && export PATH="${LOCAL_BIN}:${PATH}"
[[ ":${PATH}:" != *":${USER_BIN}:"* ]]  && export  PATH="${USER_BIN}:${PATH}"

