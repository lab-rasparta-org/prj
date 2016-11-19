#!/bin/sh

## CONFIGURATIONS:
#
#  Assign the name of the script to be installed to $originalscriptname.
originalscriptname=$(basename $(find $(dirname $0)/.. -maxdepth 1 -type f -perm -u=r -perm -u=x))
#

#  The name of this script.
scriptname=$(basename $0 .sh)
#

#  The function of this script
scriptfunction="Installs $originalscriptname to the first writable directory in your \$PATH."
#

#  If everything is configured, set the $configured variable to "Yes".
configured=Yes
#
## CONFIGURATION END

## AUTO-INICIALIZATION
#
#  function aboutme (don't change!)
aboutme() {
echo "$scriptfunction"
}

#  What to do if not configured?
notconfigured() {
    cat << EOF
Configure me first. It'll only take you a moment.
 
EOF
    exit 1
}

#  What to do if in panic?
showhelp() {
    cat << EOF
Name:
	$scriptname - $scriptfunction
 
Usage:
	[$originalscriptname run $originalscriptname] $scriptname [aboutme|help]
	[$originalscriptname run $originalscriptname] $scriptname
 
EOF
}
#

#  Am I configured?
[ "$configured" != "Yes" ] && notconfigured
#
## CONFIGURATION end
#  Ok, let's go then...

case $1 in

    aboutme)
	aboutme
	exit 0
	;;

    help)
	showhelp
	exit 0
	;;

    *)
	OLD_IFS=$IFS
	IFS=':'
	for dir in $PATH
	do
	    if [ -w $dir ]
	    then
		cp -i $(dirname $0)/../$originalscriptname $dir && exit 0
	    fi
	done
	pathdirwritable="No"
	for dir in $PATH
	do
	    if [ -w $dir ]
	    then
		pathdirwritable="Yes"
	    fi
	done
	if [ $pathdirwritable = "No" ]
	then
	    echo "No writable directory in your \$PATH!"
	else
	    echo "Something wrong must have happened!"
	fi
	exit 1
	;;
esac

exit 1
