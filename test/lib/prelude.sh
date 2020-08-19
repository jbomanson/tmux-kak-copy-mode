repository_bin="$( ( cd "${0%/*}/.."; pwd ) )/bin"

test_name="${0##*/}"
test_root="$PWD"

# Export the test_root directory with a safe name.
TMUX_KAK_COPY_MODE_TEST_ROOT="$test_root"
export TMUX_KAK_COPY_MODE_TEST_ROOT

# Export the current PATH before modifying it.
TMUX_KAK_COPY_MODE_TEST_ORIGINAL_PATH="$PATH"
export TMUX_KAK_COPY_MODE_TEST_ORIGINAL_PATH

# Set up a home directory specific to this test.
HOME="$test_root/home"
export HOME
mkdir "$HOME"

# Modify PATH to include the binary directory of this repository.
PATH="$repository_bin:$PATH"
export PATH

# Modify PATH to include a directory for test helper binaries.
PATH="$test_root/test/bin:$PATH"
export PATH

# The shell used by tmux for new windows.
SHELL="/bin/sh"
export SHELL

# Set the path to kakoune user session sockets.
XDG_RUNTIME_DIR="$test_root/xdg_runtime_dir"
export XDG_RUNTIME_DIR
mkdir "$XDG_RUNTIME_DIR"

# See KAKOUNE_CONFIG_DIR.
XDG_CONFIG_HOME="$test_root/.config"
export XDG_CONFIG_HOME
mkdir "$XDG_CONFIG_HOME"

# Set the path to kakoune user configuration.
KAKOUNE_CONFIG_DIR="$XDG_CONFIG_HOME/kak"
export KAKOUNE_CONFIG_DIR
mkdir "$KAKOUNE_CONFIG_DIR"

# Example:
#   echo abc >file.txt
#   test_in_place file.txt tr a b
#   cat file.txt
#   # => bbc
function test_in_place ()
{
    local file="$1"; shift
    "$@" <"$file" >"$file.test_in_place"
    local status="$?"
    # Use cat and rm to rewrite "$file" to preserve its permissions.
    cat "$file.test_in_place" >"$file"
    rm "$file.test_in_place"
    return "$status"
}

test_clean_up () {
    code=$?
    tmux kill-session -t "=$test_session"
    kak -clear
    rmdir --ignore-fail-on-non-empty "$HOME" "$KAKOUNE_CONFIG_DIR" "$XDG_RUNTIME_DIR" "$XDG_CONFIG_HOME"
    exit $code
}

trap test_clean_up EXIT

# Start a new tmux session.
test_session="TMUX_KAK_COPY_MODE_TEST_SESSION"
tmux new-session -d -s "$test_session" -x80 -y10 /bin/sh
