# === Auto-attach tmux on SSH login ===
# Session name = hostname (unique per machine, readable in status bar)
if [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
    tmux new -A -s "$(hostname -s)"
fi
