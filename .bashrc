# MacOS-only
# export BASH_SILENCE_DEPRECATION_WARNING=1
export TERMINAL=/usr/bin/kitty


# git
source ~/.bash_scripts/git-completion.bash
source ~/.bash_scripts/git-prompt.sh

# starship
eval "$(starship init bash)"

source $HOME/.local/bin/env 

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# rbenv
# eval "$(rbenv init -)"

# Rust
. "$HOME/.cargo/env"
 
# orbstack
# source $HOME/.orbstack/shell/init.bash

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="$HOME/.sdkman"
#[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# direnv
eval "$(direnv hook bash)"

# node
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source $HOME/.bash_aliases
