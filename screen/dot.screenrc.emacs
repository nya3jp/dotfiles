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

bind "<" eval "exec xclip -selection clipboard -out '$HOME/.clip.screen'" "readbuf '$HOME/.clip.screen'" "exec rm '$HOME/.clip.screen'"
bind ">" eval "writebuf '$HOME/.clip.screen'" "exec xclip -selection clipboard -in '$HOME/.clip.screen'" "exec rm '$HOME/.clip.screen'"

msgminwait 0
msgwait 0

screen -t "***emacs-only***" emacs -nw
