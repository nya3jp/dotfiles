escape ^z^z
bind ^g
bind f
bind ^f
vbell off
autodetach on
backtick 1 0 0 id -un
hardstatus alwayslastline "%{= bw}%02c%{-}  %-w%{=u kw} %n %t %{-}%+w %=%1`@%H"
startup_message off
defscrollback 10
defbce on
defflow off
term xterm-256color

# Enable 256color support in precise
# http://robotsrule.us/vim/
attrcolor b ".I"
termcapinfo xterm 'Co#256:AB=\E[48;5;%dm:AF=\E[38;5;%dm'

msgminwait 0
msgwait 0

screen -t "***emacs-only***" emacs -nw
