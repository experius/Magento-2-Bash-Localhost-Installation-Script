# Magento 2 Bash Localhost Installation Script

Simply create Magento 2 Website on your localmachine!

 - [Getting Started](#getting-started)
 - [Main Functionalities](#main-functionalities)

## Getting Started

Clone this repository inside your home directory and name it:

```tools```

Make a copy of the config.sample.sh file, rename it to config.sh and update according to your localmachine.

### Different PHP Versions Support

**Deprecated: just use `valet use 7.2`**

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

##### Magento Cloud Example:

```
init_cloud_env project_id example develop
```

```
init_cloud_project project_id example
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


#### Update Developer Programs Linux
```
alias update_postman='sudo rm -rf /opt/Postman/; wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz; sudo tar -xzf postman.tar.gz -C /opt; rm postman.tar.gz'
```

### NFS

Please install mage2tv/magento-cache-clean globally with composer so you can enable all cache and just run cf -w
https://github.com/mage2tv/magento-cache-clean

```
alias cf="~/.composer/vendor/bin/cache-clean.js"
```
