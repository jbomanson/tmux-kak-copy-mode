#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

tmux send-keys -t "=$test_session:0.0" "echo Hello world >hello_world.txt" Enter

>hello_world.txt.expected echo "Hello world"
