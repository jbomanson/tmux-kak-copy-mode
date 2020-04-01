# tmux_kak_copy_mode

[![License](https://img.shields.io/github/license/jbomanson/tmux_kak_copy_mode)](https://opensource.org/licenses/Apache-2.0)

**tmux_kak_copy_mode** is a script that allows to use the terminal code editor
[Kakoune](https://github.com/mawww/kakoune)
to view the content of panes
of the terminal multiplexer [tmux](https://github.com/tmux/tmux).
The script aims to replace the functionality of the tmux copy-mode
in a way that Kakoune users should appreciate.

### Benefits

- Fans of Kakoune who wish to use Kakoune key mappings can use
    Kakoune itself in place of tmux copy-mode instead of trying to
    configure tmux copy-mode to work more like Kakoune.

- **Kakoune registers are shared** between the Kakoune client used for
    tmux_kak_copy_mode and any* Kakoune clients in the same tmux
    session.
    Thus, whereas otherwise one might try to operate with Kakoune and tmux
    by using tmux paste buffers and configuring Kakoune to work with them,
    now you may simply use Kakoune registers for a lot of things.
    (*) = Assuming there are clients of only one Kakoune session within
    this tmux session.
    In the presence of many Kakoune sessions, the registers will be shared with
    the clients of one of the Kakoune sessions.

- You can optionally add lines to the pane content in Kakoune
    and those **lines will be sent as key strokes to the pane** once
    the Kakoune client is closed.
    This way you can easily write commands to be executed in their
    shell, or whichever program you are running the tmux pane.

TODO:
![screenshot](docs/screenshot.png)

## Dependencies

- [Kakoune)(https://github.com/mawww/kakoune)

- [tmux](https://github.com/tmux/tmux)

- [kak-ansi](https://github.com/eraserhd/kak-ansi),
  which can be installed for example with the Kakoune plugin manager
  [plug](https://github.com/andreyorst/plug.kak).
  This is used for rendering ANSI-colored text in Kakoune.

## Installation

### tmux_kak_copy_mode

First, copy the executable `bin/tmux_kak_copy_mode` included in this repository
to any directory on your PATH either manually, or let the included `Makefile`
do that.

For example, to install to /usr/local/bin:
```sh
make install
```

Alternatively, to install to `$HOME/.local/bin` for example:
```sh
env PREFIX="$HOME/.local" make install
```

### Recommended: Configure tmux

Add a tmux key binding to start tmux_kak_copy_mode in response to a key press by
adding a line such as the following to your `~/.tmux.conf`:

```tmux
bind-key i run-shell 'tmux_kak_copy_mode in_new_window'
```

Then run `tmux source-file ~/.tmux.conf` or restart tmux.
Afterward, the key sequence `Ctrl+B i` should launch tmux_kak_copy_mode.

## Optional: Configure Kakoune

You may configure the behaviour of Kakoune when Kakoune is used for
tmux_kak_copy_mode by adding a hook for the file type `tmux_kak_copy_mode`
to your `kakrc`.
The following is an example of how to set the Kakoune option `scrolloff` to
`0,0` in tmux_kak_copy_mode.

```kak
hook global WinSetOption filetype=tmux_kak_copy_mode %{
    echo -debug "Running hooks for tmux_kak_copy_mode"
    set-option window scrolloff 0,0
    hook -once -always window WinSetOption filetype=.* %{ unset-option window scrolloff }
}
```

## Usage

When in tmux, press your chosen keybinding and, if everything goes smoothly,
the pane in front of you should turn into a kakoune window showing the contents
that were in the pane.

Once done, quit kakoune with `:q`, for example.

## Caveats

The `tmux_kak_copy_mode in_new_pane` call works by creating a new temporary tmux
pane, opening kakoune in it, and temporarily swapping that new pane with
whatever pane used to be active.
Ideally, the old pane would be hidden for the duration of the process, but this
is not done in the current implementation.
