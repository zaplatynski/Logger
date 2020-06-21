#!/bin/sh

# Directory of this file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load helper
source $SCRIPT_DIR/helper.sh

echo "${COLOR_LIGHT_GREEN}*** Building Logger $1 ****${COLOR_RESET}"
echo "${COLOR_LIGHT_YELLOW}To modify version number edit tasks.json${COLOR_RESET}"
echo ""

node build/build.js $1