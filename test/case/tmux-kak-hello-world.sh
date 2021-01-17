#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

touch hello_world.txt
tmux send-keys -t "=$test_session:0.0" "kak -n -s my_session hello_world.txt" Enter

tmux send-keys -t "=$test_session:0.0" \
":map global insert | <esc>
iHello world from kak|:wq
"

tmux capture-pane -t "=$test_session:0.0" -p >pane.info

>hello_world.txt.expected echo "Hello world from kak"
