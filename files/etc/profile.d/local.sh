#!/usr/bin/env bash
# ############################################################################
# # PATH: /etc/profile.d                          AUTHOR: Hoefkens.j@gmail.com
# # FILE: local.sh
# ############################################################################
#
## LOCAL VARS
export LOCAL_HOME="/opt/local"
export LOCAL_CONFIG="${LOCAL_HOME}/config"
export LOCAL_RC="${LOCAL_CONFIG}/rc"
export LOCAL_BIN="${LOCAL_HOME}/bin"
export LOCAL_CACHE="${LOCAL_HOME}/cache"
## USER VARS
export USER_CONFIG="${HOME}/.config"
export USER_RC="${USER_CONFIG}/rc"
export USER_BIN="${HOME}/.bin"
export USER_CACHE="${HOME}/.cache"

#HISTORY VARS 
export HISTFOLDER="${LOCAL_CACHE}/bash/history"
export HISTGLOBAL="${LOCAL_CACHE}/bash/history/history.glob"
export HISTSESSION="${LOCAL_CACHE}/bash/history/history.session.$$"
export HISTFILE="${USER_CACHE}/bash/history/history.$$"
export HISTSESSIONS="${HISTFOLDER}/history.[0-9]*"
export HISTSIZE=-1
export FalseHISTFILESIZE="$HISTSIZE" 
export HISTCONTROL=''

PATHARR=($(tr ':' '\n' <<< "$PATH"))
[[ ":${PATH}:" != *":/opt/bin:"* ]]  && PATHARR=("/opt/bin" "${PATH[@]}")
[[ ":${PATH}:" != *":${LOCAL_BIN}:"* ]]  && PATHARR=("${LOCAL_BIN}" "${PATH[@]}")
[[ ":${PATH}:" != *":${USER_BIN}:"* ]]  && PATHARR=("${USER_BIN}" "${PATH[@]}")
export PATH=$( tr ' ' ':' <<< "${PATHARR[@]}")

unset PATHARR