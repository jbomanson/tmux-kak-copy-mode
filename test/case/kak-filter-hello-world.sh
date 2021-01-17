#! /bin/bash

source "${0%/*}/../lib/prelude.sh"

touch hello_world.txt
kak -n -f "iHello world from kak" hello_world.txt >/dev/null

>hello_world.txt.expected echo "Hello world from kak"
