# GENERATED AT https://www.kirsle.net/wizards/ps1.html
export PS1="[\[$(tput setaf 4)\]\u\[$(tput setaf 7)\]: \[$(tput bold)\]\[$(tput setaf 1)\]\W\[$(tput sgr0)\]]$ \[$(tput sgr0)\]"

# Use vi
set editing-mode vi

# Use MacVim's vim
if [ -f '/Applications/MacVim.app/Contents/MacOS/Vim' ]; then
    alias vim='/Applications/MacVim.app/Contents/MacOS/Vim' # or something like that, YMMV
fi

# Auto-complete for git
if [ -f ~/bin/git-completion.bash ]; then
  . ~/bin/git-completion.bash
fi

# Enables Shell integration within iTerm
test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash

# Local config
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi
