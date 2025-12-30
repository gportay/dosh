#
# $ZDOTDIR/.zshrc
#
# Commands are then read from $ZDOTDIR/.zshenv. If the shell is a login shell,
# commands are read from /etc/zsh/zprofile and then $ZDOTDIR/.zprofile. Then,
# if the shell is interac‐ tive, commands are read from /etc/zsh/zshrc and then
# $ZDOTDIR/.zshrc. Finally, if the shell is a login shell, /etc/zsh/zlogin and
# $ZDOTDIR/.zlogin are read.
#
# This is run by shell within the container

# zsh: can't rename .history.new to $HISTFILE
unsetopt HIST_SAVE_BY_COPY
