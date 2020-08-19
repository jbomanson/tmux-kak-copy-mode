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

# Setup for kakoune.
XDG_RUNTIME_DIR="$test_root/xdg_runtime_dir"
mkdir "$XDG_RUNTIME_DIR"

test_clean_up () {
    code=$?
    rmdir --ignore-fail-on-non-empty "$HOME" "$XDG_RUNTIME_DIR"
    tmux kill-session -t "=$test_session"
    exit $code
}

trap test_clean_up EXIT

# Start a new tmux session.
test_session="TMUX_KAK_COPY_MODE_TEST_SESSION"
tmux new-session -d -s "$test_session" -x80 -y10 env -i /bin/dash -i /dev/stdin
