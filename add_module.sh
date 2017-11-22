if [ ! -f app/etc/env.php ]; then
    echo "This is command has to be executed from the root of your Magento 2 Installation"
    exit;
fi

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIGPATH=$SCRIPTPATH/config.sh
if [ -e $CONFIGPATH ]
then
    . $CONFIGPATH
else
    . $SCRIPTPATH/config.sample.sh
fi

NAME=$1
REPO=$2
OPTIONS=$3

MODULE_NAME="$MAGENTO_MODULE_VENDOR""_""$NAME"

if [ -z "$NAME" ]; then
        echo "Enter module name excluding vendor name. Will be used to install module in app/code/$MAGENTO_MODULE_VENDOR/<name>"
        exit;
fi

if [ -z "$REPO" ]; then
        echo "Enter a Git Repository URL to clone the module from"
        exit;
fi

MODULE_PATH=app/code/$MAGENTO_MODULE_VENDOR/$NAME

if [ -d "MODULEPATH" ]; then
        echo "Module Folder already exists. Try to update module."
        exit;
fi

echo "Cloning Module from Repository"
git clone $2 $MODULE_PATH

MODULE_NAME="$MAGENTO_MODULE_VENDOR""_""$NAME"
php bin/magento module:enable $MODULE_NAME

php bin/magento setup:upgrade

php bin/magento cache:enable

php bin/magento cache:disable layout block_html collections full_page
