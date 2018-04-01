<?php

$config = getopt('f:d:u:p:');

$envFilePath = $config['f'] . '/app/etc/local.xml';

$localXml = new SimpleXMLElement(file_get_contents($envFilePath));


$localXml->global->resources->default_setup->connection->host = '<![CDATA[' . '127.0.0.1' . ']]>';
$localXml->global->resources->default_setup->connection->dbname = '<![CDATA[' . $config['d'] . ']]>';
$localXml->global->resources->default_setup->connection->username = '<![CDATA[' . $config['u'] . ']]>';
$localXml->global->resources->default_setup->connection->password = '<![CDATA[' . $config['p'] . ']]>';

file_put_contents(
    $config['f'] . "/app/etc/local.xml",
    html_entity_decode($localXml->asXML(), ENT_NOQUOTES, 'UTF-8')
);



?>