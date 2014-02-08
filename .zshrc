# Path to your oh-my-zsh configuration.
ZSH=$HOME/.config/oh-my-zsh

if [ -d $ZSH ];
then

  echo "Using Oh-My-Zsh..."

  # Set name of the theme to load.
  # Look in ~/.oh-my-zsh/themes/
  # Optionally, if you set this to "random", it'll load a random theme each
  # time that oh-my-zsh is loaded.
  ZSH_THEME="re5et"

  # Example aliases
  # alias zshconfig="mate ~/.zshrc"
  # alias ohmyzsh="mate ~/.oh-my-zsh"

  # Set to this to use case-sensitive completion
  # CASE_SENSITIVE="true"

  # Uncomment this to disable bi-weekly auto-update checks
  # DISABLE_AUTO_UPDATE="true"

  # Uncomment to change how often before auto-updates occur? (in days)
  # export UPDATE_ZSH_DAYS=13

  # Uncomment following line if you want to disable colors in ls
  # DISABLE_LS_COLORS="true"

  # Uncomment following line if you want to disable autosetting terminal title.
  # DISABLE_AUTO_TITLE="true"

  # Uncomment following line if you want to disable command autocorrection
  # DISABLE_CORRECTION="true"

  # Uncomment following line if you want red dots to be displayed while waiting for completion
  # COMPLETION_WAITING_DOTS="true"

  # Uncomment following line if you want to disable marking untracked files under
  # VCS as dirty. This makes repository status check for large repositories much,
  # much faster.
  # DISABLE_UNTRACKED_FILES_DIRTY="true"

  # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
  # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  plugins=(git screen debian yum systemd rsync repo)

  source $ZSH/oh-my-zsh.sh
else
  echo "Using failsafe..."
  source $HOME/.zshrc_failsafe
fi

# Customize to your needs...
#

alias sudo="nocorrect sudo"
alias vless='vim -u /usr/share/vim/vim74/macros/less.vim'

hash -d mr=$HOME/.config/mr

foreach dotfile (/etc/zsh/local ~/.zshrc.local ~/.zshrc.$HOST ~/.zshrc.$USER); do
  if [[ -r $dotfile ]]; then; echo "Sourcing $dotfile"; source $dotfile; fi
done

#
#
#
# run command line as user root via sudo:
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER != sudo\ * ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR+5 ))
    fi
}
zle -N sudo-command-line

function zrcgotwidget() {
    (( ${+widgets[$1]} ))
}

function zrcbindkey() {
    if (( ARGC )) && zrcgotwidget ${argv[-1]}; then
        bindkey "$@"
    fi
}

function bind2maps () {
    local i sequence widget
    local -a maps

    while [[ "$1" != "--" ]]; do
        maps+=( "$1" )
        shift
    done
    shift

    if [[ "$1" == "-s" ]]; then
        shift
        sequence="$1"
    else
        sequence="${key[$1]}"
    fi
    widget="$2"

    [[ -z "$sequence" ]] && return 1

    for i in "${maps[@]}"; do
        zrcbindkey -M "$i" "$sequence" "$widget"
    done
}

bind2maps emacs viins       -- -s "^os" sudo-command-line
