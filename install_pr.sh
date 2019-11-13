SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIGPATH=$SCRIPTPATH/config.sh
if [ -e $CONFIGPATH ]
then
    . $CONFIGPATH
else
    . $SCRIPTPATH/config.sample.sh
fi

NAME=$1
VERSION=$2
EDITION=$3
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

if [ -d "$DIRECTORY" ]; then
        echo "already exists"
        exit;
fi

## Create Database
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE_NAME\`"

## Create Webshop Directory
mkdir $DIRECTORY

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
  REMOTE="git@github.com:magento-partners/magento2ee.git"
  FORKED_REPO=$FORKED_REPO_EE
else
  REMOTE="git@github.com:magento/magento2.git"
fi
if [ "$VERSION" ]; then
    BRANCH="$VERSION""-develop"
fi

if [ -z "$BRANCH" ]; then
    git clone $REMOTE $DIRECTORY
else
    git clone -b $BRANCH $REMOTE $DIRECTORY
fi
git remote add fork $FORKED_REPO
$COMPOSER install -d $DIRECTORY
rm $DIRECTORY/var/.regenerate

## Install Sample Data
mkdir $DIRECTORY/var/composer_home

## Copy Json Auth
if [ -e $COMPOSER_AUTH_JSON_FILE_PATH ]; then
        cp $COMPOSER_AUTH_JSON_FILE_PATH $DIRECTORY/var/composer_home/auth.json
fi

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
$PHP $DIRECTORY/bin/magento dev:urn-catalog:generate .idea/misc.xml

. $SCRIPTPATH/src/update_settings.shi

. $SCRIPTPATH/src/secure_domain.sh

. $SCRIPTPATH/src/nfs.sh
