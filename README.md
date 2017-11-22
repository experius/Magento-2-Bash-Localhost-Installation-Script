# Magento 2 Bash Localhost Installation Script

Simply create Magento 2 Website on your localmachine!


Make a copy of the config.sample.sh file and update according to your localmachine.


add function function to your .bashrc or .bash_aliases file

```
function create_website() {
    bash ~/tools/Magento-2-Bash-Localhost-Installation-Script/install.sh $1 $2 $3
}
```

use as followed:

```
create_website name type directory
```

Community Example:

```
create_website example
```


Enterprise Example:

```
create_website example enterprise
```
