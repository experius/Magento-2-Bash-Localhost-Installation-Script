SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIGPATH=$SCRIPTPATH/config.sh
if [ -e $CONFIGPATH ]
then
    . $CONFIGPATH
else
    . $SCRIPTPATH/config.sample.sh
fi

if [ "$1" = "--help" ] || [ "$1" = "-h" ] ; then
  echo "The options available for this command:
        create_website 1 2 3 4
        1: The name of the website
        2: Type: community or enterprise
        3: Version: Set the magento version being installed. Example 2.2.8
        4: options: add options to the composer create project commando"
  exit 0
fi


NAME=$1
EDITION=$2
VERSION=$3
OPTIONS=$4

if [ -z "$NAME" ]; then
	echo "enter name. Will be used as  $DOMAIN_PREFIX<yourname>$DOMAIN_SUFFIX"
	exit;
fi

VALET_DOMAIN=$DOMAIN_PREFIX$NAME
DIRECTORY=$DOMAINS_PATH/$VALET_DOMAIN$FOLDER_SUFFIX
DOMAIN=$VALET_DOMAIN$DOMAIN_SUFFIX
MYSQL_DATABASE_NAME=$MYSQL_DATABASE_PREFIX$NAME
MYSQL_DATABASE_NAME="${MYSQL_DATABASE_NAME//./_}"
if [[ $EDITION != "custom-"* ]]; then
    if [ -d "$DIRECTORY" ]; then
        echo "allready exists"
        exit;
    fi
    ## Create Webshop Directory
    mkdir $DIRECTORY
fi
## Create Database
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE_NAME\`"

COMPOSER="composer"
PHP="php"
if [ "$VERSION" ]; then
    if [[ $VERSION = "2.1."* ]]; then
        if [ "$PHP7" ]; then
            PHP=$PHP7
        fi
        if [ "$COMPOSER_PHP7" ]; then
            COMPOSER=$COMPOSER_PHP7
        fi
    fi
fi

## Download Magento
if [ "$EDITION" = "enterprise" ]; then
  V="magento/project-enterprise-edition"
  if [ "$VERSION" ]; then
    V=$V"="$VERSION
  fi
	$COMPOSER create-project --repository-url=https://repo.magento.com/ $V $DIRECTORY $OPTIONS
  $COMPOSER require 'magento/module-gift-card-sample-data'
  $COMPOSER require 'magento/module-customer-balance-sample-data'
  $COMPOSER require 'magento/module-target-rule-sample-data'
  $COMPOSER require 'magento/module-gift-registry-sample-data'
  $COMPOSER require 'magento/module-multiple-wishlist-sample-data'
elif [ "$EDITION" = "custom-enterprise" ]; then
  V=$CUSTOM_EE
  $COMPOSER config repositories.magento composer https://repo.magento.com/ --global
  $COMPOSER config repositories.custom-enterprise composer $CUSTOM_REPO --global
  $COMPOSER create-project $V $DIRECTORY $OPTIONS
elif [ "$EDITION" = "custom-community" ]; then
  V=$CUSTOM_CE
  $COMPOSER config repositories.magento composer https://repo.magento.com/ --global
  $COMPOSER config repositories.custom-community composer $CUSTOM_REPO --global
  $COMPOSER create-project $V $DIRECTORY $OPTIONS
else
  V="magento/project-community-edition"
  if [ "$VERSION" ]; then
    V=$V"="$VERSION
  fi
	$COMPOSER create-project --repository-url=https://repo.magento.com/ $V $DIRECTORY $OPTIONS
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
$PHP $DIRECTORY/bin/magento sampledata:deploy

## Install Magento
URL="http://$DOMAIN"
if [ "$secure" = "true" ]; then
	URL="https://$DOMAIN"
fi
$PHP $DIRECTORY/bin/magento setup:install --admin-firstname="$MAGENTO_USERNAME" --admin-lastname="$MAGENTO_USERNAME" --admin-email="$MAGENTO_USER_EMAIL" --admin-user="$MAGENTO_USERNAME" --admin-password="$MAGENTO_PASSWORD" --base-url="$URL" --backend-frontname="$MAGENTO_ADMIN_URL" --db-host="127.0.0.1" --db-name="$MYSQL_DATABASE_NAME" --db-user="$MYSQL_USER" --db-password="$MYSQL_PASSWORD" --language=nl_NL --currency=EUR --timezone=Europe/Amsterdam --use-rewrites=1 --session-save=files --use-sample-data

$PHP $DIRECTORY/bin/magento setup:upgrade

## Developer Settings
$PHP $DIRECTORY/bin/magento deploy:mode:set developer
$PHP $DIRECTORY/bin/magento cache:enable
$PHP $DIRECTORY/bin/magento cache:disable layout block_html collections full_page
### Generated PhpStorm XML Schema Validation
mkdir -p $DIRECTORY/.idea
$PHP $DIRECTORY/bin/magento dev:urn-catalog:generate $DIRECTORY/.idea/misc.xml

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

  echo "disable remote_autostart xdebug"
  valet xdebug on --remote_autostart=0
  echo "END - NFS"
fi
