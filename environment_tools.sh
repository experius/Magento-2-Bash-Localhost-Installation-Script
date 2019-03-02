#!/bin/bash 

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIGPATH=$SCRIPTPATH/config.sh
if [ -e $CONFIGPATH ]
then
    . $CONFIGPATH
else
    . $SCRIPTPATH/config.sample.sh
fi

EMNT_DEFAULT_SITE_CONFIG="$SCRIPTPATH/site_domain_aliases.txt"

get_site_config_part() {
	echo $(echo "$1" | cut -d$'\t' -f$2 ||)
}

get_site_config() {
	CONFIG_FILE=$1
	QUERY=$2
	DEFAULT_ENV=$3

	# Read configuration
	CONFIG_LINE="$(grep -w "^$QUERY" "$CONFIG_FILE")"
	
	# Clear current loaded config
	export SITE_DOMAIN=""
	export SITE_ENV=""
	export SITE_EXTRA=""
	
	SITE_DOMAIN="$(get_site_config_part "$CONFIG_LINE" 2)"
	SITE_ENV="$(get_site_config_part "$CONFIG_LINE" 3)"
	SITE_EXTRA="$(get_site_config_part "$CONFIG_LINE" 4)"

	# Export current site info
	export SITE_DOMAIN="${SITE_DOMAIN:-$QUERY}"
	export SITE_ENV="${DEFAULT_ENV:-$SITE_ENV}"
	export SITE_EXTRA="$SITE_EXTRA"
}

get_env_ssh_config() {
	SITE_ENV=$1
	export SITE_ENV_HOST="$(grep $SITE_ENV ~/.ssh/config -A 3 | grep '^.*HostName' | sed 's/HostName//' | tr -cd '[[:alnum:]]._-' | xargs)"
}

# Mount a remote website
# mount_site alias/domain [ssh_alias] [mounting_dir]
mount_site() {
	# Get site config
	get_site_config $EMNT_DEFAULT_SITE_CONFIG $1 $2

	# Check site vars
	if [ -z "$SITE_ENV" ]; then
		echo "Could not find configuration for \"$SITE_DOMAIN\". Please check your config: $EMNT_DEFAULT_SITE_CONFIG."
		return
	fi

	# If provided use given mount directory. Otherwise use default mount dir + domain name
	MNT_DIR="$3"
	if [ -z "$MNT_DIR" ]; then
		MNT_DIR="$SITE_DOMAIN"
	fi

	get_env_ssh_config "$SITE_ENV"

	SITE_REMOTE_LOCATION="$(echo "$EMNT_DEFAULT_SITE_REMOTE_LOCATION_FORMAT" | envsubst)"
        if [ -z "$3" ]; then
                SITE_LOCAL_LOCATION="$EMNT_DEFAULT_SITE_MOUNT_DIR/$(echo "$EMNT_DEFAULT_SITE_LOCAL_LOCATION_FORMAT" | envsubst)"
	else
		SITE_LOCAL_LOCATION=$3
        fi

	echo "Mounting: $SITE_DOMAIN on ENV: $SITE_ENV. $SITE_EXTRA"
	echo "From $SITE_REMOTE_LOCATION to $SITE_LOCAL_LOCATION"

	mkdir -p $SITE_LOCAL_LOCATION
	fusermount3 -u $SITE_LOCAL_LOCATION
	sshfs -C $SITE_ENV:$SITE_REMOTE_LOCATION $SITE_LOCAL_LOCATION
}

umount_site() {
	get_site_config $EMNT_DEFAULT_SITE_CONFIG $1
	SITE_LOCAL_LOCATION="$EMNT_DEFAULT_SITE_MOUNT_DIR/$(echo "$EMNT_DEFAULT_SITE_LOCAL_LOCATION_FORMAT" | envsubst)"
	fusermount -u $SITE_LOCAL_LOCATION
}

debug_site() {
    get_site_config $EMNT_DEFAULT_SITE_CONFIG $1
	ssh -R 9000:localhost:9000 "${SITE_ENV:-$1}" -v
}

