<?php

$config = getopt('f:d:u:p:');

$envFilePath = $config['f'] . '/app/etc/local.xml';

$dom = new DOMDocument();
$dom->load($envFilePath);

$dom->save($config['f'] . "/app/local-test.xml");

?>