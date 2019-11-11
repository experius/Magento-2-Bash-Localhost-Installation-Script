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
if [ ! -d "$DIRECTORY" ]; then
        echo "Directory not found"
        exit;
fi

## Unpack the files
tar -xvf $DIRECTORY/files.tar.gz --directory $DIRECTORY -k --exclude=.idea --exclude=pub/media/catalog/product/* --exclude=media/catalog/product/* --exclude=var/log/* --exclude=var/report/*

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
	php $SCRIPTPATH/Helper/updateEnv.php -f $DIRECTORY -d $MYSQL_DATABASE_NAME -u $MYSQL_USER -p $MYSQL_PASSWORD
else
	## Create new local.xml
	if [ ! -d "$DIRECTORY"/app/etc/local.xml ]; then
		touch $DIRECTORY/app/etc/local.xml
	fi
	php $SCRIPTPATH/Helper/updateLocal.php -f $DIRECTORY -d $MYSQL_DATABASE_NAME -u $MYSQL_USER -p $MYSQL_PASSWORD
fi

## Set correct base urls
echo "starting with making urls and adding the symbolic links"
URL="http://"
if [ "$secure" = "true" ]; then
        URL="https://"
fi
mysql -N -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "SELECT * FROM \`core_config_data\` where \`path\` IN ('web/unsecure/base_url','web/secure/base_url','web/unsecure/base_link_url','web/secure/base_link_url')" | while read config_id scope scope_id path value;
do
	STRIPT=${value#*//}
	STRIPT="${STRIPT/www\./}"
	STRIPT="${STRIPT/\/$/}"
	for SUFFIX in "${STRIPURLS[@]}"; do
		STRIPT=${STRIPT%.$SUFFIX*};
	done

  if [ "$VALET_LINK" = "true" ]; then
    cd $DIRECTORY
    if [ "$secure" = "true" ]; then
      valet link $STRIPT --secure
    else
      valet link $STRIPT
    fi
  else
	  ln -s $DIRECTORY $DOMAINS_PATH/$STRIPT
  fi
	mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "UPDATE \`core_config_data\` SET \`value\` ='$URL$STRIPT$DOMAIN_SUFFIX/' WHERE config_id = $config_id"
	echo "updated url for $STRIPT"
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
rm $DIRECTORY/files.tar.gz
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

if [ "$nfs" = "true" ]; then
  echo "START - NFS"
  if [ "$cache" = "redis" ]; then
    echo "configuring redis"
    valet redis on
    $PHP $DIRECTORY/bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=127.0.0.1 --cache-backend-redis-db=0
    $PHP $DIRECTORY/bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=127.0.0.1 --page-cache-redis-db=1
  fi
  echo "installing mage2tv/magento-cache-clean (can be used as cf --watch - see https://github.com/mage2tv/magento-cache-clean for more information)"
  $COMPOSER require --dev mage2tv/cache-clean --working-dir=$DIRECTORY

  echo "enabling all caches because mage2tv/magento-cache-clean is now available"
  $PHP $DIRECTORY/bin/magento cache:enable

  echo "removing ui bookmarks to prevent page size of 100+ in Admin"
  mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "TRUNCATE ui_bookmark;"

  echo "disable admin action logs commerce/enterprise"
  mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'admin/magento_logging/actions', '0') ON DUPLICATE KEY UPDATE value='0';"

  echo "cleaning up the var/log folder"
  rm $DIRECTORY/var/log/*

  echo "set index to schedule"
  $PHP $DIRECTORY/bin/magento index:set-mode schedule

  echo "disable Experius_ApiLogger"
  mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'experius_api_logger/general/enabled_rest', '0') ON DUPLICATE KEY UPDATE value='0';"
  mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'experius_api_logger/general/enabled_soap', '0') ON DUPLICATE KEY UPDATE value='0';"

  if [ "$xdebug" = "true" ]; then
    echo "disable remote_autostart xdebug"
    valet xdebug on --remote_autostart=0
  fi
  echo "END - NFS"
fi
