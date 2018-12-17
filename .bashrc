#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH="/usr/local/opt/cross/bin:$PATH"

export VIRTUAL_ENV_DISABLE_PROMPT=1

PS1="\[\033[38;5;3m\]┌─[\u@\h] \[\033[38;5;2m\]\W\[\033[38;5;1m\]\$(get_git_branch)\n\
\[\033[38;5;3m\]└─╼ $\[\033[0m\]\$(get_virtualenv) "

alias ls='ls --color=auto'
alias gdf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

stty -ixon

if [ -t 1 ]; then
    bind '"\C-f"':shell-forward-word
    bind '"\C-b"':shell-backward-word
    bind '"\C-d"':shell-kill-word
fi

function get_git_branch() {
    if git --version &> /dev/null; then
        ref="$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')"
        if [[ "$ref" != "" ]]; then
            echo " :$ref:"
        fi
    fi
}

function get_virtualenv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo " (${VIRTUAL_ENV##*/})"
    fi
}
