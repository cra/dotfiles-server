# dotfiles-server

Server/dev machine dotfiles managed via bare git repo.

## What's in here

- `.tmux.conf` — tmux config (nord theme, top status bar)
- `.config/helix/` — helix editor config + language servers
- `.local/etc/bashrc_ps1.sh` — nord PS1 prompt (set `PS1_ACCENT` per machine)
- `.local/etc/bashrc_path.sh` — Go and dev tool paths
- `.local/etc/bashrc_dotfiles.sh` — `dot` alias for managing this repo

## New machine setup

```bash
# 1. Run the bootstrap script (installs packages + clones dotfiles)
curl -sL <raw-url-to-setup.sh> | bash
# or clone first, then:
~/.local/etc/dotfiles/setup.sh

# 2. Add to ~/.bashrc:
PS1_ACCENT="orange"  # frost|aurora|orange|purple|red|yellow|teal|white
source ~/.local/etc/dotfiles/bashrc_path.sh
source ~/.local/etc/dotfiles/bashrc_dotfiles.sh
source ~/.local/etc/dotfiles/bashrc_ps1.sh
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
