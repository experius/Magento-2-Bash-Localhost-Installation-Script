if [ "$nfs" = "true" ]; then
  echo "START - NFS"
  if [ "$cache" = "redis" ] &&  [ "$valet" = "plus" ]; then
    echo "configuring redis"
    valet redis on
    $PHP $DIRECTORY/bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=127.0.0.1 --cache-backend-redis-db=0
    $PHP $DIRECTORY/bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=127.0.0.1 --page-cache-redis-db=1
  fi
  echo "removing ui bookmarks to prevent page size of 100+ in Admin"
  mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "TRUNCATE ui_bookmark;"

  echo "disable admin action logs commerce/enterprise"
  mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'admin/magento_logging/actions', '0') ON DUPLICATE KEY UPDATE value='0';"

  echo "cleaning up the var/log folder"
  rm $DIRECTORY/var/log/*

  echo "set index to save/realtime because live has this on schedule"
  $PHP $DIRECTORY/bin/magento index:set-mode realtime

  echo "disable Experius_ApiLogger"
  mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'experius_api_logger/general/enabled_rest', '0') ON DUPLICATE KEY UPDATE value='0';"
  mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE_NAME -e "INSERT INTO \`core_config_data\` (\`scope\`, \`scope_id\`, \`path\`, \`value\`) VALUES ('default', 0, 'experius_api_logger/general/enabled_soap', '0') ON DUPLICATE KEY UPDATE value='0';"

  if [ "$xdebug" = "true" ]; then
    echo "disable remote_autostart xdebug"
    valet xdebug on --remote_autostart=0
  fi

  echo "IMPORTANT: please install mage2tv/magento-cache-clean global with composer so you are able to enable all caches"
  echo "END - NFS"
fi
