#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

tmux send-keys -t "=$test_session:0.0" "kak -n -s my_session" Enter

sleep 0.1

tmux capture-pane -t "=$test_session:0.0" -p >pane-during.info

kak -l >sessions-during.txt
>sessions-during.txt.expected echo "my_session"

tmux send-keys -t "=$test_session:0.0" ":quit" Enter

tmux capture-pane -t "=$test_session:0.0" -p >pane-after.info

kak -l >sessions-after.txt
>sessions-after.txt.expected true
