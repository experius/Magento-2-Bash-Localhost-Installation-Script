#!/usr/bin/env bash

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

GITREPONAME=$2

if [ -z "$GITREPONAME" ]; then
        echo "enter git repository name. This will be used for cloning."
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

## Clone git repo and deploy it.
mv $DIRECTORY/structure.sql $DIRECTORY/../structure.sql
mv $DIRECTORY/data.sql $DIRECTORY/../data.sql
git clone git@bitbucket.org:$GIT_REPO_VENDOR/$GITREPONAME.git $DIRECTORY
mv $DIRECTORY/../structure.sql $DIRECTORY/structure.sql
mv $DIRECTORY/../data.sql $DIRECTORY/data.sql

## Check if we are installing Magento 1 or 2
if [ -f "$DIRECTORY/app/Mage.php" ]; then
        VERSION="m1"
        MAGERUN_COMMAND=$MAGERUN1_COMMAND
else
	VERSION="m2"
	MAGERUN_COMMAND=$MAGERUN2_COMMAND
fi

## Create and import DB
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE_NAME\`"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE_NAME < $DIRECTORY/structure.sql
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE_NAME < $DIRECTORY/data.sql

if [ "$VERSION" = "m2" ]; then
	## Create new env.php
	mkdir -p $DIRECTORY/app/etc
	cp $SCRIPTPATH/Helper/Placeholder/env.php $DIRECTORY/app/etc
	composer install -d$DIRECTORY
	rm $DIRECTORY/var/.regenerate
	php $SCRIPTPATH/Helper/updateEnv.php -f$DIRECTORY -d$MYSQL_DATABASE_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD
	$MAGERUN_COMMAND --root-dir=$DIRECTORY module:enable --all
else
	## Create new local.xml
	cp $SCRIPTPATH/Helper/Placeholder/local.xml $DIRECTORY/app/etc/local.xml
	php $SCRIPTPATH/Helper/updateLocal.php -f$DIRECTORY -d$MYSQL_DATABASE_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD
fi

## Set correct base urls
for CONFIG_PATH in 'web/unsecure/base_url' 'web/secure/base_url' 'web/unsecure/base_link_url' 'web/secure/base_link_url'
do
	mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "UPDATE \`core_config_data\` SET \`value\`='$URL/' WHERE \`path\`='$CONFIG_PATH'"
done

## Developer Settings
php $DIRECTORY/bin/magento deploy:mode:set developer
$PHP $DIRECTORY/bin/magento cache:enable
php $DIRECTORY/bin/magento cache:disable layout block_html collections full_page

### Generated PhpStorm XML Schema Validation
mkdir -p $DIRECTORY/.idea
php $DIRECTORY/bin/magento dev:urn-catalog:generate $DIRECTORY/.idea/misc.xml

mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'admin/security/session_lifetime', '31536000') ON DUPLICATE KEY UPDATE value='31536000';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'web/cookie/cookie_lifetime', '31536000') ON DUPLICATE KEY UPDATE value='31536000';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'dev/static/sign', '0') ON DUPLICATE KEY UPDATE value='0';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'dev/css/merge_css_files', '0') ON DUPLICATE KEY UPDATE value='0';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'dev/css/minify_files', '0') ON DUPLICATE KEY UPDATE value='0';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'dev/js/merge_files', '0') ON DUPLICATE KEY UPDATE value='0';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'dev/js/minify_files', '0') ON DUPLICATE KEY UPDATE value='0';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'dev/js/enable_js_bundling', '0') ON DUPLICATE KEY UPDATE value='0';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'system/smtp/disable', '1') ON DUPLICATE KEY UPDATE value='1';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'emailcatcher/general/enabled', '1') ON DUPLICATE KEY UPDATE value='1';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'emailcatcher/general/smtp_disable', '1') ON DUPLICATE KEY UPDATE value='1';"

## Remove the import files
rm $DIRECTORY/structure.sql
rm $DIRECTORY/data.sql

## Delete Current Admin User and Create New Admin User
$MAGERUN_COMMAND --root-dir=$DIRECTORY admin:user:delete $MAGENTO_USERNAME -f

if [ "$VERSION" = "m2" ]; then
	$MAGERUN_COMMAND --root-dir=$DIRECTORY admin:user:create --admin-user $MAGENTO_USERNAME --admin-password $MAGENTO_PASSWORD --admin-email $MAGENTO_USER_EMAIL --admin-firstname $MAGENTO_USERNAME --admin-lastname $MAGENTO_USERNAME
else
	$MAGERUN_COMMAND --root-dir=$DIRECTORY admin:user:create $MAGENTO_USERNAME $MAGENTO_USER_EMAIL $MAGENTO_PASSWORD $MAGENTO_USERNAME $MAGENTO_USERNAME
fi

if [ "$secure" = "true" ]; then
        valet secure $VALET_DOMAIN
fi
