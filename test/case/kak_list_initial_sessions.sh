#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

kak -l >sessions.txt
>sessions.txt.expected true
