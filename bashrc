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

# Local config
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

# Load in fzf config if present
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Journal alias
alias journal='vim + ~/Dropbox/journal/$(date +%Y)/$(date +%Y%m%d).md -c "execute \"normal! Go\<CR>$(date +%T)\<CR>========\<CR>\" | startinsert "'
