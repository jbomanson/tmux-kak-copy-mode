#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

# Create another pane just so that this is not the only one.
tmux split-pane -d -h
# Zoom in this pane.
tmux resize-pane -Z

# Check that this pane is indeed being zoomed.
tmux display-message -p "#{window_zoomed_flag}" >beginning.window_zoomed_flag.txt
>beginning.window_zoomed_flag.txt.expected echo "1"

tmux send-keys -t "=$test_session:0.0" 'echo Hello world' Enter
tmux send-keys -t "=$test_session:0.0" 'tmux_kak_copy_mode in_new_window' Enter
test_sleep_for_tmux

# Unzoom the pane.
tmux resize-pane -Z

tmux send-keys -t "=$test_session:0.0" ':execute-keys %(%sworld<ret>cthere<esc>)' Enter
tmux send-keys -t "=$test_session:0.0" 'gk' Enter

tmux send-keys -t "=$test_session:0.0" ':wq' Enter

test_sleep_for_tmux

# Capture and test the contents of the kakoune buffer.
tmux capture-pane -t "=$test_session:0.0" -p -E8 >pane.txt
>pane.txt.expected echo \
"$ echo Hello world
Hello world
$ tmux_kak_copy_mode in_new_window
$




"

tmux display-message -p "#{window_zoomed_flag}" >copy_mode.window_zoomed_flag.txt
>copy_mode.window_zoomed_flag.txt.expected echo "0"

tmux list-windows -a >windows.info
wc --l windows.info >windows.count
>windows.count.expected echo "1 windows.info"
