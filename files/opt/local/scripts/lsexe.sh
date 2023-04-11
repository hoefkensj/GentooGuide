#!/usr/bin/env bash


function lscompgen()
{
echo "################# ${1} #################"
compgen "${2}${3}"
echo "############################################"
}
case $1 in
a*)
lscompgen ALIASSES -a
;;
b*)
lscompgen BUILDINS -b
;;
c*)
lscompgen COMMANDS -c
;;
f*)
lscompgen FUNCTIONS -A 'function'
;;
k*)
lscompgen KEYWORDS -k
;;
*|A*)
lsexe a
lsexe b
lsexe c
lsexe f
lsexe k
echo "############# HELP #################"
echo "use: $lsexe [a|b|c|f|k|A]"
;;
esac