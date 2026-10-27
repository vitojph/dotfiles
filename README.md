# dotfiles

My config files. Feel free.

They work on Linux and macOS.

## Layout

- `dotconfig/<app>` goes to `~/.config/<app>`. This is the current setup.
- `dot<name>` goes to `~/.<name>`. These are older files, kept for history.

## Current files (`dotconfig/`)

| Path | Goes to | What it is |
| --- | --- | --- |
| `dotconfig/nvim` | `~/.config/nvim` | Neovim config, based on LazyVim |
| `dotconfig/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | tmux config |
| `dotconfig/herdr/config.toml` | `~/.config/herdr/config.toml` | herdr key bindings, matched to tmux |
| `dotconfig/git/config` | `~/.config/git/config` | Git aliases and defaults |

Install them with symlinks:

```sh
for app in nvim tmux herdr git; do
  ln -s "$PWD/dotconfig/$app" ~/.config/$app
done
```

If the target already exists, `ln -s` puts the link inside that folder instead.
Move the old folder away first.

### Neovim

- Uses LazyVim. On first start, lazy.nvim installs itself and all plugins.
- `lazy-lock.json` pins the plugin versions.
- Extras: Python, Markdown and neo-tree.
- Python: ty and ruff (`lua/plugins/ty.lua`). ty finds the project `.venv` on its own.
  To go back to pyright, set `vim.g.lazyvim_python_lsp = "pyright"` in
  `lua/config/options.lua` and delete `lua/plugins/ty.lua`.
- `lua/plugins/theme.lua`: On Omarchy, it loads the current Omarchy theme.
  On other systems, it uses tokyonight.
- `lua/config/remote_clipboard.lua`: Over SSH or inside tmux or herdr, copies go to
  the local clipboard with OSC 52. On Linux it also uses `wl-copy` and `wl-paste`.
- `plugin/after/transparency.lua`: Removes the background color, so the terminal
  background shows through.

### tmux

- Prefix is `Ctrl-a`.
- `prefix |` and `prefix -` split the pane in the current folder.
- `prefix h/j/k/l` resizes panes. `prefix m` zooms the pane.
- `prefix r` reloads the config.
- Plugins use TPM. Install TPM once, then press `prefix I` in tmux:

  ```sh
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ```

### herdr

- Prefix is `Ctrl-a`, the same as tmux.
- `prefix |` and `prefix -` split the pane. `prefix h/j/k/l` moves focus.
- Only `config.toml` is config. herdr writes logs, sockets and `session.json`
  in the same folder. Do not commit them.

### Git

- Aliases: `co`, `br`, `ci`, `st`.
- Editor is `nvim`.
- Pull rebases. Push sets the upstream branch.
- `rerere` records and reuses conflict fixes.
- Contains my name and email. Change `[user]` if you use it.

## Older files

| File | Goes to | Notes |
| --- | --- | --- |
| `dotzshrc` | `~/.zshrc` | oh-my-zsh. Has a macOS path: `/Users/victor/.oh-my-zsh`. |
| `dotfzf.zsh` | `~/.fzf.zsh` | fzf setup. Uses the Intel Homebrew path `/usr/local/opt/fzf`. |
| `dotvimrc` | `~/.vimrc` | Vim config. Replaced by Neovim. |
| `dotgvimrc` | `~/.gvimrc` | GUI Vim settings. |
| `dottmux.conf` | `~/.tmux.conf` | Old tmux config. Replaced by `dotconfig/tmux`. |
| `dotgitconfig` | `~/.gitconfig` | Old Git config. Replaced by `dotconfig/git/config`. |
| `dotgitignore` | `~/.gitignore` | Global ignore patterns. Git only reads it if `core.excludesFile` points to it. |
| `start-tmux.sh` | anywhere | Starts a tmux session with `notes`, `dev` and `ipython` windows. |
| `vscode-uesr-settings.json` | VS Code user `settings.json` | VS Code settings. |

Do not install `dotgitconfig` together with `dotconfig/git/config`.
Git reads `~/.gitconfig` last, so its `editor = vim` wins.
