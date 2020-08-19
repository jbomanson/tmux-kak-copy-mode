#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

touch config.txt
tmux send-keys -t "=$test_session:0.0" \
"kak -n -f '|printf \"%s\" \"\$kak_config\"<ret>' config.txt >/dev/null
tmux wait-for -S filter
"
tmux wait-for filter
test_in_place config.txt sed "s,$PWD,€PWD,g"

>config.txt.expected echo "€PWD/.config/kak"
