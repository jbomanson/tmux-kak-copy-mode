#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

touch config.txt
kak -n -f '|printf "%s" "$kak_config"<ret>' config.txt >/dev/null
test_in_place config.txt sed "s,$PWD,€PWD,g"

>config.txt.expected echo "€PWD/.config/kak"
