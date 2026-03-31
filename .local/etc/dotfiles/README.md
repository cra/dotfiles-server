# dotfiles-server

Server/dev machine dotfiles managed via bare git repo.

## What's in here

- `.tmux.conf` — tmux config (nord theme, top status bar)
- `.config/helix/` — helix editor config + language servers
- `.local/etc/dotfiles/bashrc_tmux.sh` — auto-attach tmux on SSH (session = hostname)
- `.local/etc/dotfiles/bashrc_path.sh` — Go and dev tool paths
- `.local/etc/dotfiles/bashrc_dotfiles.sh` — `dot` alias for managing this repo
- `.local/etc/dotfiles/bashrc_interactive.sh` — fzf, zoxide, just, history
- `.local/etc/dotfiles/bashrc_git.sh` — git aliases
- `.local/etc/dotfiles/bashrc_ps1.sh` — nord PS1 prompt (set `PS1_ACCENT` per machine)

## New machine setup

```bash
# 1. Clone dotfiles
git clone --bare git@github.com:cra/dotfiles-server.git ~/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot checkout trunk

# 2. Install packages
bash ~/.local/etc/dotfiles/setup.sh

# 3. Add to ~/.bashrc:
source ~/.local/etc/dotfiles/bashrc_tmux.sh         # first! replaces shell with tmux
PS1_ACCENT="orange"  # frost|aurora|orange|purple|red|yellow|teal|white
source ~/.local/etc/dotfiles/bashrc_path.sh
source ~/.local/etc/dotfiles/bashrc_dotfiles.sh
source ~/.local/etc/dotfiles/bashrc_interactive.sh
source ~/.local/etc/dotfiles/bashrc_git.sh
source ~/.local/etc/dotfiles/bashrc_ps1.sh

# 4. Reload
source ~/.bashrc
```

## Daily usage

```bash
dot status          # what changed
dot add <file>      # track a file
dot commit -m "..."
dot push
```

## Machine colors

Set `PS1_ACCENT` in bashrc before sourcing ps1.sh to visually distinguish machines:
- `frost` — light blue (default)
- `aurora` — green
- `orange` — warm orange
- `purple` — soft purple
- `red` / `yellow` / `teal` / `white`

## Terminal

If `xterm-kitty` isn't available on a remote machine:
```bash
infocmp -a xterm-kitty | ssh <host> tic -x -o ~/.terminfo /dev/stdin
```
Or set `TERM=xterm-256color` as a fallback.
