SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIGPATH=$SCRIPTPATH/config.sh
if [ -e $CONFIGPATH ]
then
    . $CONFIGPATH
else
    . $SCRIPTPATH/config.sample.sh
fi

NAME=$1

if [ -z "$NAME" ]; then
        echo "enter name. Will be used as  $DOMAIN_PREFIX<yourname>$DOMAIN_SUFFIX"
        exit;
fi

VALET_DOMAIN=$DOMAIN_PREFIX$NAME
DIRECTORY=$DOMAINS_PATH/$VALET_DOMAIN$FOLDER_SUFFIX
DOMAIN=$VALET_DOMAIN$DOMAIN_SUFFIX
MYSQL_DATABASE_NAME=$MYSQL_DATABASE_PREFIX$NAME
MYSQL_DATABASE_NAME="${MYSQL_DATABASE_NAME//./_}"

URL="http://$DOMAIN"
if [ "$secure" = "true" ]; then
        URL="https://$DOMAIN"
fi
if [ ! -d "$DIRECTORY" ]; then
        echo "Directory not found"
        exit;
fi

## Create and import DB
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "DROP DATABASE \`$MYSQL_DATABASE_NAME\`"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE_NAME\`"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE_NAME < $DIRECTORY/structure.sql
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -f $MYSQL_DATABASE_NAME < $DIRECTORY/data.sql

## Check if we are installing Magento 1 or 2
if [ -f "$DIRECTORY/app/etc/env.php" ]; then
        VERSION="m2"
        MAGERUN_COMMAND=$MAGERUN2_COMMAND
else
	VERSION="m1"
	MAGERUN_COMMAND=$MAGERUN1_COMMAND
fi

if [ "$VERSION" = "m2" ]; then
	## Create new env.php
	php $SCRIPTPATH/Helper/updateEnv.php -f $DIRECTORY -d $MYSQL_DATABASE_NAME -u $MYSQL_USER -p $MYSQL_PASSWORD
else
	## Create new local.xml
	php $SCRIPTPATH/Helper/updateLocal.php -f $DIRECTORY -d $MYSQL_DATABASE_NAME -u $MYSQL_USER -p $MYSQL_PASSWORD
fi

## Set correct base urls
for CONFIG_PATH in 'web/unsecure/base_url' 'web/secure/base_url' 'web/unsecure/base_link_url' 'web/secure/base_link_url'
do
	mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "UPDATE \`core_config_data\` SET \`value\`='$URL/' WHERE \`path\`='$CONFIG_PATH'"
done

### Generated PhpStorm XML Schema Validation
mkdir -p $DIRECTORY/.idea
php $DIRECTORY/bin/magento dev:urn-catalog:generate $DIRECTORY/.idea/misc.xml

. $SCRIPTPATH/src/update_settings.sh

## Remove the import files
rm $DIRECTORY/structure.sql
rm $DIRECTORY/data.sql

. $SCRIPTPATH/src/create_admin_user.sh

. $SCRIPTPATH/src/secure_domain.sh

. $SCRIPTPATH/src/nfs.sh
