PHPVERSION=$1
	
if [ -z "$PHPVERSION" ]; then
	echo "enter a php version number. for example: 7.2"
	exit;
fi

echo "stopping valet..."
valet stop

echo "update-alternatives of Linux to point 'php' alias to the new php version..."
echo "update-alternatives --set php /usr/bin/php$PHPVERSION"
sudo update-alternatives --set php /usr/bin/php$PHPVERSION

echo "Update composer config to the new php version and update all global packages to be compatible with this php version..."
composer global config platform.php $PHPVERSION
rm -rf ~/.composer/vendor/*
composer global update

echo "Remove valet socket configuration file..."
rm -f ~/.valet/valet.sock

echo "Reinstall valet using the new php settings..."
valet install