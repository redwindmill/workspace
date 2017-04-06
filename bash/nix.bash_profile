#------------------------------------------------------------------- unix-like #
export EDITOR=vim
export VISUAL=vim
SHELL_SESSION_HISTORY=0
HISTFILESIZE=0
SAVEHIST=0

#'PS1'		- initial prompt string
#'[e[##m]h'	- colored 'host'
#'[e[##m]:'	- colored 'colon' separator
#'[e[##m]w'	- colored 'dictionary'
#'[e[##m]u'	- colored 'user'
#'[e[##m]$'	- colored '$'
export PS1="\[\e[1;32m\]\u@\h\[\e[00m\]:\[\e[1;33m\]\w\[\e[00m\]$ "
export CLICOLOR=1

#pretty/informative list directory overload
# perm		- [f-type][owner][group][everyone] #r read #w write #x execute #- none
# -G		- colorizes output
# -F		- throws a / after a directory, * after an executeable, and a @ after a symlink
# -l		- long form list #permissions #hardlink num #owner #group #size #time #name
# -h		- human readable file sizes
alias ls="ls -GFhl"
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"

alias jobs="jobs -l"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

alias vnote="vim -c \"set foldmethod=indent\" -c \"set foldclose=all\""
killscreens () { screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill ; }
