# Bare git repo alias for dotfiles management
alias D='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
__git_complete D __git_main 2>/dev/null
alias DST='D status'
alias DP='D push'
alias DC='D commit -v'
alias DAPA='D add -p'
