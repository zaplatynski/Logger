#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/colors.sh

echo "${LIGHT_GREEN}*** Building Logger $1 ****${NC}"
echo "${LIGHT_YELLOW}To modify version number edit tasks.json${NC}"
echo ""

node build/build.js $1