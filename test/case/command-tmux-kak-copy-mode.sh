#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

command -v tmux-kak-copy-mode 2>/dev/null >executable.txt
test_in_place executable.txt sed "s,$repository_root,€repository_root,g"
>executable.txt.expected echo "€repository_root/bin/tmux-kak-copy-mode"
