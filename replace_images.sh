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

mkdir -p $DIRECTORY/pub/media/catalog/product/e/x
cp $SCRIPTPATH/Helper/Images/experius.png $DIRECTORY/pub/media/catalog/product/e/x/experius.png

mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "UPDATE catalog_product_entity_varchar SET value = '/e/x/experius.png' WHERE attribute_id IN (87,88,89)"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "UPDATE catalog_product_entity_media_gallery SET value = '/e/x/experius.png'"

$PHP $DIRECTORY/bin/magento cache:flush