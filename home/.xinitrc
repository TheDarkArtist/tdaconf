export PICOM_VSYNC=true
export PICOM_BACKEND="glx"
export TERMINAL=alacritty

xset +dpms

# Source xprofile for environment variables
[ -f ~/.xprofile ] && . ~/.xprofile

exec i3

