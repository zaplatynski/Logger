#!/bin/sh

# make sure script uses correct environment settings for sqlplus
# source ~/.profile

# Env variables $1, $2, etc are from the tasks.json args array

# Colors
RED='\033[0;31m'
LIGHT_GREEN='\033[0;92m'
NC='\033[0m' # No Color

# Get the database connection string
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ENV_FILE_NAME="../vsc-task-env"
ENV_FILE=$DIR/$ENV_FILE_NAME
SQL_FILE_COLOR=$DIR/colors.sql

# Check if connection file is missing
if [ ! -f $ENV_FILE ]; then
  echo "$ENV_FILE is not found, generating\n"
  echo "ORACLE_SQL_CONNECTION=\"CHANGEME\"" > $ENV_FILE
fi

# Load connection script
source $ENV_FILE

if [ -z "$ORACLE_SQL_CONNECTION" ] || [ $ORACLE_SQL_CONNECTION = "CHANGEME" ] ; then
  echo "${RED}*** CONFIG ERROR ***\n${NC}You need to edit $ENV_FILE and define the full connection string to your database. Ex: giffy/giffy@localhost:32122/orclpdb514.localdomain"
  # End process
  kill -INT $$
fi

echo "Parsing file: ${LIGHT_GREEN}$2${NC}"
# run sqlplus, execute the script, then get the error list and exit
# sqlcl $1 << EOF
sqlplus $ORACLE_SQL_CONNECTION << EOF
set define off
--
$2
--
set define on
@$SQL_FILE_COLOR
-- Colors: http://orasql.org/2013/05/22/sqlplus-tips-6-colorizing-output/
prompt &_CB_WHITE &_C_BLACK :: show errors :: &_C_RESET &_C_RED
show errors
prompt &_C_RESET
-- @_show_errors.sql $3
exit;
EOF



