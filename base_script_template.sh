#!/bin/bash
function fn() {
	local HELP=" ${FUNCNAME[0]} [-h|--help] [args]
	Arguments:
    args            description

    Options:
	-h    --help    Show this help text

	Examples :

	";
    set -o errexit
	set -o nounset
	local _cat _help
	function _cat ()
	{
		local concat;
		local LANG;
		[[ -n $( which "$2" ) ]] && concat="$2" || concat="cat";
		[[ -n "$3" ]] && LANG="$3" || LANG="help";
		[[ -z $COLORTERM ]] && concat="cat";
		[[ "$concat" == "bat" ]] && concat=$(printf '%s --plain --language="%s" ' $(which "$concat") "${LANG}");
		$(printf "%s\n" "$1" | $concat);
	};
	function _help ()
	{
		_cat "$HELP" bat help;
	};
    function _main () {
        echo 'main';
	};
    local FCHECK FVERB;
	case "$1" in
		-h | --help | ' ')
			_help
		;;
		-q | --quiet)
			shift 1 && ${FUNCNAME[0]} "$@" &> /dev/null
		;;
		-v | --verbose)
			shift 1 && FVERB='YES' && ${FUNCNAME[0]} "$@"
		;;
		-d | --debug)
			set -o xtrace && shift 1 && ${FUNCNAME[0]}  "$@"
		;;
		*)
			_main "$@"
		;;
	esac;
	unset _main
	};
fn $@
