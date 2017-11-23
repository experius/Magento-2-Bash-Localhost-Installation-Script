# Magento 2 Bash Localhost Installation Script

Simply create Magento 2 Website on your localmachine!


Make a copy of the config.sample.sh file and update according to your localmachine.

 - [Main Functionalities](#markdown-header-main-functionalities)


## Main Functionalities

 - [Create Website] (#create-website)
 - [Add Module] (#markdown-header-add-module)
 - [Update Modules] (#markdown-header-update-modules)
 - [Code Quality Scan] (#markdown-header-code-quality-scan)

add functios to your .bashrc or .bash_aliases file

### Create Website

```
function create_website() {
    bash ~/tools/Magento-2-Bash-Localhost-Installation-Script/install.sh $1 $2 $3
}
```

#### Examples of Website Create/Install

use as followed:

```
create_website name type directory
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
function add_module() {
    bash ~/tools/Magento-2-Bash-Localhost-Installation-Script/add_module.sh $1 $2
}

```

usage (run in Magento 2 Root):

```
add_module Example https://github.com/example.git
```

### Update Modules

```
function update_modules() {
    bash ~/tools/Magento-2-Bash-Localhost-Installation-Script/update_modules.sh
}

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
function code_quality() {
    bash ~/tools/Magento-2-Bash-Localhost-Installation-Script/code_quality.sh $1 $2 $3
}
```

usage (run in Magento 2 Root):

```
codequality app/code/MyModule/Helloworld 7 
```

```
codequality app/code/MyModule/Helloworld 7 fix
```
