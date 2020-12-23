#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

tmux send-keys -t "=$test_session:0.0" 'echo Hello world' Enter
tmux send-keys -t "=$test_session:0.0" 'tmux_kak_copy_mode here' Enter
test_sleep_for_tmux
tmux send-keys -t "=$test_session:0.0" ':execute-keys %(%sworld<ret>cthere<esc>)' Enter
tmux send-keys -t "=$test_session:0.0" 'gk' Enter

test_sleep_for_tmux

# Capture and test the contents of the kakoune buffer.
tmux capture-pane -t "=$test_session:0.0" -p -E8 >pane.txt
>pane.txt.expected echo \
"$ echo Hello there
Hello there
$ tmux_kak_copy_mode here





"

tmux list-windows -a >windows.info
