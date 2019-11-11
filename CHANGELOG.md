## 1.1.0 (2019-11-11)

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/1.1.0)

*  [FEATURE] Added githooks support to generate CHANGELOG.md automatically


## 1.0.0 (2019-11-11

[View Release](git@github.com:experius/Magento-2-Bash-Localhost-Installation-Script.git/commits/tag/1.0.0)

*  First commit
*  [BUGFIX] database name error fix
*  [BUGFIX] Config queries database name fix
*  [BUGFIX] load composer auth,json from config locaction
*  [FEATURE] Automatically Create app/code/Vendor
*  [FEATURE] Disable `layout block_html collections full_page` - cache types to be ready for development
*  [TASK] Disable Sign Static Files and Disable Email Communication
*  [FEATURE] Compatible with create_website function
*  [TASK] Updated README.md
*  [TASK] Updated README.md
*  [FEATURE] Added two scripts for updating and installing modules
*  [TASK] added code quality scan
*  [TASK] updated config sample with github of code quality scan
*  Update README.md
*  Update README.md
*  Update README.md
*  Update README.md
*  Update README.md
*  [BUGFIX] variable fix for phpcbs
*  [TASK] Moved functions to .bash_xp and updated README with include of the file
*  [TASK] Check if code_quality is executed in the Magento 2 Root
*  [FEATURE] Added history arrow up and down bindings so you can prefix searching through history
*  [FEATURE] added extra cmd line option VERSION
*  [FEATURE] Added Site Function with autofill
*  [TASK] updated readme for version parameter
*  [BUGFIX] Solved problem with the site autofill
*  [BUGFIX] Solved problem with incorrect check if folder exists
*  [TASK] added some usefull git alliases to .bash_xp file
*  [BUGFIX] fixes missing demo data packages enterprise
*  [FEATURE] Import Website from Backup
*  [TASK] added local.xml modifier for Magento 1
*  [TASK] Import script create new admin user with magerun
*  [BUGFIX] Import script. Added trailing slash to base_url
*  [TASK] Added phpstorm shortcut
*  [TASK] Added comments to the .bash_xp file
*  [FEATURE] Added dev:urn-catalog:generate to the import.sh and install.sh
*  [TASK] Fixed magerun commands
*  [TASK] mkdir if not exists for .idea/misc.xml
*  [BUGFIX] Missing htaccess fix
*  [TASK] Exclude pub/media/catalog/product/* (and for m1 media/catalog/product/*) , var/log/*, var/report/*
*  [BUGFIX] Different Magerun create admin user for m1
*  [BUGFIX] add Scriptpath in fornt of Helper/updateEnv.php to fix reference to this file if run import.sh outside of repo dir
*  [FEATURE] Added xdebug cli support
*  [DOCS] Added Aliases to README.md
*  [TASK] Added Aliases to README.md and added git diff alias gd
*  [TASK] Added Aliases for Update Developer Programs Linux
*  [DOCS] Updated README.md
*  [DOCS] Updated README with site functionality
*  [DOCS] README.md update changed index
*  [FEATURE] Added create_pr_website to create a website based on the Github Repo for Pull Requests
*  [FEATURE] Added set forked repository remote in the install_pr.sh
*  [TASK] Added Installation Support for Magento 2.3 which requires php7.1 but Magento 2.1 requires php7.0
*  [TASK] Added PHP alias for php7.0 which can now also be used as php7
*  [TASK] Added php7.0 alias for CLI Xdebug command xphp7 and phpx7
*  [TASK] Added Enterprise PR Environment Installation support
*  [TASK] Added additional php7 and php7.1 aliases and also for composer
*  [BUGFIX] Solved problem with the admin user already exists by deleting it for Magento 1
*  [TASK] Added domain prefix/suffix and db prefix functionality
*  [TAKS] Added additional config updates to the import and installers
*  [TASK] removed double line
*  [TASK] Added force delete admin user
*  [FEATURE] Added update database script
*  [FEATURE] Added composer_lib_development command
*  [BUGFIX] Changed files.tar to files.tar.gz
*  [TASK] Also remove the files.tar.gz file
*  [TASK] Added connector_autoload.php support
*  [TASK] Added Query to disable CSS Minify when importing a website
*  [TASK] Enable Email Catcher and Disable SMTP Email
*  [FEATURE] custom prompt
*  [BUGFIX] Solved problem when the local.xml wasn't in the backup file
*  [BUGFIX] Solved problem with incorrect composer install in the install_pr.sh
*  [FEATURE] Valet Support for Jordan
*  [TASK] Install script, Complete path for phpstorm misc.xml file generation
*  [FEATURE] Added ssl support in combination with Valet Plus
*  [BUGFIX] corrected the url with correct scheme https
*  [BUGFIX] Solved incorrect if statements
*  [FEATURE] Added Custom Metapackage support
*  [TASK] Skip .idea so you start with a new idea project
*  [TASK] Added phpswitch method to bash commands for linux users
*  Added php version installer and Magento 2 php extension isntalled scripts
*  Readded config.sample.sh with special note for linux users
*  Added needed missing repository for php7.0 installation
*  [FEATURE] Added quick remote environment mounting tools.
*  [DOCS] renamed Tools to tools
*  [TASK] Updated config.sample.sh with correct tools and domains folder
*  [BUGFIX] Solved invalid file path
*  [BUGFIX] Solved invalid valet secure domain
*  [TASK] Set correct database name with underscore
*  Added a Helper for the create_website command
*  [FEATURE] Added support to install a local enviroment from a repository
*  [BUGFIX] Fixed typo
*  [BUGFIX] Fixed function name for git_import command
*  [TASK] Added support for Magento 1
*  [TASK
*  [BUGFIX] Disable environment_tools.sh because it brakes because of an invalid path
*  [FEATURE] Added init_cloud support
*  [FEATURE] Added cache:enable and remove var/.regenerate file to prevent cache disabling
*  [BUGFIX] Use $PHP variable to run php commands
*  [FEATURE] Added NFS functions to speed up your localbox
*  [BUGFIX] Solved invalid if statement
*  [BUGFIX] Uncommented the rm data.sql, structure.sql and files.tar.gz
*  [BUGFIX] - Fix if cache = redis statement in bash scripts
*  [TASK] - Add xdebug as a config variable
*  Update composer_lib_development
*  [BUGFIX] magento install localhost bugfix, now uses ip
*  [TASK] - Fix spelling error in composer_lib_development
*  [FEATURE] added symlink creation and added updates for the url in the database
*  [TASK] - Fix some spelling errors
*  [BUGFIX] Solved invalid symlinks and domains and updated Valet Plus support


