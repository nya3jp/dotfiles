# Detect the environment.
SHORTHOST="$(hostname -s)"
if [[ -f "/etc/vanity-hostname" ]]; then
  SHORTHOST="$(sed 's/\..*//g' /etc/vanity-hostname)"
fi
KERNEL="${$(uname)%%-*}"

# Basic shell settings.
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

# Prompt settings.
case "$KERNEL.$SHORTHOST" in
Darwin.*) PCOLOR="15";;  # white
*.linnis) PCOLOR="1";;   # red
*.haruna) PCOLOR="219";; # pink
*.ajisai) PCOLOR="14";;  # cyan
*.sena)   PCOLOR="21";;  # blue
*)        PCOLOR="11";;  # yellow
esac

PROMPT="[%{[38;5;${PCOLOR}m%}%n@${SHORTHOST} %{[33m%}%1~%{[0m%}]%# "
PROMPT2="%_%# "

# Define aliases.
alias s='screen -DR main'
alias grep='grep --color=auto'
alias sort='LC_ALL=C sort'

case "$KERNEL" in
Linux)  alias ls='ls --color=tty';;
Darwin) alias ls='ls -G';;
esac

# Set up completion.
autoload -U compinit
compinit
zmodload -i zsh/mathfunc
zstyle ':completion:*' list-colors 'di=01;34' 'ln=01;36' 'so=01;35' 'ex=01;32' 'bd=01;33' 'cd=01;33' 'pi=01;33' 'su=01;37;41' 'sg=01;30;43' 'tw=01;30;42' 'ow=01;34;42'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
hosts=( ${(@)${${(M)${(s:# :)${(zj:# :)${(Lf)"$([[ -f ~/.ssh/config ]] && < ~/.ssh/config)"}%%\#*}}##host(|name) *}#host(|name) }/\*} )
zstyle ':completion:*:hosts' hosts $hosts

# Include per-host settings.
[[ -f "$HOME/.zshrc.personal" ]] && source "$HOME/.zshrc.personal"
[[ -f "$HOME/.zshrc.$SHORTHOST" ]] && source "$HOME/.zshrc.$SHORTHOST"
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
