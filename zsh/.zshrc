#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

# Zsh Options
setopt extended_glob
setopt auto_cd              # cd by typing directory name if it's not a command
setopt auto_list            # automatically list choices on ambiguous completion
setopt auto_menu            # automatically use menu completion
setopt always_to_end        # move cursor to end if word had one match
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks   # remove superfluous blanks from history items
setopt inc_append_history   # save history entries as soon as they are entered
setopt share_history        # share history between different instances
#setopt correct_all          # autocorrect commands
setopt interactive_comments # allow comments in interactive shells

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit 

#typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
#if [ $(date +'%j') != $updated_at ]; then
#  compinit -i
#else
#  compinit -C -i
#fi
#zmodload -i zsh/complist

# Save history so we get auto suggestions
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

# Improve autocompletion style
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

#-----------------------------------------------------------------------------
# homebrew section 
#-----------------------------------------------------------------------------

eval "$(/opt/homebrew/bin/brew shellenv)"

#-----------------------------------------------------------------------------
# antidote section
# https://github.com/mattmc3/antidote
#-----------------------------------------------------------------------------

# Lazy-load antidote and generate the static load file only when needed
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  (
    source $HOMEBREW_PREFIX/opt/antidote/share/antidote/antidote.zsh
    antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
  )
fi
source ${zsh_plugins}.zsh

# Keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char

# Theme
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  terraform     # Terraform workspace section
  aws           # Amazon Web Services section
  gcloud        # Google Cloud Platform section
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "

# aws_env_helper <profile>
aws_env_helper () {
    readonly profile=${1:?"The aws profile must be specified."}
    export AWS_ACCESS_KEY_ID="$(aws configure get aws_access_key_id --profile $profile)"
    export AWS_SECRET_ACCESS_KEY="$(aws configure get aws_secret_access_key --profile $profile)"
    export AWS_SESSION_TOKEN="$(aws configure get aws_session_token --profile $profile)"
    export AWS_PROFILE=$profile
    export AWS_RETRY_MODE=adaptive
    export AWS_MAX_ATTEMPTS=10
}

# alias
alias externalip="curl checkip.amazonaws.com"
alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

