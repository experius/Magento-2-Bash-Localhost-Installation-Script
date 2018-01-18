SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIGPATH=$SCRIPTPATH/config.sh
if [ -e $CONFIGPATH ]
then
    . $CONFIGPATH
else
    . $SCRIPTPATH/config.sample.sh
fi

NAME=$1
EDITION=$2
VERSION=$3
OPTIONS=$4

if [ -z "$NAME" ]; then
	echo "enter name. Will be used as  $DOMAIN_PREFIX<yourname>$DOMAIN_SUFFIX"
	exit;
fi

DOMAIN=$DOMAIN_PREFIX$NAME$DOMAIN_SUFFIX
DIRECTORY=$DOMAINS_PATH/$DOMAIN
MYSQL_DATABASE_NAME=$MYSQL_DATABASE_PREFIX$NAME

if [ -d "$DIRECTORY" ]; then
        echo "allready exists"
        exit;
fi 
	
## Create Database	
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE_NAME\`"

## Create Webshop Directory
mkdir $DIRECTORY

## Download Magento
if [ "$EDITION" = "enterprise" ]; then
  V="magento/project-enterprise-edition"
  if [ "$VERSION" ]; then
    V=$V"="$VERSION
  fi
	composer create-project --repository-url=https://repo.magento.com/ $V $DIRECTORY $OPTIONS
  composer require 'magento/module-gift-card-sample-data'
  composer require 'magento/module-customer-balance-sample-data'
  composer require 'magento/module-target-rule-sample-data'
  composer require 'magento/module-gift-registry-sample-data'
  composer require 'magento/module-multiple-wishlist-sample-data'
else
  V="magento/project-community-edition"
  if [ "$VERSION" ]; then
    V=$V"="$VERSION
  fi
	composer create-project --repository-url=https://repo.magento.com/ $V $DIRECTORY $OPTIONS
fi

## Install Sample Data 
mkdir $DIRECTORY/var/composer_home

## Copy Json Auth
if [ -e $COMPOSER_AUTH_JSON_FILE_PATH ]; then
        cp $COMPOSER_AUTH_JSON_FILE_PATH $DIRECTORY/var/composer_home/auth.json
fi

## Make Code Dir
mkdir $DIRECTORY/app/code
mkdir $DIRECTORY/app/code/$MAGENTO_MODULE_VENDOR

## Sample Data Deploy
php $DIRECTORY/bin/magento sampledata:deploy 

## Install Magento
php $DIRECTORY/bin/magento setup:install --admin-firstname="$MAGENTO_USERNAME" --admin-lastname="$MAGENTO_USERNAME" --admin-email="$MAGENTO_USER_EMAIL" --admin-user="$MAGENTO_USERNAME" --admin-password="$MAGENTO_PASSWORD" --base-url="http://$DOMAIN" --backend-frontname="$MAGENTO_ADMIN_URL" --db-host="localhost" --db-name="$MYSQL_DATABASE_NAME" --db-user="$MYSQL_USER" --db-password="$MYSQL_PASSWORD" --language=nl_NL --currency=EUR --timezone=Europe/Amsterdam --use-rewrites=1 --session-save=files --use-sample-data 	

php $DIRECTORY/bin/magento setup:upgrade

## Developer Settings
php $DIRECTORY/bin/magento deploy:mode:set developer
php $DIRECTORY/bin/magento cache:disable layout block_html collections full_page

mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'admin/security/session_lifetime', '31536000') ON DUPLICATE KEY UPDATE value='31536000';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'web/cookie/cookie_lifetime', '31536000') ON DUPLICATE KEY UPDATE value='31536000';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'dev/static/sign', '0') ON DUPLICATE KEY UPDATE value='0';"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'system/smtp/disable', '1') ON DUPLICATE KEY UPDATE value='1';"

