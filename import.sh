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
tar -xvf $DIRECTORY/files.tar.gz --directory $DIRECTORY -k --exclude=.idea --exclude=pub/media/catalog/product/* --exclude=media/catalog/product/* --exclude=var/log/* --exclude=var/report/* --exclude=pub/media/* --exclude=media/*

## Create and import DB
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE_NAME\`"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE_NAME < $DIRECTORY/structure.sql
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE_NAME < $DIRECTORY/data.sql

## Check if we are installing Magento 1 or 2
if [ -f "$DIRECTORY/app/etc/local.xml" ]; then
        VERSION="m1"
        MAGERUN_COMMAND=$MAGERUN1_COMMAND
else
		VERSION="m2"
		MAGERUN_COMMAND=$MAGERUN2_COMMAND
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
mysql -N -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "SELECT \`config_id\`,\`scope\`,\`scope_id\`,\`path\`,\`value\` FROM \`core_config_data\` where \`path\` IN ('web/unsecure/base_url','web/secure/base_url','web/unsecure/base_link_url','web/secure/base_link_url')" | while read config_id scope scope_id path value;
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

## Dump composer autoload without optimize setting
cd $DIRECTORY; composer dump-autoload

## Developer Settings
php $DIRECTORY/bin/magento deploy:mode:set developer
$PHP $DIRECTORY/bin/magento cache:enable
php $DIRECTORY/bin/magento cache:disable layout block_html collections full_page

### Generated PhpStorm XML Schema Validation
mkdir -p $DIRECTORY/.idea
php $DIRECTORY/bin/magento dev:urn-catalog:generate $DIRECTORY/.idea/misc.xml

. $SCRIPTPATH/src/update_settings.sh

## Remove the import files
rm $DIRECTORY/files.tar.gz
rm $DIRECTORY/structure.sql
rm $DIRECTORY/data.sql

. $SCRIPTPATH/src/create_admin_user.sh

. $SCRIPTPATH/src/secure_domain.sh

. $SCRIPTPATH/src/nfs.sh
