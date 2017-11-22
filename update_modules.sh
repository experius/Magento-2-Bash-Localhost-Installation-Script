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

MAGENTO_PATH=$PWD
echo "Update all app/code/$MAGENTO_MODULE_VENDOR modules"

cd $PWD/app/code/$MAGENTO_MODULE_VENDOR/
find . -maxdepth 1 -type d -exec sh -c '(echo "Updating {}" && cd {} && git pull)' ';'
cd $MAGENTO_PATH

php bin/magento setup:upgrade

php bin/magento cache:enable

php bin/magento cache:disable layout block_html collections full_page

