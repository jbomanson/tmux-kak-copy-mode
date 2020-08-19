#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

tmux send-keys -t "=$test_session:0.0" "echo Hello world" Enter

tmux_kak_copy_mode private_capture_pane -t "=$test_session:0.0" >pane.txt

>pane.txt.expected echo \
"$ echo Hello world
Hello world
$






"
