#!/usr/bin/env bash
# ############################################################################
# # PATH: /etc/bash/bashrc.d                      AUTHOR: Hoefkens.j@gmail.com
# # FILE: marker.sh
# ############################################################################
#
[[ -n $LOADED ]] && LOADED=() 
[[ -z $LOADED ]] && LOADED+=("/etc/bash/bashrc.d")
