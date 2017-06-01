# GENERATED AT https://www.kirsle.net/wizards/ps1.html
export PS1="\[$(tput setaf 4)\]\u\[$(tput setaf 7)\]: \[$(tput bold)\]\[$(tput setaf 9)\]\w\[$(tput sgr0)\] \$ \[$(tput sgr0)\]"

export EDITOR=vim

# Use vi
set -o vi

# Auto-complete for git
if [ -f ~/bin/git-completion.bash ]; then
  . ~/bin/git-completion.bash
fi

# Enables Shell integration within iTerm
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Prettier cat output
if [ `which ccat` ]; then
    alias cat='ccat --bg=dark'
fi

# Local config
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi
