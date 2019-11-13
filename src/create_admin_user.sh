## Delete Current Admin User and Create New Admin User
$MAGERUN_COMMAND --root-dir=$DIRECTORY admin:user:delete $MAGENTO_USERNAME -f

if [ "$VERSION" = "m2" ]; then
	$MAGERUN_COMMAND --root-dir=$DIRECTORY admin:user:create --admin-user $MAGENTO_USERNAME --admin-password $MAGENTO_PASSWORD --admin-email $MAGENTO_USER_EMAIL --admin-firstname $MAGENTO_USERNAME --admin-lastname $MAGENTO_USERNAME
else
	$MAGERUN_COMMAND --root-dir=$DIRECTORY admin:user:create $MAGENTO_USERNAME $MAGENTO_USER_EMAIL $MAGENTO_PASSWORD $MAGENTO_USERNAME $MAGENTO_USERNAME
fi
