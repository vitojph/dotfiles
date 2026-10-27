# AGENTS.md

Instructions for AI agents that work in this repo.

## Goal

This repo holds Victor's personal config files.
The main task is migration: set up these configs on a new machine,
or copy changes from a machine back into the repo.
Targets are Linux (often Omarchy, on Arch) and macOS.

Read `README.md` first. It lists every file and what it does.

## Layout

- `dotconfig/<app>/` goes to `~/.config/<app>/`. These are the current configs.
- `dot<name>` goes to `~/.<name>`. These are older configs, kept for history.
  Do not install them unless the user asks.

| Repo path | Target | Notes |
| --- | --- | --- |
| `dotconfig/nvim` | `~/.config/nvim` | LazyVim |
| `dotconfig/tmux` | `~/.config/tmux` | Plugins use TPM |
| `dotconfig/herdr` | `~/.config/herdr` | Only `config.toml` |
| `dotconfig/git` | `~/.config/git` | Do not combine with `dotgitconfig` |

## Rules

- Ask before you overwrite or delete anything in `~` or `~/.config`.
  Back up first. Never delete the user's existing config.
- Install with symlinks, not copies. Then edits on the machine show up in the repo.
- Do not commit runtime state. Examples: sockets, logs, `session.json`,
  `*.bak*` files, `lazy-lock.json` changes the user did not ask for.
- Do not commit secrets or tokens. Only the name and email in `dotconfig/git/config` are OK.
- Keep paths portable. Use `~`, `$HOME`, `vim.fn.expand("~")` or `vim.fn.stdpath()`.
  Never write `/home/victor` or `/Users/victor` into a config.
- If a config needs something that exists on only one OS, guard it.
  Check that the file or command exists, and fall back if it doesn't.
  `dotconfig/nvim/lua/plugins/theme.lua` is the pattern to follow.
- Update `README.md` when you add, move or remove a file.
- Commit on a branch, not on `master`, unless the user says otherwise.

## Install on a new machine

### 1. Install the tools

Required: `git`, `neovim` (0.11 or newer), `tmux`, a C compiler, `curl`,
`ripgrep`, `fd`, `node`/`npm` (Mason uses it for markdownlint).
Optional: `lazygit`, `herdr`, a Nerd Font in the terminal.

- macOS: `brew install git neovim tmux ripgrep fd node lazygit`.
  Xcode Command Line Tools give the C compiler: `xcode-select --install`.
- Arch / Omarchy: `sudo pacman -S --needed git neovim tmux ripgrep fd nodejs npm lazygit base-devel wl-clipboard`.
  Omarchy already has most of these.
- herdr: follow https://herdr.dev. Skip it if the user does not use herdr.

Check what is already installed before you install anything.

### 2. Back up and link

For each app in `nvim tmux herdr git`:

1. If `~/.config/<app>` exists and is not already a link to this repo,
   move it to `~/.config/<app>.bak-<date>`. Ask the user first.
2. Link it: `ln -s "<repo>/dotconfig/<app>" ~/.config/<app>`.

Use the absolute path of the repo in the link. Check the link with `ls -l`.

Special cases:

- herdr writes runtime files (sockets, logs, `session.json`) next to `config.toml`.
  If you link the whole folder, these files land in the repo.
  Prefer to link only the file:
  `mkdir -p ~/.config/herdr && ln -s "<repo>/dotconfig/herdr/config.toml" ~/.config/herdr/config.toml`.
- git: if `~/.gitconfig` exists, git reads it after `~/.config/git/config`, so its
  values win. Tell the user, and suggest merging it into `dotconfig/git/config`.
- tmux: install TPM once:
  `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`.
  Then the user presses `prefix I` (prefix is `Ctrl-a`) inside tmux.

### 3. Verify

Run these and report the results:

```sh
# Neovim: install the locked plugin versions, then check health
nvim --headless "+Lazy! restore" +qa
nvim --headless "+checkhealth" "+w! ${TMPDIR:-/tmp}/nvim-health.txt" +qa
grep -n ERROR "${TMPDIR:-/tmp}/nvim-health.txt"

# tmux: no output means OK. The exit code is 0 even on errors.
# -L uses a separate server, so kill-server does not touch the user's sessions.
tmux -L dotfiles-check -f /dev/null start-server \; source-file ~/.config/tmux/tmux.conf \; kill-server

# herdr: prints "config: ok"
herdr config check

# git: prints "nvim"
git config --global --get core.editor
```

Never run `tmux kill-server` without `-L`. It ends all of the user's tmux sessions.

`Lazy! restore` installs the exact versions in `lazy-lock.json`.
Use `Lazy! sync` only if the user wants to update plugins.

On first start, Mason also installs ty, ruff and markdownlint-cli2.
That needs network and `npm`.

## Platform notes

- Omarchy theme: `lua/plugins/theme.lua` loads
  `~/.local/state/omarchy/current/theme/neovim.lua` when it exists.
  Otherwise it uses tokyonight. Omarchy may replace this file with a symlink
  when it installs or updates. If you see `theme.lua` as a symlink in `git status`,
  restore the repo version.
- `omarchy-theme-hotreload.lua` and `all-themes.lua` are for Omarchy.
  They do no harm on macOS.
- Clipboard: `lua/config/remote_clipboard.lua` only runs inside tmux, SSH or herdr.
  It uses `wl-copy`/`wl-paste` on Wayland and OSC 52 elsewhere.
  On macOS outside tmux, Neovim uses `pbcopy` by default.
- Old files with fixed paths: `dotzshrc` (`/Users/victor/.oh-my-zsh`) and
  `dotfzf.zsh` (`/usr/local/opt/fzf`, Intel Homebrew). Fix these paths before
  you install them on another machine.

## Copy changes from a machine back into the repo

Use this when configs on a machine are newer than the repo
(for example, they were copies, not links).

1. Compare: `diff -r ~/.config/<app> dotconfig/<app>`.
2. Copy only config files. Skip runtime state (see Rules).
3. Run the checks below.
4. Show the user the diff, then commit on a branch.

Checks before you commit:

```sh
# Broken or machine-specific symlinks
find dotconfig -type l -exec ls -l {} \;
find dotconfig -xtype l

# Sockets, logs, backups
find dotconfig -type s -o -name '*.log' -o -name '*.bak*' -o -name 'session.json'

# Hard-coded home paths
grep -rnE '/home/[a-z]+|/Users/[a-z]+' dotconfig --exclude=lazy-lock.json
```

Every result needs a fix or a reason to keep it.
A symlink in the repo is almost always wrong: replace it with a real file
or a guarded loader, like `theme.lua`.
