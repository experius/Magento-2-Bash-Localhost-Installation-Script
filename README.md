# Magento 2 Bash Localhost Installation Script

Simply create Magento 2 Website on your localmachine!

 - [Getting Started](#getting-started)
 - [Main Functionalities](#main-functionalities)

## Getting Started

Make a copy of the config.sample.sh file and update according to your localmachine.

### Different PHP Versions Support

Magento 2.1 requires php7.0 but Magento 2.3 requires php7.1. To run both environments you have to create a switch in your NGINX but also in the installation.

Set the PHP7 and COMPOSER_PHP7 variables in the config.sh.

Additional information:

 - Install Different PHP Versions see for Example for Ubuntu:
        https://www.tecmint.com/install-different-php-versions-in-ubuntu/
 - Make a Switch in NGINX
    - Set the fastcgi_pass for Magento 2.1
      - fastcgi_pass   unix:/var/run/php/php7.0-fpm.sock;
    - Set the fastcgi_pass for Magento 2.3
      - fastcgi_pass   unix:/var/run/php/php7.1-fpm.sock;
 - **IMPORTANT: Magento 2.2 can fun on both php versions**

### Use the simplified aliases
Include .bash_xp in .bashrc or .bash_aliases, include example:

```
if [ -f ~/tools/Magento-2-Bash-Localhost-Installation-Script/.bash_xp ]; then
    . ~/tools/Magento-2-Bash-Localhost-Installation-Script/.bash_xp
fi
```


## Main Functionalities

 - [Create Website](#create-website)
 - [Add Module](#add-module)
 - [Update Modules](#update-modules)
 - [Code Quality Scan](#code-quality-scan)
 - [Site Search Command](#site-search-command)
 - [Composer Lib Development](#composer-lib-development)
 - [Aliases](#aliases)



### Create Website

```
$1 = name
$2 = type
$3 = version
$4 = options
```

```
create_website $1 $2 $3 $4
```

**Use create_pr_website to create the website based on the Github repository so you can easily make Pull Requests for Magento 2**

#### Examples of Website Create/Install

use as followed:

```
create_website name type version
```

##### Community Example:

```
create_website example
```


##### Enterprise Example:

```
create_website example enterprise
```

### Add Module

```
$1 = module_name (without Vendor)
$2 = repository_url
```

```
add_module $1 $2
```

usage (run in Magento 2 Root):

```
add_module Example https://github.com/example.git
```

### Update Modules

```
update_modules
```

usage (run in Magento 2 Root):

```
update_modules
```


### Code Quality Scan

```
$1 = path
$2 = severity
$3 = mode ('fix' will run phpcbf)
```

```
code_quality $1 $2 $3
```

usage (run in Magento 2 Root):

```
code_quality app/code/MyModule/Helloworld 7 
```

```
code_quality app/code/MyModule/Helloworld 7 fix
```

### Import Website from Backup
**This feature also supports import for a Magento 1 Webshop**

Requires the following files to be in the destination domain folder: files.tar, structure.sql, data.sql

```
import_website name
```

### Update Website from Backup
**This feature also supports update for a Magento 1 Webshop**

Requires the following files to be in the destination domain folder: structure.sql, data.sql

```
update_website name
```

### Site Search Command
When you have installed your websites in ~/domains you can search through them with the following command. This functionality also supports autofill.

```
site <domain>
```

### Composer Lib Development

If you want to use the composer_lib_development command to make symbolic links for vendor modules follow the following steps:

```
1. sudo ln -s ~/tools/Magento-2-Bash-Localhost-Installation-Script/composer_lib_development /usr/local/bin/composer_lib_development
2. sudo chmod +x /usr/local/bin/composer_lib_development

```

Now run the command from the Magento root:

```
composer_lib_development
```

*Additional Alias is `cld`


### Aliases
#### Magerun aliasses
```
alias m='magerun'
alias m2='magerun2'
```

#### PHP aliases
```
alias php7='php7.0'
alias composer7='php7 /usr/bin/composer'
alias php71='php7.1'
alias composer71='php71 /usr/bin/composer'
```

#### PhpStorm aliasses
```
alias p='phpstorm'
```

#### PHPX - Xdebug
```
alias phpx='XDEBUG_CONFIG="idekey=PHPSTORM" php  -dxdebug.remote_enable=on -f'
alias xphp='XDEBUG_CONFIG="idekey=PHPSTORM" php  -dxdebug.remote_enable=on -f'
alias phpx7='XDEBUG_CONFIG="idekey=PHPSTORM" php7.0  -dxdebug.remote_enable=on -f'
alias xphp7='XDEBUG_CONFIG="idekey=PHPSTORM" php7.0  -dxdebug.remote_enable=on -f'
```

#### Git aliasses
```
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gb='git branch'
alias gl='git log'
alias gco='git checkout'
alias gcom='git checkout master'
alias gam='git commit --amend --no-edit'
alias gp='git push'
alias gpom='git push origin master'
alias gm='git merge'
alias gd='git diff'
```

#### Composer Lib Development alias
```
alias cld='composer_lib_development'
```


#### Update Developer Programs Linux
```
alias update_postman='sudo rm -rf /opt/Postman/; wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz; sudo tar -xzf postman.tar.gz -C /opt; rm postman.tar.gz'
```

