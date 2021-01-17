#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

tmux send-keys -t "=$test_session:0.0" 'echo Hello world' Enter
tmux send-keys -t "=$test_session:0.0" 'tmux-kak-copy-mode here' Enter
test_sleep_for_tmux

# Make some modifications to the kakoune buffer.
# These modifications should not impact the outcome of the test.
tmux send-keys -t "=$test_session:0.0" ':execute-keys %(%sworld<ret>cthere<esc>)' Enter
tmux send-keys -t "=$test_session:0.0" 'gk' Enter

tmux send-keys -t "=$test_session:0.0" ':wq' Enter

test_sleep_for_tmux

tmux capture-pane -t "=$test_session:0.0" -p >pane.txt
>pane.txt.expected echo \
"$ echo Hello world
Hello world
$ tmux-kak-copy-mode here
$





"

tmux list-windows -a >windows.info
