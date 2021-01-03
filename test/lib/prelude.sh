repository_root="$( ( cd "${0%/*}"; pwd ) )"
repository_root="${repository_root%/test*}"

test_name="${0##*/}"
test_root="$PWD"

# A space delimited sequence of assignments to be used as arguments to the
# env command.
variable_assignments=""

prelude_export ()
{
    variable_assignments="$variable_assignments $1=\"\$$1\""
    export "$1"
}

# Export the test_root directory with a safe name.
TMUX_KAK_COPY_MODE_TEST_ROOT="$test_root"
prelude_export TMUX_KAK_COPY_MODE_TEST_ROOT

# Export a copy of the current PATH before modifying it.
TMUX_KAK_COPY_MODE_TEST_ORIGINAL_PATH="$PATH"
prelude_export TMUX_KAK_COPY_MODE_TEST_ORIGINAL_PATH

# Set up a home directory specific to this test.
HOME="$test_root/home"
prelude_export HOME
mkdir "$HOME"

# Set up a temporary directory specific to this test.
TMPDIR="$test_root/tmp"
prelude_export TMPDIR
mkdir "$TMPDIR"

# Modify PATH to include the binary directory of this repository.
PATH="$repository_root/bin:$PATH"
# Modify PATH to include a directory for test helper binaries.
PATH="$repository_root/test/bin:$PATH"
prelude_export PATH

# The shell used by tmux for new windows.
SHELL="/bin/sh"
prelude_export SHELL

# Set the path to kakoune user session sockets.
XDG_RUNTIME_DIR="$test_root/xdg_runtime_dir"
prelude_export XDG_RUNTIME_DIR
mkdir "$XDG_RUNTIME_DIR"

# See KAKOUNE_CONFIG_DIR.
XDG_CONFIG_HOME="$test_root/.config"
prelude_export XDG_CONFIG_HOME
mkdir "$XDG_CONFIG_HOME"

# Set the path to kakoune user configuration.
KAKOUNE_CONFIG_DIR="$XDG_CONFIG_HOME/kak"
prelude_export KAKOUNE_CONFIG_DIR
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

test_sleep_for_tmux ()
{
    sleep 0.5
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
eval tmux new-session -d -s '"$test_session"' -x80 -y10 -- env $variable_assignments /bin/sh
