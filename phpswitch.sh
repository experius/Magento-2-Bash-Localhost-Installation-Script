PHPVERSION=$1

# Function to install given php version
function installPhpVersion
{
	INSTALL_PHP_VERSION="php${PHPVERSION}-fpm"
	echo "Install php: ${INSTALL_PHP_VERSION}"
	sudo apt install $INSTALL_PHP_VERSION

	installMagento2PhpModules 
}

function installMagento2PhpModules
{
	echo "Install php modules: ..."
	MAGENTO2_PHP_EXTENSIONS=("bcmath" "mcrypt" "ctype" "curl" "dom" "gd" "hash" "iconv" "intl" "mbstring" "mysql" "simplexml" "soap" "xsl" "zip" "libxml")
	for EXTENSION in "${MAGENTO2_PHP_EXTENSIONS[@]}"
	do
		PHP_EXTENSION="php${PHPVERSION}-${EXTENSION}"
	    sudo apt install $PHP_EXTENSION
	done

	MAGENTO2_EXTENSIONS=("openssl" "libxml2")
	for EXTENSION in "${MAGENTO2_EXTENSIONS[@]}"
	do
	    sudo apt install $EXTENSION
	done
}
	
if [ -z "$PHPVERSION" ]; then
	echo "enter a php version number. for example: 7.2"
	exit;
fi

# Find out which php-fpm versions are installed en echo them
INSTALLED_PHP_VERSIONS=$(apt list --installed | grep --only-matching --perl-regexp "php7\.\\d+-fpm")
echo "php-fpm versions installed: "
for VERSION in "${INSTALLED_PHP_VERSIONS[@]}"
do
    echo "$VERSION"
done

# Check if php version the user likes to switch to is installed and ask to install it otherwise
MATCH_PHP_VALUE="php${PHPVERSION}-fpm"
if [[ ! " ${INSTALLED_PHP_VERSIONS[@]} " =~ ${MATCH_PHP_VALUE} ]]; then
    echo "${MATCH_PHP_VALUE} is not installed. Would you like to install ${MATCH_PHP_VALUE}?"
    read -p "Y/n: " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	    installPhpVersion
	fi
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

CURRENT_PHP_VERSION=$(php -v)
echo "Currently running on PHP: ${CURRENT_PHP_VERSION}"