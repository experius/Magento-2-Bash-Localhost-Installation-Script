# Magento 2 Bash Localhost Installation Script

Simply create Magento 2 Website on your localmachine!


Make a copy of the config.sample.sh file and update according to your localmachine.

Include .bash_xp in .bashrc or .bash_aliases, include example:

```
if [ -f ~/tools/Magento-2-Bash-Localhost-Installation-Script/.bash_xp ]; then
    . ~/tools/Magento-2-Bash-Localhost-Installation-Script/.bash_xp
fi
```


 - [Main Functionalities](#main-functionalities)


## Main Functionalities

 - [Create Website](#create-website)
 - [Add Module](#add-module)
 - [Update Modules](#update-modules)
 - [Code Quality Scan](#code-quality-scan)
 - [Aliases] (#aliases)



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

Requires the following files to be in the destination domain folder: files.tar, structure.sql, data.sql

```
import_website magento.localhost.com
```


### Aliases
#### Magerun aliasses
alias m='magerun'
alias m2='magerun2'

#### PhpStorm aliasses
alias p='phpstorm'

#### PHPX - Xdebug
alias phpx='XDEBUG_CONFIG="idekey=PHPSTORM" php  -dxdebug.remote_enable=on -f'
alias xphp='XDEBUG_CONFIG="idekey=PHPSTORM" php  -dxdebug.remote_enable=on -f'

#### Git aliasses
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
