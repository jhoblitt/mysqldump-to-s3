#!/bin/bash

set -e
set -o pipefail

fail() {
  # shellcheck disable=SC2068
  echo -e $@
  exit 1
}

declare -A req_vars
req_vars=(
  [AWS_ACCESS_KEY_ID]='You need to set the AWS_ACCESS_KEY_ID environment variable.'
  [AWS_SECRET_ACCESS_KEY]='You need to set the AWS_SECRET_ACCESS_KEY environment variable.'
  [AWS_BUCKET]='You need to set the AWS_BUCKET environment variable.'
  [PREFIX]='You need to set the PREFIX environment variable.'
  [MYSQL_ENV_MYSQL_USER]='You need to set the MYSQL_ENV_MYSQL_USER environment variable.'
  [MYSQL_ENV_MYSQL_PASSWORD]='You need to set the MYSQL_ENV_MYSQL_PASSWORD environment variable.'
  [MYSQL_PORT_3306_TCP_ADDR]='You need to set the MYSQL_PORT_3306_TCP_ADDR environment variable or link to a container named MYSQL.'
  [MYSQL_PORT_3306_TCP_PORT]='You need to set the MYSQL_PORT_3306_TCP_PORT environment variable or link to a container named MYSQL.'
)

for k in "${!req_vars[@]}"; do
  eval "[[ -z \"\$$k\" ]]" && fail "${req_vars[$k]}"
done

MYSQLDUMP_OPTIONS=${MYSQLDUMP_OPTIONS:-"--quote-names --quick --add-drop-table --add-locks --allow-keywords --disable-keys --extended-insert --single-transaction --create-options --comments --net_buffer_length=16384"}
MYSQLDUMP_DATABASE=${MYSQLDUMP_DATABASE:-"--all-databases"}


MYSQL_HOST_OPTS="-h $MYSQL_PORT_3306_TCP_ADDR --port $MYSQL_PORT_3306_TCP_PORT -u $MYSQL_ENV_MYSQL_USER -p$MYSQL_ENV_MYSQL_PASSWORD"

echo "Starting dump of ${MYSQLDUMP_DATABASE} database(s) from ${MYSQL_PORT_3306_TCP_ADDR}..."

mysqldump $MYSQL_HOST_OPTS $MYSQLDUMP_OPTIONS $MYSQLDUMP_DATABASE | gzip | aws s3 cp - s3://$AWS_BUCKET/$PREFIX/$(date +"%Y")/$(date +"%m")/$(date +"%d").sql.gz

echo "Done!"

exit 0
