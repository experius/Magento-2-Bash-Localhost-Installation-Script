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

CURRENT_PATH="$(pwd -P)"
SCAN_FOLDER=$1
SEVERITY=$2
MODE=$3
FULL_PATH="$CURRENT_PATH/$SCAN_FOLDER"

if [ ! -d "$FULL_PATH" ]; then
        echo "Folder does not exists."
        exit;
fi

if [ "$MODE" = "fix" ]; then
	$PHPCBS_PATH $FULL_PATH --standard=MEQP2 --extensions=php,phtml --severity=$SEVERITY
else
	$PHPCS_PATH $FULL_PATH --standard=MEQP2 --extensions=php,phtml --severity=$SEVERITY
fi
