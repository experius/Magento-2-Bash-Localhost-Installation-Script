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
        init_cloud_env 1 2 3
        1: Project identifier
        2: The name of the website
        3: Branch to get project from (default is develop)"
  exit 0
fi

$MC_COMMAND auth:info
$MC_COMMAND login --force
$MC_COMMAND ssh-key:add --yes

PROJECT=$1
NAME=$2
BRANCH=$3

if [ -z "$NAME" ]; then
	echo "enter name. Will be used as  $DOMAIN_PREFIX<yourname>$DOMAIN_SUFFIX"
	exit;
fi

if [ -z "$BRANCH" ]; then
	BRANCH="develop"
fi

VALET_DOMAIN=$DOMAIN_PREFIX$NAME
DIRECTORY=$DOMAINS_PATH/$VALET_DOMAIN$FOLDER_SUFFIX
MYSQL_DATABASE_NAME=$MYSQL_DATABASE_PREFIX$NAME
MYSQL_DATABASE_NAME="${MYSQL_DATABASE_NAME//./_}"

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
$MC_COMMAND project:get $PROJECT $DIRECTORY -e $BRANCH
cd $DIRECTORY || exit
$COMPOSER install -d$DIRECTORY
$MC_COMMAND build --no-build-hooks

## Install Sample Data
mkdir $DIRECTORY/var/composer_home

## Copy Json Auth
if [ -e $COMPOSER_AUTH_JSON_FILE_PATH ]; then
    cp $COMPOSER_AUTH_JSON_FILE_PATH $DIRECTORY/var/composer_home/auth.json
fi

rm -rf $DIRECTORY/generated/*
rm -rf $DIRECTORY/var/cache/*

## Install Magento & Setup Database
$PHP $DIRECTORY/bin/magento setup:install --admin-firstname="$MAGENTO_USERNAME" --admin-lastname="$MAGENTO_USERNAME" --admin-email="$MAGENTO_USER_EMAIL" --admin-user="$MAGENTO_USERNAME" --admin-password="$MAGENTO_PASSWORD" --base-url="$URL" --backend-frontname="$MAGENTO_ADMIN_URL" --db-host="127.0.0.1" --db-name="$MYSQL_DATABASE_NAME" --db-user="$MYSQL_USER" --db-password="$MYSQL_PASSWORD" --language=nl_NL --currency=EUR --timezone=Europe/Amsterdam --use-rewrites=1 --session-save=files --cleanup-database --no-interaction
$PHP $DIRECTORY/bin/magento setup:upgrade

## Default remote name is magento
git remote rename magento origin

## Move data.sql & structure.sql to $DIRECTORY
cp $DOMAINS_PATH/structure.sql $DIRECTORY/structure.sql
cp $DOMAINS_PATH/data.sql $DIRECTORY/data.sql

. $SCRIPTPATH/update.sh "$NAME"