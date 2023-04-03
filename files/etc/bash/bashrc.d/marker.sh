#!/usr/bin/env bash
# ############################################################################
# # PATH: /etc/bash/bashrc.d                      AUTHOR: Hoefkens.j@gmail.com
# # FILE: marker.sh
# ############################################################################
_SOURCEDDIR="/etc/bash/bashrc.d"
[[ -z $LOADED ]] && LOADED=() 
[[ -n $LOADED ]] && LOADED+=()"$_SOURCEDDIR")
unset _SOURCEDDIR
