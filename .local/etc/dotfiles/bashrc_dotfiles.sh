# Bare git repo alias for dotfiles management
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
__git_complete dot __git_main 2>/dev/null
