#!/usr/bin/env bash
# ############################################################################
# # PATH: /etc/profile.d/                         AUTHOR: Hoefkens.j@gmail.com
# # FILE: marker.sh
# ############################################################################
#
[[ -n $LOADED ]] && LOADED=() 
[[ -z $LOADED ]] && LOADED+=("/etc/profile.d")
