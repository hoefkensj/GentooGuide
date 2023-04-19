#!/usr/bin/env bash
# ############################################################################
# # PATH: /etc/profile.d                          AUTHOR: Hoefkens.J@gmail.com
# # FILE: sourcedir.sh                                        0v4 - 2023.04.03
# ############################################################################
#
function sourcedir { 	local WARNING="WARNING: This File Needs to be Sourced not Executed ! ";
	local HELP="$SOURCEDIR [-h]|[-qei] [DIR] [MATCH]
	Arguments:
	DIR             Directory to source files from.
	Files that return True when tested aganst [MATCH] will be sourced

	MATCH           String to match Files against. Globbing and Expansion follow Bash Settings

	Options:
	-h    --help    Show this help text
	-i    --nocase  Ignore Case when matching
	-q    --quiet   Quiet/Silent/Script, Dont produce any output
	--warning Shows $WARNING

	Recommended:       Make Sourcedir availeble as a command
	su -c 'cp -v ./sourcedir.sh /etc/profile.d/

	Examples :
	MATCH :
	'/[0-9]+[_-]*.*\.(sh|bash|bashrc|rc|conf|cfg)$' : DEFAULT
	: Note: enclose the regex in '' or \"\"
	USE :
	sourcedir -q ~/.config/bashrc/ '.*\.bashrc'      : source files in ~/.config/bashrc/ that end in '.bashrc'
	and (-q) do not produce any output as some apparently
	interactive shells (scp,rcp,...) can't tolerate any output.
	sourcedir ~/.winepfx/protonGE/ '\/[0-9]{2}_.*$'  : source files starting with 2 digits + '_ ' in ~/.winepfx/protonGE/
	";
	# set -o errexit
	# set -o nounset
	local _cat _help _warn
	function batcat ()
	{
		function _bat(){
			bat	$( printf '--%s --%s=%s' "plain" "language" "$LANG" )<<< "$1"
		}
		local _cat _bat LANG STRING COLOR
		LANG="$1"
		shift 1
		STRING="$@"
		_cat=$( which "cat" )
		_bat=$( which "bat" )
		[[ -n "$_bat" ]] &&  _bat "$HELP"
		[[ -z $_bat ]] && echo $( printf '%s' "$@" ) | $( printf '%s' "$_cat"  ) 
	};	

	function _help () 
	{ 
		batcat help "$HELP" 
	};
	function _warn () 
	{ 
		batcat  help "$WARNING"
	};
	function _main ()  
	{ 
		local MATCH SRC N W GP GS GC GN ;
		function _sourcefiles () 
		{ 
			function _sourcefile () 			{ 
				source "$1" && _progress "$1" "$GC" 2 "$2"   || _progress "$1" "$GC" 1 "$2"
			};
			for CONF in $SELECTED;
			do
				I=$((I+1));
				[[ -e "$CONF" ]] && _sourcefile "$CONF" "$I" ;
			done
		};
	function _m () #ANSI_m : ansi markup
	{   #~       ANSIESC [$1:INT] ; [$2:INT] m [$3:STRING] ANSIESCm (:resets to default)
		printf "\x1b[%s;3%sm%s\x1b[m" "$1" "$2" "$3"
	};
	function _G () #ANSI_G : ansi cursor to column on current line
	{ 	#~       ANSIESC [$1:INT] G
		printf "\x1b[%sG" "$1"
	};
	function _Gm () # COMBINES G (linepos) and m (markup) 
	{ 	# printf statements are not needed here as they are in the functions
		#~printf  ANSIESC $1 G ANSIESC $2 ; $3 m $4 ANSIESC m
		_G "$1"; 
		_m "$2" "$3" "$4" ;
	#~	ANSIESC [$1:INT] G ANSIESC [$2:INT] ; [$3:INT] m [$4:STRING] ANSIESC m
	#	_Gm printf "\x1b[%sG\x1b[%s;%sm%s\x1b[m" "$1" "$2" "$3" "$4"
	};
	function _mask () 
	{ 
		_Gm "${1}" 0 7 "Sourcing:";
		_Gm "$2" 1 7 "[";
		_Gm "$3" 1 7 "/";
		_Gm "${4}" 1 2 "${5}";
		_m 1 7 "]"
	};
	function _progress () 
	{ #~	 G   m  m   STRING
		_Gm  12  1  3   "$1" ;
		_Gm "$2" 1 "$3" "$4" ;
		_G 82
	};
		SRC=$(realpath "${1}");
		[[ -n "$2" ]] && MATCH="$2" || MATCH='/[0-9]+[_-]*.*\.(sh|bash|bashrc|rc|conf|cfg)$';
		I=0;
		SELECTED=$( find "$SRC" 2>/dev/null |grep -E "$MATCH" );
		[[ -n "$SELECTED" ]] && N=$( echo "$SELECTED" |wc -l );
		W="${#N}";
		GP=$((75-6-W*2));
		GC=$((GP+1));
		GS=$((GP+W+1));
		GN=$((GP+W+2))
		_mask 0 "$GP" "$GS" "$GN" "$N" ;
		_sourcefiles ;
		printf " \x1b[75G\x1b[32mDONE\n"
	};
	local CASE SELECTED I;
	case "$1" in 
		-h | --help | '')
			_help
		;;
		-d | --debug)
			set -o xtrace && ${FUNCNAME[0]} "$@"
		;;
		-q | --quiet)
			shift 1 && ${FUNCNAME[0]} "$@" &> /dev/null
		;;
		-i | --nocase)
			shift 1 && CASE="-i" && ${FUNCNAME[0]} "$@"
		;;
		--warning)
			_cat "\x1b[1;31m" && _warn >> /dev/stderr
		;;
		*)
			_main "$@"
		;;
	esac;
	unset _m _G _progress _mask _state _sourcefiles _main _cat
}

(return 0 2>/dev/null) || sourcedir --warning