# Detect the environment.
SHORTHOST="$(hostname -s)"
if [[ -f "/etc/vanity-hostname" ]]; then
  SHORTHOST="$(sed 's/\..*//g' /etc/vanity-hostname)"
fi

# Set up PATH.
export PATH="/usr/sbin:/sbin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/local/depot_tools:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Common env settings.
find_first() {
  local p
  for command in "$@"; do
    p="$(which "$command" 2> /dev/null)"
    if [[ -x "$p" ]]; then
      echo "$p"
      break
    fi
  done
}

export EDITOR=$(find_first vim vi nano)
export GOPATH="$HOME/go"
export HGENCODING=utf-8
export LANG=en_US.UTF-8
export LV=-c
export PAGER=$(find_first lv less more)
export PIP_DOWNLOAD_CACHE=$HOME/.cache/pip

# Include per-host settings.
[[ -f "$HOME/.zprofile.personal" ]] && source "$HOME/.zprofile.personal"
[[ -f "$HOME/.zprofile.$SHORTHOST" ]] && source "$HOME/.zprofile.$SHORTHOST"
[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
