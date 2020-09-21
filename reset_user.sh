SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIGPATH=$SCRIPTPATH/config.sh
if [ -e $CONFIGPATH ]
then
    . $CONFIGPATH
else
#error
    . $SCRIPTPATH/config.sample.sh
fi

if [ "$1" = "--help" ] || [ "$1" = "-h" ] ; then
  echo "The reset_admin_user_login allows the reset of the admin password for a domain.
	Usage: reset_admin_user_login DOMAIN_TO_RESET_ADMIN"
  exit 0
fi


NAME=$1

if [ -z "$NAME" ]; then
        echo "Please enter a Domain where the admin user should be resetted"
        exit;
fi

VALET_DOMAIN=$DOMAIN_PREFIX$NAME
DIRECTORY=$DOMAINS_PATH/$VALET_DOMAIN$FOLDER_SUFFIX
DOMAIN=$VALET_DOMAIN$DOMAIN_SUFFIX
MYSQL_DATABASE_NAME=$MYSQL_DATABASE_PREFIX$NAME
MYSQL_DATABASE_NAME="${MYSQL_DATABASE_NAME//./_}"

## Check if we are installing Magento 1 or 2
if [ -f "$DIRECTORY/app/etc/env.php" ]; then
        VERSION="m2"
        MAGERUN_COMMAND=$MAGERUN2_COMMAND
else
                VERSION="m1"
                MAGERUN_COMMAND=$MAGERUN1_COMMAND        
fi 

#error
$MAGERUN_COMMAND --root-dir=$DIRECTORY admin:user:delete $MAGENTO_USERNAME -f

if [ "$VERSION" = "m2" ]; then
        $MAGERUN_COMMAND --root-dir=$DIRECTORY admin:user:create --admin-user $MAGENTO_USERNAME --admin-password $MAGENTO_PASSWORD --admin-email $MAGENTO_USER_EMAIL --admin-firstname $MAGENTO_USERNAME --a$
else
#error
        $MAGERUN_COMMAND --root-dir=$DIRECTORY admin:user:create $MAGENTO_USERNAME $MAGENTO_USER_EMAIL $MAGENTO_PASSWORD $MAGENTO_USERNAME $MAGENTO_USERNAME
fi
