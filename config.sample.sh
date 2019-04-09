MYSQL_PASSWORD="s@ndb0x!"
MYSQL_USER="root"
MYSQL_DATABASE_PREFIX="magento2."

MAGENTO_USERNAME="sandbox"
MAGENTO_PASSWORD="s@ndb0x!"
MAGENTO_USER_EMAIL="sandbox@example.com"
MAGENTO_ADMIN_URL="admin"
MAGENTO_MODULE_VENDOR="Vendor"

# No double quotes arount the path value for linux users
DOMAINS_PATH=~/domains

## When Using Valet
#DOMAIN_PREFIX="m2."
#DOMAIN_SUFFIX=".test"
#FOLDER_SUFFIX=""

## When Using Custom (folder contains suffix)
DOMAIN_PREFIX="magento2."
DOMAIN_SUFFIX=".local.example.com"
FOLDER_SUFFIX=".local.example.com"

COMPOSER_AUTH_JSON_FILE_PATH="auth.json"

##https://github.com/magento/marketplace-eqp
PHPCS_PATH="~/tools/magento-coding-standard/vendor/bin/phpcs"
PHPCBF_PATH="~/tools/magento-coding-standard/vendor/bin/phpcbf"

MAGERUN2_COMMAND="n98-magerun2"
MAGERUN1_COMMAND="n98-magerun"

FORKED_REPO="git@github.com:<username>/magento2.git"
FORKED_REPO_EE="undefined"
PHP7="php7.0"
COMPOSER_PHP7="$PHP7 /usr/bin/composer"

secure="false"

CUSTOM_EE="example/magento-project-enterprise-edition"
CUSTOM_CE="example/magento-project-community-edition"
CUSTOM_REPO="https://repo.example.com"
