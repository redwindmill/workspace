#------------------------------------------------------------------- unix-like #
export EDITOR=vim
export VISUAL=vim
SHELL_SESSION_HISTORY=0
HISTFILESIZE=0
LESSHISTSIZE=0
SAVEHIST=0

#------------------------------------------------------------------------------#

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
# --color	- colorizes output (linux)
# -G		- colorizes output (osx)
# -F		- throws a / after a directory, * after an executeable, and a @ after a symlink
# -l		- long form list #permissions #hardlink num #owner #group #size #time #name
# -h		- human readable file sizes
if [ "$(uname -s)" = "Darwin" ]; then
	alias ls="ls -Fhl"
else
	alias ls="ls -Fhl --color"
fi

export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"

#util
alias jobs="jobs -l"

if [ "$(grep --color=auto 2>/dev/null)" ]; then
	alias grep="grep --color=auto"
	alias fgrep="fgrep --color=auto"
	alias egrep="egrep --color=auto"
fi

#------------------------------------------------------------------------------#

alias vnote="vim -c \"set foldmethod=indent\" -c \"set foldclose=all\""

#------------------------------------------------------------------------------#

dkr-vm() {
	case "${1}" in
	status)
		docker-machine status vm
		;;
	eval)
		eval $(docker-machine env vm)
		;;
	start)
		docker-machine start vm
		;;
	stop)
		docker-machine stop vm
		;;
	ssh)
		docker-machine ssh vm
		;;
	upg)
		docker-machine upgrade vm
		;;
	gen)
		docker-machine create --driver vmwarefusion vm
		;;
	*)
		echo "dkr-vm: <start/eval/stop/create> # manage docker vm on osx"
		;;
	esac
}

dkr-clean() {
	case "${1}" in
	vol)
		docker volume rm $(docker volume ls -qf dangling=true)
		;;
	img)
		docker rmi $(docker images -qf dangling=true)
		;;
	cnt)
		docker rm $(docker ps -qa)
		;;
	*)
		echo "dkr-clean: <vol/img/cnt> # remove dangling docker resources"
		;;
	esac
}

dkr-purge() {
	case "${1}" in
	vol)
		docker volume rm $(docker volume ls -q)
		;;
	img)
		docker rmi --force $(docker images -q)
		;;
	cnt)
		docker kill $(docker ps -q)
		docker rm --force $(docker ps -qa)
		;;
	*)
		echo "dkr-purge: <vol/img/cnt> # remove all docker resources"
		;;
	esac
}

dkr-cmd() {
	local CONTAINER_TYPE
	if [[ $(uname -m) == "arm"* ]]; then
		CONTAINER_TYPE="armhf/"
	fi

	case "${1}" in
	alpine)
		if [ "${2}" ]; then
			shift
			docker run --rm -it ${CONTAINER_TYPE}alpine sh -c "$*"
		else
			docker run --rm -it ${CONTAINER_TYPE}alpine sh
		fi
		;;
	ubuntu)
		if [ "${2}" ]; then
			shift
			docker run --rm -it ${CONTAINER_TYPE}ubuntu bash -c "$*"
		else
			docker run --rm -it ${CONTAINER_TYPE}ubuntu bash
		fi
		;;
	*)
		echo "dkr-cmd: <alpine/ubuntu> # launches a base linux docker container"
		;;
	esac
}

ssh-key() {
	case "${1}" in
	get)
		cat ~/.ssh/id_rsa.pub
		;;
	upd)
		ssh-keygen -p -f ~/.ssh/id_rsa
		;;
	gen)
		ssh-keygen -t rsa -b 4096 -C ""
		;;
	*)
		echo "ssh-key: <get/upd/gen> # manage ssh key"
		;;
	esac
}

killscreens () {
	screen -ls | \
	grep Detached | \
	cut -d. -f1 | \
	awk '{print $1}' | \
	xargs kill
}
