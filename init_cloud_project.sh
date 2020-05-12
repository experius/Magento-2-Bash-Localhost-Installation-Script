SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIGPATH=$SCRIPTPATH/config.sh
if [ -e $CONFIGPATH ]
then
    . $CONFIGPATH
else
    . $SCRIPTPATH/config.sample.sh
fi

if [ "$1" = "--help" ] || [ "$1" = "-h" ] ; then
  echo "The options available for this command:
        init_cloud_project 1 2
        1: project identifier
        2: The name of the website"
  exit 0
fi

PROJECT=$1
NAME=$2

if [ -z "$NAME" ]; then
	echo "enter name. Will be used as  $DOMAIN_PREFIX<yourname>$DOMAIN_SUFFIX"
	exit;
fi

$MC_COMMAND auth:info
$MC_COMMAND login --yes
$MC_COMMAND ssh-key:add --yes

# Bitbucket START
echo Fill in the bitbucket repository name like teamname/reponame
read BITBUCKET_REPO
if [ -z "$BITBUCKET_REPO" ]; then
  echo You forgot to fill in the bitbucket repository URL, please fill it in like teamname/reponame
  read BITBUCKET_REPO
  if [ -z "$BITBUCKET_REPO" ]; then
    echo Bitbucket Integration Skipped because no bitbucket repository URL was given
  fi
fi
echo Fill in the bitbucket oauth-consumer-key - https://devdocs.magento.com/guides/v2.3/cloud/integrations/bitbucket-integration.html#create-an-oauth-consumer
read BITBUCKET_KEY
if [ -z "$BITBUCKET_KEY" ]; then
  echo You forgot to fill in the bitbucket oauth-consumer-key, please fill it in
  read BITBUCKET_KEY
  if [ -z "$BITBUCKET_KEY" ]; then
    echo Bitbucket Integration Skipped because no bitbucket oauth-consumer-key was given
  fi
fi

echo Fill in the bitbucket oauth-consumer=secret-key - https://devdocs.magento.com/guides/v2.3/cloud/integrations/bitbucket-integration.html#create-an-oauth-consumer
read BITBUCKET_SECRET
if [ -z "$BITBUCKET_SECRET" ]; then
  echo You forgot to fill in the bitbucket oauth-consumer-secret, please fill it in
  read BITBUCKET_SECRET
  if [ -z "$BITBUCKET_SECRET" ]; then
    echo Bitbucket Integration Skipped because no bitbucket oauth-consumer-secret was given
  fi
fi

echo "Setting up bitbucket integration"
$MC_COMMAND project:curl -p $PROJECT \/integrations -i -X POST -d '{"type": "bitbucket","repository": "'$BITBUCKET_REPO'","app_credentials": {"key": "'$BITBUCKET_KEY'","secret": "'$BITBUCKET_SECRET'"},"prune_branches": false,"fetch_branches": true,"build_pull_requests": true,"resync_pull_requests": true}'
# Bitbucket END

. $SCRIPTPATH/init_cloud_env.sh "$PROJECT" "$NAME" "master"