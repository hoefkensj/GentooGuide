#!/usr/bin/env bash
# ############################################################################
# # PATH: /opt/local/config/rc/bash               AUTHOR: Hoefkens.j@gmail.com
# # FILE: 311_history.conf                                 2023-04-04 09:33:40
# ############################################################################
#

HISTSIZE=-1 
HISTFILESIZE="$HISTSIZE" 
HISTCONTROL=''
HISTCACHEDIR="/var/cache"
HISTDIR="${HISTCACHEDIR}/history/bash"
HISTPFIX="history"
HISTFILE="${HISTDIR}/${HISTEXT}.$$"
HISTSESSION="${HISTDIR}/${HISTPFIX}.session.$$."

HISTSYSFULL="${HISTDIR}/system.full.${HISTPFIX}"
HISTSYSUNIQ="${HISTDIR}/system.uniq.${HISTPFIX}"
HISTSYSINIT="${HISTDIR}/system.init.${HISTPFIX}"
HISTACTIVE=$(ls "$HISTDIR/$HISTPFIX.session."* 2>/dev/null | grep "$PATTERN")

function bash_history() 
{
	
	function help() 
	{
		
		echo "Usage: $0 [-v | --verbose] [-q | --quiet] [debug | -d | help | -h | append | -a] [filename] [string]"
	}
	function history_install()
	{
		[[ ! -d "$HISTDIR" 			]]	&& install -m 777 -d "$HISTDIR"
		[[ ! -f "$HISTSYSFULL" 		]]	&& install -m 777 /dev/null "$HISTSYSFULL"
		[[ ! -f "$HISTSYSUNIQ"		]]	&& install -m 777 /dev/null "$HISTSYSUNIQ"	
		[[ ! -f "$HISTSYSINIT"		]]	&& install -m 777 /dev/null "$HISTSYSINIT"	
	}
	
	function session_start()
	{
		#writepossible (now) orphaned previous histfile with identical $PID to fullhistory file
		[[ -f "$HISTSESSION" ]]	&& cat "$HISTSESSION" >> "$HISTSYSFULL" 
		#create an empty session history file 
		install -m 777 /dev/null "$HISTSESSION"
		# install -m 777 /dev/null "$GLOBUNIQ"
		echo "$DATESTAMP" >> "$HISTSESSION"
		echo "$DATESTAMP" >> "$HISTSYSFULL"
		get_uniq "$HISTSYSFULL" > "$HISTSYSUNIQ"
		cat "$HISTSYSUNIQ" > "$HISTFILE"
		active_history "$HISTFILE"
		builtin history -r "$HISTFILE"
	}

	function get_uniq()	
	{
		#tac "${HISTSYSFULL}" | a  | tac
		awk '{ lines[NR] = $0 } END { for(i=NR;i>=1;i--) if(!seen[lines[i]]++) rev[++j] = lines[i]; for(k=j;k>=1;k--) print rev[k] }' "$1" 
	}
	function active_history ()
	{
		ACTIVE=$(pgrep "$(ps -p $$ -o comm=)")
		PATTERN=$(for pid in $ACTIVE; do echo -n "-e \${pid}\* "; done)
		ORPHANED=$(ls "$HISTDIR/$HISTPFIX.session."* 2>/dev/null | grep -v "$PATTERN")
		HISTACTIVE=$(ls "$HISTDIR/$HISTPFIX.session."* 2>/dev/null | grep "$PATTERN")
		for f in $HISTACTIVE; do
			cat "$f" >> "$1"		
		done
	}

	local DATESTAMP VERBOSE QUIET

	# Set default values for flags
	VERBOSE=0
	QUIET=0
	DATESTAMP="$( date +%Y%m%d )$USER@$HOSTNAME: $( tty )"

	
	options=$(getopt -o vqdha: --long verbose,quiet,debug,help,append: -- "$@")
	eval set -- "$options"
	while true; do
	    case "$1" in
	        -v | --verbose) VERBOSE=1; shift ;;
	        -q | --quiet) shift && ${FUNCNAME[0]} "$@" >> /dev/null ;;
	        -d | --debug) shift && set -o xtrace && ${FUNCNAME[0]} "$@" ;;
	        -h | --help) command=help; shift ;;
	        -s | --start) command=start; filename="$2"; shift 2 ;;
	        --) shift; break ;;
	        *) echo "Error: Invalid option $1"; HELP; exit 1 ;;
	    esac
	done

	# Run the command
	case "$command" in
	    help) help ;;
	    install) history_install ;;
		start) session_start ;;
	    *) echo "Error: No command specified"; help; exit 1 ;;
	esac
}
bash_history "$@"