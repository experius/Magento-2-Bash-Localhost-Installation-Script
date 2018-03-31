SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIGPATH=$SCRIPTPATH/config.sh
if [ -e $CONFIGPATH ]
then
    . $CONFIGPATH
else
    . $SCRIPTPATH/config.sample.sh
fi

NAME=$1
DATABASE_NAME=$2

if [ -z "$NAME" ]; then
	echo "enter the name of the website that will be uninstalled. Example $DOMAIN_PREFIX<yourname>$DOMAIN_SUFFIX"
	exit;
fi

DOMAIN=$DOMAIN_PREFIX$NAME$DOMAIN_SUFFIX
DIRECTORY=$DOMAINS_PATH/$DOMAIN
MYSQL_DATABASE_NAME=$MYSQL_DATABASE_PREFIX$NAME

if [ ! -d "$DIRECTORY" ]; then
        echo "Website folder not found"
        exit;
fi 

## Create Database	
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "DROP DATABASE \`$MYSQL_DATABASE_NAME\`"

## Remove folder
rm -rf $DIRECTORY