#!/bin/bash
#set -e
#set -x

# SETUP GOOFYS
###############################################################
mkdir -p ~/.aws

cat <<- EOF > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF

cat <<- EOF > ~/.aws/config
[profile default]
region = $AWS_DEFAULT_REGION
EOF

if [[ ! -z "$GOOFYS_ETC_MIME" ]]; then
  cat <<- EOF > /etc/mime.types
$GOOFYS_ETC_MIME
EOF
fi

if [[ -z "$GOOFYS_REGION" ]]; then
  GOOFYS_REGION="$AWS_DEFAULT_REGION"
fi

# goofys global option setting
[[ ! -z "$GOOFYS_DIR_MODE" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --dir-mode ${GOOFYS_DIR_MODE}"
[[ ! -z "$GOOFYS_FILE_MODE" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --file-mode ${GOOFYS_FILE_MODE}"
[[ ! -z "$GOOFYS_UID" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --uid ${GOOFYS_UID}"
[[ ! -z "$GOOFYS_GID" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --gid ${GOOFYS_GID}"
[[ ! -z "$GOOFYS_ENDPOINT" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --endpoint ${GOOFYS_ENDPOINT}"
[[ ! -z "$GOOFYS_REGION" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --region ${GOOFYS_REGION}"
[[ ! -z "$GOOFYS_STORAGE_CLASS" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --storage-class ${GOOFYS_STORAGE_CLASS}"
[[ ! -z "$GOOFYS_USE_CONTENT_TYPE" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --use-content-type ${GOOFYS_USE_CONTENT_TYPE}"
[[ ! -z "$GOOFYS_STAT_CACHE_TTL" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --stat-cache-ttl ${GOOFYS_STAT_CACHE_TTL}"
[[ ! -z "$GOOFYS_TYPE_CACHE_TTL" ]] && GOOFYS_GLOBAL_OPTION="${GOOFYS_GLOBAL_OPTION} --type-cache-ttl ${GOOFYS_TYPE_CACHE_TTL}"

# START
######################################################

rpcbind
rpc.statd -L
rpc.idmapd
dbus-uuidgen --ensure
dbus-daemon --system --fork

case $STORAGE in

  goofys)
    exec /usr/bin/supervisord -n -c /etc/goofys.conf  
    ;;

  objectivefs)
    exec /usr/bin/supervisord -n -c /etc/objectivefs.conf  
    ;;

  *)
    echo -n "Invalid storage option $STORAGE. Starting local NFS server";
    exec /usr/bin/supervisord -n -c /etc/local.conf
    ;;
esac