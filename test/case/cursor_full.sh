#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

tmux send-keys -t "=$test_session:0.0" 'seq 1 100' Enter
tmux run-shell -t "=$test_session:0.0" tmux_kak_copy_mode
test_sleep_for_tmux
tmux send-keys -t "=$test_session:0.0" 'cCURSOR' Escape Enter

test_sleep_for_tmux

# Capture and test the contents of the kakoune buffer.
tmux capture-pane -t "=$test_session:0.0" -p -E8 >pane.txt
>pane.txt.expected echo \
'93
94
95
96
97
98
99
100
$CURSOR'
