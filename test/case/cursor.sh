#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

tmux send-keys -t "=$test_session:0.0" 'echo Hello world' Enter
tmux run-shell -t "=$test_session:0.0" tmux-kak-copy-mode
test_sleep_for_tmux
tmux send-keys -t "=$test_session:0.0" 'cCURSOR' Escape Enter

test_sleep_for_tmux

# Capture and test the contents of the kakoune buffer.
tmux capture-pane -t "=$test_session:0.0" -p -E8 >pane.txt
>pane.txt.expected echo \
'$ echo Hello world
Hello world
$CURSOR



'
