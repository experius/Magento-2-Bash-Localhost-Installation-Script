<?php

$config = getopt('f:d:u:p:');

$envFilePath = $config['f'] . '/app/etc/env.php';

$envfileData = include $envFilePath;

if (file_exists($config['f'] . '/app/connector_autoload.php')) {
	include $config['f'] . '/app/connector_autoload.php';
}
include $config['f'] . '/vendor/autoload.php';

if(isset($envfileData['cache'])) {
	unset($envfileData['cache']);
}

$envfileData['session'] = ['save'=>'files'];
$envfileData['MAGE_MODE'] = 'developer';

foreach($envfileData['db']['connection'] as &$connection) {
	$connection['password'] = $config['p'];
	$connection['host'] = '127.0.0.1';
	$connection['dbname'] = $config['d'];
	$connection['username'] = $config['u'];
}

$phpFormatter = new  Magento\Framework\App\DeploymentConfig\Writer\PhpFormatter;

$newEnvFileData = $phpFormatter->format($envfileData);

file_put_contents($envFilePath, $newEnvFileData);
