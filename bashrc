# GENERATED AT https://www.kirsle.net/wizards/ps1.html
export PS1="[\[$(tput setaf 4)\]\u\[$(tput setaf 7)\]: \[$(tput bold)\]\[$(tput setaf 1)\]\W\[$(tput sgr0)\]]$ \[$(tput sgr0)\]"

# Pretty-print output for ls
alias ls='ls -GFh'

# Use MacVim's vim
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim' # or something like that, YMMV

# Auto-complete for git
if [ -f ~/bin/git-completion.bash ]; then
  . ~/bin/git-completion.bash
fi

# Updates PATH for the Google Cloud SDK.
source '/Users/max/google-cloud-sdk/path.bash.inc'

# Enables shell command completion for gcloud.
source '/Users/max/google-cloud-sdk/completion.bash.inc'

# Enables Shell integration within iTerm
test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash

# Brown CS shortcut
alias browncs='ssh ssh.cs.brown.edu'
