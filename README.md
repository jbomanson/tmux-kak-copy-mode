# tmux-kak-copy-mode

[![License](https://img.shields.io/github/license/jbomanson/tmux-kak-copy-mode)](https://opensource.org/licenses/Apache-2.0)

**tmux-kak-copy-mode** is a script that allows to use the terminal code editor
[Kakoune](https://github.com/mawww/kakoune)
to view the content of panes
of the terminal multiplexer [tmux](https://github.com/tmux/tmux).
The script aims to replace tmux copy-mode in a way that Kakoune users may appreciate.

### Benefits

- You can use **Kakoune key mappings** when viewing tmux pane contents.

- You can use **Kakoune registers** to yank text from tmux panes.
  This works because tmux-kak-copy-mode connects to an existing Kakoune session
  associated with the appropriate tmux session if there is any.
  Thus, whereas before you might try to operate with Kakoune and tmux
  by using tmux paste buffers and configuring Kakoune to work with them,
  now you may choose to use any Kakoune registers for the same task.

- You can optionally add lines to the pane content in Kakoune
  and those lines will be **sent back as key strokes to the pane** once
  you close the Kakoune client.
  This way you can easily write commands in Kakoune to be executed in a
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

- [tmux-kak-info.kak](https://github.com/jbomanson/tmux-kak-info.kak),
  which can also be installed with
  [plug](https://github.com/andreyorst/plug.kak).
  This is used for determining which Kakoune session to connect to.

## Installation

### tmux-kak-copy-mode

Once the above dependencies are installed, copy the executable
`bin/tmux-kak-copy-mode` included in this repository to any directory on your
PATH either manually, or let the included `Makefile`
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

Add a tmux key binding to start tmux-kak-copy-mode in response to a key combination by
adding a line such as the following to your `~/.tmux.conf`:

```tmux
bind-key i run-shell tmux-kak-copy-mode
```

Then run `tmux source-file ~/.tmux.conf` or restart tmux.
Afterward, the key sequence `Ctrl+B i` should launch tmux-kak-copy-mode.

## Optional: Configure Kakoune

You may configure the behaviour of Kakoune when Kakoune is used for
tmux-kak-copy-mode by adding a hook for the file type `tmux-kak-copy-mode`
to your `kakrc`.
The following is an example of how to set the Kakoune option `scrolloff` to
`0,0` in tmux-kak-copy-mode.

```kak
hook global WinSetOption filetype=tmux-kak-copy-mode %{
    echo -debug "Running hooks for tmux-kak-copy-mode"
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

The `tmux-kak-copy-mode in_new_pane` call works by creating a new temporary tmux
pane, opening kakoune in it, and temporarily swapping that new pane with
whatever pane used to be active.
Ideally, the old pane would be hidden for the duration of the process, but this
is not done in the current implementation.
