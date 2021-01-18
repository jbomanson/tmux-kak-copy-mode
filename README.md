# tmux-kak-copy-mode

[![License](https://img.shields.io/github/license/jbomanson/tmux-kak-copy-mode)](https://opensource.org/licenses/Apache-2.0)

**tmux-kak-copy-mode** is a script that allows to use the terminal code editor
[Kakoune](https://github.com/mawww/kakoune)
to view the content of panes
of the terminal multiplexer [tmux](https://github.com/tmux/tmux).
The script aims to replace tmux copy-mode in a way that Kakoune users may appreciate.

## Example

Suppose we have a tmux session with two panes: one pane for Kakoune and another for a shell.

![screenshot 1](https://user-images.githubusercontent.com/11866614/104899419-7e54b300-5983-11eb-9459-38e5003fc07d.png)

Using tmux-kak-copy-mode, we can open the shell pane contents in a Kakoune client!
We can for example navigate and yank text using Kakoune movement keys.

![screenshot 2](https://user-images.githubusercontent.com/11866614/104899431-814fa380-5983-11eb-9890-9e4779665ac5.png)

The new client is connected to the same Kakoune session as the other one.
Therefore, the Kakoune register contents we yanked can be pasted to the other Kakoune client.
![screenshot 3](https://user-images.githubusercontent.com/11866614/104899440-83b1fd80-5983-11eb-846c-d714e3fe5b5f.png)

## Benefits

- You can use **Kakoune key mappings** when viewing tmux pane contents.
  Importantly, you can do so even if your mappings are customized.

- You can use **Kakoune registers** in addition to tmux paste buffers
  to yank text from tmux panes.
  This works well because tmux-kak-copy-mode connects to any existing
  Kakoune session within the current tmux session.

## Dependencies

- [Kakoune)(https://github.com/mawww/kakoune)

- [tmux](https://github.com/tmux/tmux)

- [kak-ansi](https://github.com/eraserhd/kak-ansi),
  which can be installed for example with the Kakoune plugin manager
  [plug](https://github.com/andreyorst/plug.kak).
  This plugin is used for rendering ANSI-colored text in Kakoune.

- [tmux-kak-info.kak](https://github.com/jbomanson/tmux-kak-info.kak),
  which can also be installed with
  [plug](https://github.com/andreyorst/plug.kak).
  This plugin is used for determining which Kakoune session to connect to.

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
bind-key [ run-shell tmux-kak-copy-mode
```

Then run `tmux source-file ~/.tmux.conf` or restart tmux.
Afterward, the key sequence `Ctrl+B [` will launch tmux-kak-copy-mode assuming `Ctrl+B` is your tmux leader key.

### Optional: Configure Kakoune

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

## Caveats

The `tmux-kak-copy-mode in_new_pane` call works by creating a new temporary tmux
pane, opening Kakoune in it, and temporarily swapping that new pane with
whatever pane used to be active.
Ideally, the old pane would be hidden for the duration of the process, but this
is not done in the current implementation.
