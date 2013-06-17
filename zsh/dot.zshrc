# check kernel and terminal

KERNEL=unknown
[ -x /usr/bin/uname ] && KERNEL=`/usr/bin/uname`
[ -x /bin/uname ] && KERNEL=`/bin/uname`

KERNEL="${KERNEL%%-*}"
SHORTHOST=`hostname -s`

if [ -f /etc/vanity-hostname ]; then
    SHORTHOST=`sed 's/\..*//g' < /etc/vanity-hostname`
fi

case "$SHORTHOST" in
dhcp*)
    SHORTHOST=mbp;;
esac

case "$SHORTHOST" in
linnis)   PCOLOR=31;;
bardiche) PCOLOR="34;1";;
fate)     PCOLOR=36;;
mbp)      PCOLOR=36;;
rhxl)     PCOLOR=35;;
slb)      PCOLOR=32;;
yuno)     PCOLOR=0;;
snowfate) PCOLOR=37;;
alicia)   PCOLOR=36;;
*)        PCOLOR=35;;
esac

case "$KERNEL" in
Linux|FreeBSD|Darwin)
    PROMPT="[%{[${PCOLOR}m%}%n@${SHORTHOST} %{[33m%}%1~%{[0m%}]%# "
    PROMPT2="%_%# "
    ;;
*)
    PROMPT="[%n@${SHORTHOST} %1~]%# "
    PROMPT2="%_%# "
    export TERM=vt100
    ;;
esac

[[ "$EMACS" = t ]] && unsetopt zle
case "$TERM" in
dumb | emacs)
  PROMPT="%m:%1~> "
  PROMPT2="%m:%1~> "
  unsetopt zle
  ;;
esac


# fundamental and common settings

bindkey -e

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt hist_ignore_dups
setopt auto_cd
setopt auto_pushd
setopt nolistbeep
setopt multios
setopt complete_aliases
setopt noautoremoveslash
setopt auto_param_slash
setopt auto_list
setopt no_auto_menu
setopt magic_equal_subst
setopt print_eight_bit
setopt no_flow_control
setopt mark_dirs


# linux only

if [ "$KERNEL" = Linux ] || [ "$KERNEL" = FreeBSD ] || [ "$KERNEL" = CYGWIN ]; then
    setopt share_history
    autoload -U compinit
    if [ "$KERNEL" = Linux ] || [ "$KERNEL" = FreeBSD ]; then
        compinit
    else
        compinit -u
    fi
    setopt list_packed
    zmodload -i zsh/mathfunc
    
    zstyle ':completion:*' list-colors 'di=01;34' 'ln=01;36' 'so=01;35' 'ex=01;32' 'bd=01;33' 'cd=01;33' 'pi=01;33' 'su=01;37;41' 'sg=01;30;43' 'tw=01;30;42' 'ow=01;34;42'
    
    zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
    
    hosts=( ${(@)${${(M)${(s:# :)${(zj:# :)${(Lf)"$([[ -f ~/.ssh/config ]] && < ~/.ssh/config)"}%%\#*}}##host(|name) *}#host(|name) }/\*} )
    zstyle ':completion:*:hosts' hosts $hosts

    # dabbrev
    HARDCOPYFILE=$HOME/.tmp.screen
    touch $HARDCOPYFILE
    
    dabbrev-complete () {
        local reply lines=80 # 80行分
        screen -X hardcopy -h "$HARDCOPYFILE"
        reply=($(sed '/^$/d' $HARDCOPYFILE | sed '$ d' | tail -$lines))
        compadd - "${reply[@]%[*/=@|]}"
        rm -f "$HARDCOPYFILE"
    }
    
    zle -C dabbrev-complete menu-complete dabbrev-complete
    bindkey '^[/' dabbrev-complete

fi


# process forwarded ssh-agent

agent="$HOME/.ssh_agent"
if [ -S "$agent" ]; then
    export SSH_AUTH_SOCK="$agent"
elif [ -S "$SSH_AUTH_SOCK" ]; then
    case "$SSH_AUTH_SOCK" in
    /tmp/*/agent.[0-9]*)
        ln -snf "$SSH_AUTH_SOCK" "$agent"
        export SSH_AUTH_SOCK="$agent"
        ;;
    esac
fi


# common env settings
    
export PATH=$HOME/local/sbin:$HOME/local/bin:/usr/sbin:/sbin:$PATH

if [ "$KERNEL" = "Darwin" ]; then
    export PATH=/opt/local/bin:$PATH
    export MAXPATH=/opt/local/man:$MANPATH
fi

EDITOR=/usr/bin/vim
if ! [ -e "$EDITOR" ]; then EDITOR=/usr/bin/vi; fi
if ! [ -e "$EDITOR" ]; then EDITOR=vi; fi
export EDITOR

PAGER=/usr/bin/lv
if ! [ -e "$PAGER" ]; then PAGER=/usr/bin/less; fi
if ! [ -e "$PAGER" ]; then PAGER=/usr/bin/more; fi
if ! [ -e "$PAGER" ]; then PAGER=more; fi
export PAGER


# alias

alias ls='ls --color=tty'
alias ll='ls -l'
alias la='ll -A'
alias xd='od -t xCz -A x'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias s='screen -DR main'
alias e='screen -c ~/.screenrc.emacs -DR emacs'
alias cl='xclip -selection clipboard'
alias grep='grep --color=auto'

case "$KERNEL" in
Linux)
    export LANG=ja_JP.UTF-8
    export LC_MESSAGES=en_US.UTF-8
    ;;
CYGWIN)
    alias ls='ls --show-control-chars --color=tty'
    export LANG=C
    export OUTPUT_CHARSET=SJIS
    ;;
*)
    alias ls='ls'
    ;;
esac

# hg

export HGENCODING=utf-8


# per-host settings

[ -f ~/.zshrc.personal ] && source ~/.zshrc.personal
[ -f ~/.zshrc.$SHORTHOST ] && source ~/.zshrc.$SHORTHOST
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

