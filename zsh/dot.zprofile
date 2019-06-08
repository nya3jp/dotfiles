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


# common env settings

export LANG=en_US.UTF-8

export PATH=$HOME/local/bin:$HOME/.local/bin:/usr/sbin:/sbin:$PATH

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

export LV=-c
export HGENCODING=utf-8
export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache


# process forwarded ssh-agent

agent="$HOME/.ssh_agent"
if [[ -S "$agent" ]]; then
    export SSH_AUTH_SOCK="$agent"
elif [[ -S "$SSH_AUTH_SOCK" ]]; then
        ln -snf "$SSH_AUTH_SOCK" "$agent"
        export SSH_AUTH_SOCK="$agent"
        ;;
    esac
fi


# per-host settings

[ -f ~/.zprofile.personal ] && source ~/.zprofile.personal
[ -f ~/.zprofile.$SHORTHOST ] && source ~/.zprofile.$SHORTHOST
[ -f ~/.zprofile.local ] && source ~/.zprofile.local
