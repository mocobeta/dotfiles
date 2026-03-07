# MacOS-only
# export BASH_SILENCE_DEPRECATION_WARNING=1
export TERMINAL=/usr/bin/kitty


# git
source ~/.bash_scripts/git-completion.bash
source ~/.bash_scripts/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=false
GIT_PS1_SHOWSTASHSTATE=false
GIT_PS1_SHOWUPSTREAM=auto

export PS1='[\D{%H:%M} \W]$(__git_ps1 " (%s)")\$ '

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# rbenv
# eval "$(rbenv init -)"

# Rust
. "$HOME/.cargo/env"

# uv
source $HOME/.local/bin/env 

# orbstack
# source $HOME/.orbstack/shell/init.bash

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="$HOME/.sdkman"
#[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# aliases
alias grep='rg --color=auto'
alias ls='eza -aF'
alias cat='bat --theme "Solarized (light)" --style=plain --paging=never'
alias less='bat --theme "Solarized (light)" --style=numbers'
alias ps='procs --theme dark'
alias du='dust'
alias top='btm'
alias sed='gsed'

. "$HOME/.local/bin/env"

# direnv
eval "$(direnv hook bash)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tomoko.uchida/google-cloud-sdk/path.bash.inc' ]; then . '/Users/tomoko.uchida/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tomoko.uchida/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/tomoko.uchida/google-cloud-sdk/completion.bash.inc'; fi
