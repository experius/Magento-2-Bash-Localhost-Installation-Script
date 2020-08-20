## 2.4.0 (2020-08-20)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/2.4.0)

*  [FEATURE] Replace images with experius logo. Fixes broken images on local client dev envs *(dheesbeen)*
*  [BUGFIX] - Reverse if statement logic as Magento Cloud projects may not always have an env.php *(Cas Satter)*
*  [FEATURE] - Refactor init_cloud_env.sh and make it use the update_website command with data.sql + structure.sql in $DOMAINS_PATH folder, allowing users to easily setup a local Magento Cloud environment *(Cas Satter)*
*  [DOCS] - Expand README.md with cloud commands *(Cas Satter)*
*  [BUGFIX] Prevent incorrect base_url because of datetimestamp in core_config table *(Lewis Voncken)*
*  [FEATURE] Added support for production branch *(Lewis Voncken)*
*  [FEATURE] Exclude media on website import *(Lewis Voncken)*
*  [FEATURE] Speed up the install of a PR env *(Lewis Voncken)*


## 2.3.0 (2020-04-16)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/2.3.0)

*  [BUGFIX] Prevent removing all composer installed packages and just restart valet *(Mr. Lewis)*
*  [BUGFIX] Fixed composer installation command for mage2tv/magento-cache-clean module *(Basvanderlouw)*
*  [BUGFIX] - Prevent Bitbucket integration setup from deleting environments when branches are missing (i.e. production / staging / integration) *(Cas Satter)*
*  [FEATURE] - Renamed init_cloud command to indicate it's for setting up the project, also created command to setup a local environment of said project *(Cas Satter)*
*  [BUGFIX] - PHPStorm removed "" instead " :-( *(Cas Satter)*
*  [BUGFIX] - Restore ssh-keys add commando *(Cas Satter)*
*  [BUGFIX] - Add $ to MC_COMMAND *(Cas Satter)*
*  [TASK] Set index to on save for local development becasue on live its set to on schedule *(Lewis Voncken)*


## 2.2.4 (2019-12-09)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/2.2.4)

*  [BUGFIX] Solved missing colors *(Lewis Voncken)*


## 2.2.3 (2019-12-09)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/2.2.3)

*  [BUGFIX] changed type from /bin/sh to bin/bash *(Lewis Voncken)*


## 2.2.2 (2019-11-29)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/2.2.2)

*  [BUGFIX] Solved invalid push when branch is not on remote *(Lewis Voncken)*


## 2.2.1 (2019-11-29)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/2.2.1)

*  [BUGFIX] Solved problem with different remote and commit which is already pushed to the remote *(Lewis Voncken)*


## 2.2.0 (2019-11-13)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/2.2.0)

*  [FEATURE] Set default strip domain hypernode.io *(Lewis Voncken)*


## 2.1.0 (2019-11-13)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/2.1.0)

*  [TASK] - Add valet distinction for commands unavailable to valet-linux *(Lewis Voncken)*


## 2.0.0 (2019-11-13)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/2.0.0)

*  [REFACTOR] Use generic includes *(Lewis Voncken)*


## 1.4.0 (2019-11-13)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/1.4.0)

*  [FEATURE] Check if tag exists on remote then commit the CHANGELOG.md update in a separate commit *(Lewis Voncken)*


## 1.3.0 (2019-11-13)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/1.3.0)

*  [FEATURE] Optimized the CHANGELOG.md generator by adding additional checks and a prompt *(Lewis Voncken)*


## 1.2.1 (2019-11-12)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/1.2.1)

*  [BUGFIX] Added missing char ')' *(Lewis Voncken)*


## 1.2.0 (2019-11-12)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/1.2.0)

*  [FEATURE] Added check to only update the CHANGELOG.md for the master branch *(Lewis Voncken)*


## 1.1.0 (2019-11-11)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/1.1.0)

*  [FEATURE] Added githooks support to generate CHANGELOG.md automatically *(Lewis Voncken)*


## 1.0.0 (2019-11-11)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/1.0.0)

*  First commit *(Derrick Heesbeen)*
*  [BUGFIX] database name error fix *(Derrick Heesbeen)*
*  [BUGFIX] Config queries database name fix *(Derrick Heesbeen)*
*  [BUGFIX] load composer auth,json from config locaction *(Jeroen Coppelmans)*
*  [FEATURE] Automatically Create app/code/Vendor *(Lewis Voncken)*
*  [FEATURE] Disable `layout block_html collections full_page` - cache types to be ready for development *(Lewis Voncken)*
*  [TASK] Disable Sign Static Files and Disable Email Communication *(Lewis Voncken)*
*  [FEATURE] Compatible with create_website function *(Lewis Voncken)*
*  [TASK] Updated README.md *(Lewis Voncken)*
*  [TASK] Updated README.md *(Lewis Voncken)*
*  [FEATURE] Added two scripts for updating and installing modules *(Lewis Voncken)*
*  [TASK] added code quality scan *(Derrick Heesbeen)*
*  [TASK] updated config sample with github of code quality scan *(Derrick Heesbeen)*
*  Update README.md *(Mr. Lewis)*
*  Update README.md *(Mr. Lewis)*
*  Update README.md *(Mr. Lewis)*
*  Update README.md *(Mr. Lewis)*
*  Update README.md *(Mr. Lewis)*
*  [BUGFIX] variable fix for phpcbs *(Derrick Heesbeen)*
*  [TASK] Moved functions to .bash_xp and updated README with include of the file *(Lewis Voncken)*
*  [TASK] Check if code_quality is executed in the Magento 2 Root *(Lewis Voncken)*
*  [FEATURE] Added history arrow up and down bindings so you can prefix searching through history *(Lewis Voncken)*
*  [FEATURE] added extra cmd line option VERSION *(Jeroen Coppelmans)*
*  [FEATURE] Added Site Function with autofill *(Lewis Voncken)*
*  [TASK] updated readme for version parameter *(Jeroen Coppelmans)*
*  [BUGFIX] Solved problem with the site autofill *(Lewis Voncken)*
*  [BUGFIX] Solved problem with incorrect check if folder exists *(Lewis Voncken)*
*  [TASK] added some usefull git alliases to .bash_xp file *(Jeroen Coppelmans)*
*  [BUGFIX] fixes missing demo data packages enterprise *(Derrick Heesbeen)*
*  [FEATURE] Import Website from Backup *(Derrick Heesbeen)*
*  [TASK] added local.xml modifier for Magento 1 *(Derrick Heesbeen)*
*  [TASK] Import script create new admin user with magerun *(Derrick Heesbeen)*
*  [BUGFIX] Import script. Added trailing slash to base_url *(Derrick Heesbeen)*
*  [TASK] Added phpstorm shortcut *(Lewis Voncken)*
*  [TASK] Added comments to the .bash_xp file *(Lewis Voncken)*
*  [FEATURE] Added dev:urn-catalog:generate to the import.sh and install.sh *(Lewis Voncken)*
*  [TASK] Fixed magerun commands *(Derrick Heesbeen)*
*  [TASK] mkdir if not exists for .idea/misc.xml *(Lewis Voncken)*
*  [BUGFIX] Missing htaccess fix *(Derrick Heesbeen)*
*  [TASK] Exclude pub/media/catalog/product/* (and for m1 media/catalog/product/*) , var/log/*, var/report/* *(Lewis Voncken)*
*  [BUGFIX] Different Magerun create admin user for m1 *(Derrick Heesbeen)*
*  [BUGFIX] add Scriptpath in fornt of Helper/updateEnv.php to fix reference to this file if run import.sh outside of repo dir *(Jeroen Coppelmans)*
*  [FEATURE] Added xdebug cli support *(Lewis Voncken)*
*  [DOCS] Added Aliases to README.md *(Lewis Voncken)*
*  [TASK] Added Aliases to README.md and added git diff alias gd *(Lewis Voncken)*
*  [TASK] Added Aliases for Update Developer Programs Linux *(Lewis Voncken)*
*  [DOCS] Updated README.md *(Lewis Voncken)*
*  [DOCS] Updated README with site functionality *(Lewis Voncken)*
*  [DOCS] README.md update changed index *(Lewis Voncken)*
*  [FEATURE] Added create_pr_website to create a website based on the Github Repo for Pull Requests *(Lewis Voncken)*
*  [FEATURE] Added set forked repository remote in the install_pr.sh *(Lewis Voncken)*
*  [TASK] Added Installation Support for Magento 2.3 which requires php7.1 but Magento 2.1 requires php7.0 *(Lewis Voncken)*
*  [TASK] Added PHP alias for php7.0 which can now also be used as php7 *(Lewis Voncken)*
*  [TASK] Added php7.0 alias for CLI Xdebug command xphp7 and phpx7 *(Lewis Voncken)*
*  [TASK] Added Enterprise PR Environment Installation support *(Lewis Voncken)*
*  [TASK] Added additional php7 and php7.1 aliases and also for composer *(Lewis Voncken)*
*  [BUGFIX] Solved problem with the admin user already exists by deleting it for Magento 1 *(Lewis Voncken)*
*  [TASK] Added domain prefix/suffix and db prefix functionality *(Lewis Voncken)*
*  [TAKS] Added additional config updates to the import and installers *(Lewis Voncken)*
*  [TASK] removed double line *(Lewis Voncken)*
*  [TASK] Added force delete admin user *(Lewis Voncken)*
*  [FEATURE] Added update database script *(Lewis Voncken)*
*  [FEATURE] Added composer_lib_development command *(Lewis Voncken)*
*  [BUGFIX] Changed files.tar to files.tar.gz *(Lewis Voncken)*
*  [TASK] Also remove the files.tar.gz file *(Lewis Voncken)*
*  [TASK] Added connector_autoload.php support *(Lewis Voncken)*
*  [TASK] Added Query to disable CSS Minify when importing a website *(Lewis Voncken)*
*  [TASK] Enable Email Catcher and Disable SMTP Email *(Lewis Voncken)*
*  [FEATURE] custom prompt *(Lewis Voncken)*
*  [BUGFIX] Solved problem when the local.xml wasn't in the backup file *(Lewis Voncken)*
*  [BUGFIX] Solved problem with incorrect composer install in the install_pr.sh *(Lewis Voncken)*
*  [FEATURE] Valet Support for Jordan *(Lewis Voncken)*
*  [TASK] Install script, Complete path for phpstorm misc.xml file generation *(Derrick Heesbeen)*
*  [FEATURE] Added ssl support in combination with Valet Plus *(Lewis Voncken)*
*  [BUGFIX] corrected the url with correct scheme https *(Lewis Voncken)*
*  [BUGFIX] Solved incorrect if statements *(Lewis Voncken)*
*  [FEATURE] Added Custom Metapackage support *(Lewis Voncken)*
*  [TASK] Skip .idea so you start with a new idea project *(Mr. Lewis)*
*  [TASK] Added phpswitch method to bash commands for linux users *(Peter Keijsers)*
*  Added php version installer and Magento 2 php extension isntalled scripts *(Peter Keijsers)*
*  Readded config.sample.sh with special note for linux users *(Peter Keijsers)*
*  Added needed missing repository for php7.0 installation *(Peter Keijsers)*
*  [FEATURE] Added quick remote environment mounting tools. *(Egor Dmitriev)*
*  [DOCS] renamed Tools to tools *(Mr. Lewis)*
*  [TASK] Updated config.sample.sh with correct tools and domains folder *(Mr. Lewis)*
*  [BUGFIX] Solved invalid file path *(Lewis Voncken)*
*  [BUGFIX] Solved invalid valet secure domain *(Lewis Voncken)*
*  [TASK] Set correct database name with underscore *(Lewis Voncken)*
*  Added a Helper for the create_website command *(thokiller)*
*  [FEATURE] Added support to install a local enviroment from a repository *(René Schep)*
*  [BUGFIX] Fixed typo *(Hexmage)*
*  [BUGFIX] Fixed function name for git_import command *(René Schep)*
*  [TASK] Added support for Magento 1 *(René Schep)*
*  [TASK *(Mr. Lewis)*
*  [BUGFIX] Disable environment_tools.sh because it brakes because of an invalid path *(Lewis Voncken)*
*  [FEATURE] Added init_cloud support *(Lewis Voncken)*
*  [FEATURE] Added cache:enable and remove var/.regenerate file to prevent cache disabling *(Lewis Voncken)*
*  [BUGFIX] Use $PHP variable to run php commands *(Lewis Voncken)*
*  [FEATURE] Added NFS functions to speed up your localbox *(Lewis Voncken)*
*  [BUGFIX] Solved invalid if statement *(Lewis Voncken)*
*  [BUGFIX] Uncommented the rm data.sql, structure.sql and files.tar.gz *(Lewis Voncken)*
*  [BUGFIX] - Fix if cache = redis statement in bash scripts *(Cas Satter)*
*  [TASK] - Add xdebug as a config variable *(Cas Satter)*
*  Update composer_lib_development *(Mr. Lewis)*
*  [BUGFIX] magento install localhost bugfix, now uses ip *(Sam)*
*  [TASK] - Fix spelling error in composer_lib_development *(Cas Satter)*
*  [FEATURE] added symlink creation and added updates for the url in the database *(Thomas Mondeel)*
*  [TASK] - Fix some spelling errors *(Cas Satter)*
*  [BUGFIX] Solved invalid symlinks and domains and updated Valet Plus support *(Lewis Voncken)*


