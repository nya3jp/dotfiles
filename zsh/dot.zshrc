# check environment

KERNEL="${$(uname)%%-*}"

SHORTHOST=`hostname -s`
if [[ -f /etc/vanity-hostname ]]; then
    SHORTHOST=`sed 's/\..*//g' < /etc/vanity-hostname`
fi
case "$SHORTHOST" in
dhcp*)
    SHORTHOST=mbp;;
esac


# fundamental and common settings

bindkey -e

HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000

setopt auto_list
setopt auto_param_slash
setopt complete_aliases
setopt extended_history
setopt hist_ignore_dups
setopt inc_append_history
setopt list_packed
setopt mark_dirs
setopt multios
setopt print_eight_bit
setopt share_history

setopt no_auto_menu
setopt no_auto_remove_slash
setopt no_flow_control
setopt no_list_beep


# common env settings

export LANG=en_US.UTF-8

export PATH=$HOME/local/sbin:$HOME/local/bin:/usr/sbin:/sbin:$PATH

find_first() {
    local p
    for command in "$@"; do
        p=`which "$command" 2> /dev/null`
        if [[ -x "$p" ]]; then
            echo "$p"
            break
        fi
    done
}

export EDITOR=$(find_first vim vi nano)
export PAGER=$(find_first lv less more)

case "$SHORTHOST" in
linnis)   PCOLOR=31;;
bardiche) PCOLOR="34;1";;
fate)     PCOLOR=37;;
mbp)      PCOLOR=36;;
rhxl)     PCOLOR=35;;
slb)      PCOLOR=32;;
yuno)     PCOLOR=0;;
snowfate) PCOLOR=37;;
alicia)   PCOLOR=36;;
*)        PCOLOR=35;;
esac

case "$TERM" in
dumb | emacs)
  PROMPT="%m:%1~> "
  PROMPT2="%m:%1~> "
  unsetopt zle
  ;;
*)
  PROMPT="[%{[${PCOLOR}m%}%n@${SHORTHOST} %{[33m%}%1~%{[0m%}]%# "
  PROMPT2="%_%# "
  ;;
esac

export LV=-c
export HGENCODING=utf-8
export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache


# alias

alias s='screen -DR main'
alias e='screen -c ~/.screenrc.emacs -DR emacs'
alias grep='grep --color=auto'

if [[ "$KERNEL" = "Linux" ]]; then
    alias ls='ls --color=tty'
fi


# completion

autoload -U compinit
compinit

zmodload -i zsh/mathfunc
zstyle ':completion:*' list-colors 'di=01;34' 'ln=01;36' 'so=01;35' 'ex=01;32' 'bd=01;33' 'cd=01;33' 'pi=01;33' 'su=01;37;41' 'sg=01;30;43' 'tw=01;30;42' 'ow=01;34;42'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
hosts=( ${(@)${${(M)${(s:# :)${(zj:# :)${(Lf)"$([[ -f ~/.ssh/config ]] && < ~/.ssh/config)"}%%\#*}}##host(|name) *}#host(|name) }/\*} )
zstyle ':completion:*:hosts' hosts $hosts


# process forwarded ssh-agent

agent="$HOME/.ssh_agent"
if [[ -S "$agent" ]]; then
    export SSH_AUTH_SOCK="$agent"
elif [[ -S "$SSH_AUTH_SOCK" ]]; then
    case "$SSH_AUTH_SOCK" in
    /tmp/*/agent.[0-9]*)
        ln -snf "$SSH_AUTH_SOCK" "$agent"
        export SSH_AUTH_SOCK="$agent"
        ;;
    esac
fi


# per-host settings

[ -f ~/.zshrc.personal ] && source ~/.zshrc.personal
[ -f ~/.zshrc.$SHORTHOST ] && source ~/.zshrc.$SHORTHOST
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
