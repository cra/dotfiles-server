# === Git aliases ===

# Status / info
alias gst='git status'
alias glo='git log --oneline --graph --decorate'
alias gl='git log --oneline'
alias gd='git diff'
alias gds='git diff --staged'
alias gdc='git diff --cached'
alias glf='git ls-files'

# Add / commit
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gapa='git add --patch'

# Branch / checkout
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gsw='git switch'

# Push / pull
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gf='git fetch'

# Rebase / merge
alias grb='git rebase'
alias grbi='git rebase -i'
alias gm='git merge'

# Tags
alias gt='git tag'
alias gta='git tag -a'
alias gtl='git tag -l'
