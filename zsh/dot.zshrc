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
anz)      PCOLOR=37;;
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


# alias

alias s='screen -DR main'
alias e='screen -c ~/.screenrc.emacs -DR emacs'
alias grep='grep --color=auto'
alias sort='LC_ALL=C sort'

case "$KERNEL" in
Linux)
    alias ls='ls --color=tty'
    ;;
Darwin)
    alias ls='ls -G'
    ;;
esac


# completion

autoload -U compinit
compinit

zmodload -i zsh/mathfunc
zstyle ':completion:*' list-colors 'di=01;34' 'ln=01;36' 'so=01;35' 'ex=01;32' 'bd=01;33' 'cd=01;33' 'pi=01;33' 'su=01;37;41' 'sg=01;30;43' 'tw=01;30;42' 'ow=01;34;42'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
hosts=( ${(@)${${(M)${(s:# :)${(zj:# :)${(Lf)"$([[ -f ~/.ssh/config ]] && < ~/.ssh/config)"}%%\#*}}##host(|name) *}#host(|name) }/\*} )
zstyle ':completion:*:hosts' hosts $hosts


# per-host settings

[ -f ~/.zshrc.personal ] && source ~/.zshrc.personal
[ -f ~/.zshrc.$SHORTHOST ] && source ~/.zshrc.$SHORTHOST
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
