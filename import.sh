SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIGPATH=$SCRIPTPATH/config.sh
if [ -e $CONFIGPATH ]
then
    . $CONFIGPATH
else
    . $SCRIPTPATH/config.sample.sh
fi

DOMAIN=$1

DIRECTORY=$DOMAINS_PATH/$DOMAIN
MYSQL_DATABASE_NAME=$DOMAIN
URL="http://$DOMAIN"

if [ ! -d "$DIRECTORY" ]; then
        echo "Directory not found"
        exit;
fi

## Unpack the files
tar -xvf $DIRECTORY/files.tar --directory $DIRECTORY -k --exclude=pub/media/catalog/product/* --exclude=media/catalog/product/* --exclude=var/log/* --exclude=var/report/*

## Create and import DB
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE_NAME\`"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE_NAME < $DIRECTORY/structure.sql
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE_NAME < $DIRECTORY/data.sql

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
	php Helper/updateEnv.php -f $DIRECTORY -d $MYSQL_DATABASE_NAME -u $MYSQL_USER -p $MYSQL_PASSWORD
else
	## Create new local.xml
	php Helper/updateLocal.php -f $DIRECTORY -d $MYSQL_DATABASE_NAME -u $MYSQL_USER -p $MYSQL_PASSWORD
fi

## Set correct base urls
for CONFIG_PATH in 'web/unsecure/base_url' 'web/secure/base_url' 'web/unsecure/base_link_url' 'web/secure/base_link_url'
do
	mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "UPDATE \`core_config_data\` SET \`value\`='$URL/' WHERE \`path\`='$CONFIG_PATH'"
done

## Developer Settings
php $DIRECTORY/bin/magento deploy:mode:set developer
php $DIRECTORY/bin/magento cache:disable layout block_html collections full_page

### Generated PhpStorm XML Schema Validation
mkdir -p $DIRECTORY/.idea
php $DIRECTORY/bin/magento dev:urn-catalog:generate $DIRECTORY/.idea/misc.xml

mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'admin/security/session_lifetime', '31536000') ON DUPLICATE KEY UPDATE value='31536000';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'web/cookie/cookie_lifetime', '31536000') ON DUPLICATE KEY UPDATE value='31536000';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'dev/static/sign', '0') ON DUPLICATE KEY UPDATE value='0';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'system/smtp/disable', '1') ON DUPLICATE KEY UPDATE value='1';"

## Remove the import files
rm $DIRECTORY/files.tar
rm $DIRECTORY/structure.sql
rm $DIRECTORY/data.sql

## Delete Current Admin User and Create New Admin User
$MAGERUN_COMMAND --root-dir=$DIRECTORY admin:user:delete $MAGENTO_USERNAME
$MAGERUN_COMMAND --root-dir=$DIRECTORY admin:user:create --admin-user $MAGENTO_USERNAME --admin-password $MAGENTO_PASSWORD --admin-email $MAGENTO_USER_EMAIL --admin-firstname $MAGENTO_USERNAME --admin-lastname $MAGENTO_USERNAME
