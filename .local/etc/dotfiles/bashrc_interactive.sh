# === Interactive shell: fzf, zoxide, just, history ===

# History
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth
shopt -s histappend

# fzf (Ctrl-R fuzzy history, Ctrl-T file finder)
# fzf 0.48+ uses --bash, older versions use sourced scripts
if fzf --bash &>/dev/null; then
    eval "$(fzf --bash)"
else
    [ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash
    [ -f /usr/share/doc/fzf/examples/completion.bash ] && source /usr/share/doc/fzf/examples/completion.bash
fi

# zoxide (smart cd)
eval "$(zoxide init bash)"

# just (command runner)
alias j=just
eval "$(just --completions bash)"
