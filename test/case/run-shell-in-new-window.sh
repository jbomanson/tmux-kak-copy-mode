#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

tmux send-keys -t "=$test_session:0.0" 'echo Hello world' Enter
tmux run-shell -t "=$test_session:0.0" "$(command -v tmux-kak-copy-mode)"
test_sleep_for_tmux
tmux send-keys -t "=$test_session:0.0" ':execute-keys %(%sworld<ret>cthere<esc>)' Enter
tmux send-keys -t "=$test_session:0.0" 'gk' Enter

test_sleep_for_tmux

# Capture and test the contents of the kakoune buffer.
tmux capture-pane -t "=$test_session:0.0" -p -E8 >pane.txt
>pane.txt.expected echo \
"$ echo Hello there
Hello there
$





"

tmux list-windows -a >windows.info
wc --l windows.info >windows.count
>windows.count.expected echo "2 windows.info"
