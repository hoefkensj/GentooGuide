#!/usr/bin/env bash
# ############################################################################
# # PATH: /etc/profile.d/                         AUTHOR: Hoefkens.j@gmail.com
# # FILE: marker.sh
# ############################################################################
_SOURCEDDIR="/etc/profile.d"
[[ -z $LOADED ]] && LOADED=() 
[[ -n $LOADED ]] && LOADED+=()"$_SOURCEDDIR")
unset _SOURCEDDIR
