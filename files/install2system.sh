#!/usr/bin/env bash
# ############################################################################
# # PATH: ./GentooGuide                           AUTHOR: Hoefkens.j@gmail.com
# # FILE: install2system.sh
# ############################################################################
#
install -vD ./etc/bash/bashrc.d/* /etc/bash/bashrc.d/
install -vD ./etc/profile.d/* /etc/profile.d/
install -vD ./opt/local/config/rc/bash/* /opt/local/config/rc/bash/
install -vD ./opt/local/scripts/* /opt/local/scripts/
install -vD ./opt/rep/* /opt/rep
install -vD ./opt/bin/* /opt/bin/

