#------------------------------------------------------------------- unix-like #
export EDITOR=vim
export VISUAL=vim
export P4CONFIG=.p4config
export GPG_TTY=$(tty)

SHELL_SESSION_HISTORY=0
HISTFILESIZE=0
LESSHISTSIZE=0
SAVEHIST=0

# vars for .bashrc.local
#RED__HTTP_PROXY=""
#RED__HTTPS_PROXY=${RED__HTTP_PROXY}
#RED__ALL_PROXY=${RED__HTTP_PROXY}
#RED__FTP_PROXY=${RED__HTTP_PROXY}
#RED__SOCKS_PROXY=${RED__HTTP_PROXY}
#RED__NO_PROXY="localhost,127.0.0.1,${USERDNSDOMAIN}"
#RED__PROMPT_CLR_USR=<RED/GRN/BLU/YEL/GRY>
#RED__PROMPT_CLR_SYS=<RED/GRN/BLU/YEL/GRY>
#RED__MAIL_NEW_CMD=<CMD>
#------------------------------------------------------------------------------#

if [ "$(uname -s)" = "Darwin" ]; then
	export RED__KIND_OS="OSX"
elif [[ "$(uname -s)" == *"MINGW64"* ]]; then
	export RED__KIND_OS="WIN"
else
	export RED__KIND_OS="NIX"
fi

if [[ "$(uname -m)" == "arm"* ]]; then
	export RED__KIND_ARCH="ARM"
else
	export RED__KIND_ARCH="X86"
fi

if [[ "${TERM}" == "screen"* ]]; then
	if [ -z "${TMUX}" ]; then
		RED__KIND_TERM="SCREEN"
	else
		RED__KIND_TERM="TMUX"
	fi
else
	export RED__KIND_TERM="${TERM}"
fi

#------------------------------------------------------------------------------#

red__safe_path_add() {
	local RED__INPUT_OS="${1}"
	local RED__INPUT_MODE="${2}"
	local RED__INPUT_DIR="${3}"

	if [ "${RED__KIND_OS}" = "${RED__INPUT_OS}" ] \
		&& [ -d "${RED__INPUT_DIR}" ] \
		&& [[ ":${PATH}:" != *":${RED__INPUT_DIR}:"* ]]; then
		if [ "${RED__INPUT_MODE}" = "HEAD" ]; then
			export PATH="${RED__INPUT_DIR}:${PATH}"
		else
			export PATH="${PATH}:${RED__INPUT_DIR}"
		fi
	fi
}

red__source_if_exists() {
	if [ -f "${1}" ]; then
		source "${1}"
	fi
}

red__eval_if_exists() {
	if [ -f "${1}" ]; then
		eval $(${1} ${2})
	fi
}

#------------------------------------------------------------------------------#

alias jobs="jobs -l"
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"

#pretty/informative list directory overload
# perm		- [f-type][owner][group][everyone] #r read #w write #x execute #- none
# --color	- colorizes output (linux)
# -G		- colorizes output (osx)
# -F		- throws a / after a directory, * after an executable, and a @ after a symlink
# -l		- long form list #permissions #hardlink num #owner #group #size #time #name
# -h		- human readable file sizes
if [ "${RED__KIND_OS}" = "OSX" ]; then
	alias ls="ls -Fh"
else
	alias ls="ls -Fh --color"
fi

if [ "$(grep --color=auto 2>/dev/null)" ]; then
	alias grep="grep --color=auto"
	alias fgrep="fgrep --color=auto"
	alias egrep="egrep --color=auto"
fi

#------------------------------------------------------------------------------#

red__prompt_git_branch() {
	local RED__BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)
	if [ -z "${RED__BRANCH}" ]; then
		echo ""
	else
		echo "(${RED__BRANCH})"
	fi
}

red__prompt_color() {
	case "${1}" in
	RED)
		echo 31
		;;
	GRN)
		echo 32
		;;
	BLU)
		echo 36
		;;
	YEL)
		echo 33
		;;
	GRY)
		echo 90
		;;
	*)
		echo 32
		;;
	esac
}

red__prompt_cmd() {
	local EXIT_CODE="$?"
	local CLR_USR=$(red__prompt_color "${RED__PROMPT_CLR_USR}")
	local CLR_SYS=$(red__prompt_color "${RED__PROMPT_CLR_SYS}")

	PS1="\[\e[1;${CLR_USR}m\]\u"						#bold-color@user

	if [ "${RED__KIND_TERM}" != "TMUX" ] || [ ! -z "${SSH_CONNECTION}" ]; then
		PS1=$PS1"\[\e[0;37m\]@"							#white @
		PS1=$PS1"\[\e[0;${CLR_SYS}m\]\h"				#color@host
	fi

	PS1=$PS1"\[\e[0;37m\]:"								#white :
	PS1=$PS1"\[\e[1;33m\]\w"							#bold-yellow dir
	PS1=$PS1"\[\e[0;90m\]\$(red__prompt_git_branch)"	#grey git branch

	if [ "${EXIT_CODE}" -ne 0 ]; then
		PS1=$PS1"\[\e[1;31m\]$\[\e[00m\] "              #default end of prompt
	else
		PS1=$PS1"\[\e[00m\]$ "							#default end of prompt
	fi
}

PROMPT_COMMAND=red__prompt_cmd
export CLICOLOR=1

#------------------------------------------------------------------------------#

red-cmd() {
	echo "red-cmds: custom bash commands"
	echo "  red-rand-hex32  : returns a random 32 char hex string from /dev/urandom."
	echo "  red-json-esc    : escape stdin input so it is safe for json consumption."
	echo "  red-json-pretty : convert a json blob to be human readable."
	echo "  red-fzfp        : run fzf in preview mode."
	echo "  red-wt-gitstatus: run a watch on a brief git status"
	echo "  red-wt-newmail  : run a watch on a summary of new email messages"
	echo "  red-wt-ical     : run a watch on the ical-buddy events"
	echo ""

	local RED__HELP_CMDS=(
		"red__date_utc_help \"red-cmd\""
		"red__clip_help \"red-cmd\""
		"red__ssh_key_help \"red-cmd\""
		"red__crypt_help \"red-cmd\""
		"red__gpg_key_help \"red-cmd\""
		"red__proxy_help \"red-cmd\""
		"red__git_clean_help \"red-cmd\""
		"red__git_pull_help \"red-cmd\""
		"red__docker_clean_help \"red-cmd\""
		"red__docker_cmd_help \"red-cmd\""
	)

	for RED__HELP_CMD in "${RED__HELP_CMDS[@]}"; do
		eval "${RED__HELP_CMD}"
	done
}

red-rand-hex32() {
	hexdump -n 16 -ve '/1 "%02x"' /dev/urandom
}

red-json-esc() {
	python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

red-json-pretty() {
	python -m json.tool
}

red-fzfp() {
	fzf --preview="head -$LINES {}"
}

red-wt-gitstatus() {
	sleep "0.$(( RANDOM % 100 ))"
	if [ ! -e ".gitstatus" ]; then
		watch -tcn 3 ' \
			git remote get-url origin && \
			date && \
			git -c color.status=always status -sb --show-stash
		'
	else
		while true; do
			while read REPO; do
				clear
				REPO="${REPO/\~/${HOME}}"
				git -C "${REPO}" remote get-url origin
				date
				git -C "${REPO}" -c color.status=always status -sb --show-stash
				sleep 5
			done < .gitstatus
		done
	fi
}

red-wt-newmail() {
	sleep "0.$(( RANDOM % 100 ))"
	watch -tcn 3 " \
		${RED__MAIL_NEW_CMD} | \
		less
		"
}

red-wt-ical() {
	sleep "0.$(( RANDOM % 100 ))"
	watch -tcn 3 ' \
		icalbuddy -f -n -sd -nnc 64 -na 3 eventsToday+1 | \
		less
	'
}

#------------------------------------------------------------------------------#

red__date_utc_help() {
	if [ "${1}" = "red-cmd" ]; then
		local red__indent="  "
	else
		local red__indent=""
	fi

	echo "${red__indent}red-date-utc: print an iso-8601 utc timestamp."
	echo "${red__indent}red-date-utc:  red-date-utc [-h/-f/-e/--help]"

	if [ "${1}" != "red-cmd" ]; then
		echo "red-date-utc:  <empty> print the iso-8601 standard."
		echo "red-date-utc:  '-h' print a human readable form."
		echo "red-date-utc:  '-f' print a form usable in filenames."
		echo "red-date-utc:  '-e' print an epoch."
	fi

	echo ""
}

red-date-utc() {
	#iso-8601 utc timestamp
	case "${1}" in
	-h)
		date -u +"%Y-%m-%d %H:%M:%S %Z"
		;;
	-f)
		date -u +"%Y%m%d_%H%M%S_%Z"
		;;
	-e)
		date -u +"%s"
		;;
	--help)
		red__date_utc_help
		;;
	*)
		date -u +"%Y-%m-%dT%H:%M:%S%z"
		;;
	esac
}

#------------------------------------------------------------------------------#

red__ssh_key_help() {
	if [ "${1}" = "red-cmd" ]; then
		local red__indent="  "
	else
		local red__indent=""
	fi

	echo "${red__indent}red-ssh-key: manage your ssh key."
	echo "${red__indent}red-ssh-key:  red-ssh-key <show/upd-pwd/gen>"

	if [ "${1}" != "red-cmd" ]; then
		echo "red-ssh-key:  'show' outputs your public key."
		echo "red-ssh-key:  'upd-pwd' sets the password for your private key."
		echo "red-ssh-key:  'gen' generates a new ssh-key."
	fi

	echo ""
}

red-ssh-key() {
	case "${1}" in
	show)
		cat "${HOME}/.ssh/id_rsa.pub"
		;;
	upd-pwd)
		ssh-keygen -p -f "${HOME}/.ssh/id_rsa"
		;;
	gen)
		ssh-keygen -t rsa -b 4096 -C ""
		;;
	*)
		red__ssh_key_help
		;;
	esac
}

#------------------------------------------------------------------------------#

red__crypt_help() {
	if [ "${1}" = "red-cmd" ]; then
		local red__indent="  "
	else
		local red__indent=""
	fi

	echo "${red__indent}red-crypt: encrypt objects"
	echo "${red__indent}red-crypt:  red-crypt <sym/decrypt>"

	if [ "${1}" != "red-cmd" ]; then
		echo "red-crypt:  'sym' symmetric encryption."
		echo "red-crypt:  'decrypt' decrypts an encrypted file."
	fi

	echo ""
}

red-crypt() {
	case "${1}" in
	sym)
		shift
		gpg --armor --symmetric --cipher-algo TWOFISH "$@"
		;;
	decrypt)
		shift
		gpg -d "$@"
		;;
	*)
		red__crypt_help
		;;
	esac
}

#------------------------------------------------------------------------------#

red__gpg_key_help() {
	if [ "${1}" = "red-cmd" ]; then
		local red__indent="  "
	else
		local red__indent=""
	fi

	echo "${red__indent}red-gpg-key: manage your gpg key."
	echo "${red__indent}red-gpg-key:  red-gpg-key <show/upd-pwd/list/gen>"

	if [ "${1}" != "red-cmd" ]; then
		echo "red-gpg-key:  'show' outputs your public key for the specified key."
		echo "red-gpg-key:  'upd-pwd' sets the password for the specified key."
		echo "red-gpg-key:  'list' show the entries for your personal keys."
		echo "red-gpg-key:  'gen' generates a new gpg-key"
	fi

	echo ""
}

red-gpg-key() {
	case "${1}" in
	show)
		if [ -n "${2}" ]; then
			gpg --armor --export "${2}"
		else
			echo "red-gpg-key: you need to supply a sec-id. See 'list'"
		fi
		;;
	upd-pwd)
		if [ -n "${2}" ]; then
			gpg --edit-key "${2}"
		else
			echo "red-gpg-key: you need to supply a sec-id. See 'list'"
		fi
		;;
	list)
		gpg --list-secret-keys --keyid-format LONG
		;;
	gen)
		gpg --full-generate-key
		;;
	*)
		red__gpg_key_help
		;;
	esac
}

#------------------------------------------------------------------------------#

red__clip_copy () {
	if [ "${RED__KIND_OS}" = "OSX" ]; then
		eval "${1} | pbcopy"
	elif [ "${RED__KIND_OS}" = "WIN" ]; then
		eval "${1}" > /dev/clipboard
	else
		eval "${1} | xclip -selection clipboard"
	fi
}

red__clip_paste () {
	if [ "${RED__KIND_OS}" = "OSX" ]; then
		pbpaste
	elif [ "${RED__KIND_OS}" = "WIN" ]; then
		cat /dev/clipboard
	else
		xclip -selection clipboard -o
	fi
}

red__clip_help() {
	if [ "${1}" = "red-cmd" ]; then
		local RED__INDENT="  "
	else
		local RED__INDENT=""
	fi

	echo "${RED__INDENT}red-clip: copy into and out of the local clipboard."
	echo "${RED__INDENT}red-clip:  '.. | red-clip [-s])' '(red-clip [-s] | ..)'"

	if [ "${1}" != "red-cmd" ]; then
		echo "${RED__INDENT}red-clip:  '-s' strips newlines for copy and paste."
		echo "${RED__INDENT}red-clip:  '-d' (paste) run the result through dirname"
		echo "${RED__INDENT}red-clip:  '-b' (paste), run the result through basename"
	fi
	echo ""
}

red-clip () {
	case "${1}" in
	-s)
		local RED__CLIP_PASTE="red__clip_paste | tr -d '\n'"
		local RED__CLIP_COPY_PREFIX="cat | tr -d '\n'"
		;;
	-d)
		local RED__CLIP_PASTE="red__clip_paste | xargs dirname"
		local RED__CLIP_COPY_PREFIX="cat"
		;;
	-b)
		local RED__CLIP_PASTE="red__clip_paste | xargs basename"
		local RED__CLIP_COPY_PREFIX="cat"
		;;
	*)
		local RED__CLIP_PASTE="red__clip_paste"
		local RED__CLIP_COPY_PREFIX="cat"
		;;
	esac

	if [ -p /dev/stdin ]; then
		local RED__IS_STDIN_PIPE=1
	else
		local RED__IS_STDIN_PIPE=0
	fi

	if [ -t 0 ]; then
		local RED__IS_STDIN_TERM=1
	else
		local RED__IS_STDIN_TERM=0
	fi

	if [ -t 1 ]; then
		local RED__IS_STDOUT_TERM=1
	else
		local RED__IS_STDOUT_TERM=0
	fi

	if [ ${RED__IS_STDIN_PIPE} -eq 1 -o ${RED__IS_STDIN_TERM} -eq 0 ]; then
		red__clip_copy "${RED__CLIP_COPY_PREFIX}"
		if [ ${RED__IS_STDOUT_TERM} -eq 0 ]; then
			red__clip_paste
		fi
	else
		eval ${RED__CLIP_PASTE}
		if [ ${RED__IS_STDOUT_TERM} -eq 1 ]; then
			echo
		fi
	fi
}

#------------------------------------------------------------------------------#

red__git_pull_base() {
	case "${1}" in
	local-auto)
		if [ "${2}" == "real" ]; then
			git checkout master
			git pull
			git checkout "${1}"
			git rebase master
		else
			echo "red-git-pull: skipped (pull/rebase)"
		fi
		;;
	*)
		if [ "${2}" == "real" ]; then
			git pull
		else
			echo "red-git-pull: skipped (pull)"
		fi
		;;
	esac
}

red__git_pull_safe() {
	pushd "${1}" > /dev/null
	if [ -d ".git" ]; then
		local RED__GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)
		local RED__GIT_STATUS=$(git status --porcelain)
		echo "red-git-pull: getting latest on '${RED__GIT_BRANCH}' (${1})"
		if [ -z "${RED__GIT_STATUS}" ]; then
			red__git_pull_base ${RED__GIT_BRANCH} "${2}"
		else
			echo "red-git-pull: skipping, repository has local changes (${1})"
		fi
		echo
	fi
	popd > /dev/null
}

red__git_pull_recursive() {
	local RED__POSSIBLE_GIT_DIRS=$(\ls "${1}")
	for RED__POSSIBLE_GIT_DIR in ${RED__POSSIBLE_GIT_DIRS}; do
		if [ -d "${1}/${RED__POSSIBLE_GIT_DIR}" ]; then
			red__git_pull_safe "${1}/${RED__POSSIBLE_GIT_DIR}" "${2}"
		fi
	done
}

red__git_pull_status() {
	if [ ! -e "${1}/.gitstatus" ]; then
		red__git_pull_help "missing .gitstatus file"
		return 1
	else
		while read REPO; do
			REPO="${REPO/\~/${HOME}}"
			red__git_pull_safe "${1}/${REPO}" "${2}"
		done < "${1}/.gitstatus"
	fi
}

red__git_pull_help() {
	if [ "${1}" = "red-cmd" ]; then
		local RED__INDENT="  "
	else
		local RED__INDENT=""
		echo "red-git-pull: ERROR: ${1}"
	fi

	echo "${RED__INDENT}red-git-pull: helper for syncing git repositories."
	echo "${RED__INDENT}red-git-pull:  red-git-pull [-r][-s][--dry] <repo>"
	echo "${RED__INDENT}red-git-pull:  branches named 'local-auto' will automatically be rebased to master."

	if [ "${1}" != "red-cmd" ]; then
		echo "red-git-pull:  '-r' will search the specified folder for git repositories to pull."
		echo "red-git-pull:  '-s' will use a .gitstatus file in specified folder for git repositories to clean."
		echo "red-git-pull:  '--dry' will perform a dry run."
	fi

	echo ""
}

red-git-pull() {
	#parse args
	local RED__POSITIONAL=
	local RED__MODE="normal"
	local RED__RUN_TYPE="real"

	while [ $# -gt 0 ]; do
		local RED__KEY="${1}"
		case ${RED__KEY} in
		-r)
			local RED__MODE="recursive"
			shift
			;;
		-s)
			local RED__MODE="status"
			shift
			;;
		--dry)
			local RED__RUN_TYPE="dry"
			shift
			;;
		*)
			local RED__POSITIONAL="${1}"
			shift
			;;
		esac
	done

	if [ -z "${RED__POSITIONAL}" ]; then
		RED__POSITIONAL="."
	fi

	if [ ! -d "${RED__POSITIONAL}" ]; then
		red__git_pull_help "invalid directory"
		return 1
	fi

	if [ "${RED__MODE}" = "status" ]; then
		red__git_pull_status "${RED__POSITIONAL}" "${RED__RUN_TYPE}"
	elif [ "${RED__MODE}" = "recursive" ]; then
		red__git_pull_recursive "${RED__POSITIONAL}" "${RED__RUN_TYPE}"
	else
		red__git_pull_safe "${RED__POSITIONAL}" "${RED__RUN_TYPE}"
	fi
}

#------------------------------------------------------------------------------#

red__git_clean_safe() {
	pushd "${1}" > /dev/null
	if [ -d ".git" ]; then
		echo "red-git-clean: running maintenance on '${1}'"
		if [ "${2}" == "real" ]; then
			git remote prune origin
			git gc --prune
			git repack -ad
			echo
		else
			echo "red-git-clean: skipped (clean)"
		fi
	fi
	popd > /dev/null
}

red__git_clean_recursive() {
	local RED__POSSIBLE_GIT_DIRS=$(\ls "${1}")
	for RED__POSSIBLE_GIT_DIR in ${RED__POSSIBLE_GIT_DIRS}; do
		if [ -d "${1}/${RED__POSSIBLE_GIT_DIR}" ]; then
			red__git_clean_safe "${1}/${RED__POSSIBLE_GIT_DIR}" "${2}"
		fi
	done
}

red__git_clean_status() {
	if [ ! -e "${1}/.gitstatus" ]; then
		red__git_pull_help "missing .gitstatus file"
		return 1
	else
		while read REPO; do
			REPO="${REPO/\~/${HOME}}"
			red__git_clean_safe "${1}/${REPO}" "${2}"
		done < "${1}/.gitstatus"
	fi
}

red__git_clean_help() {
	if [ "${1}" = "red-cmd" ]; then
		local RED__INDENT="  "
	else
		local RED__INDENT=""
		echo "red-git-clean: ERROR: ${1}"
	fi

	echo "${RED__INDENT}red-git-clean: helper for cleaning git repositories."
	echo "${RED__INDENT}red-git-clean:  red-git-clean [-r][-s] <repo>"

	if [ "${1}" != "red-cmd" ]; then
		echo "red-git-clean:  '-r' will search the specified folder for git repositories to clean."
		echo "red-git-clean:  '-s' will use a .gitstatus file in specified folder for git repositories to clean."
	fi

	echo ""
}

red-git-clean() {
	#parse args
	local RED__POSITIONAL=
	local RED__MODE="normal"
	local RED__RUN_TYPE="real"

	while [ $# -gt 0 ]; do
		local RED__KEY="${1}"
		case ${RED__KEY} in
		-r)
			local RED__MODE="recursive"
			shift
			;;
		-s)
			local RED__MODE="status"
			shift
			;;
		--dry)
			local RED__RUN_TYPE="dry"
			shift
			;;
		*)
			local RED__POSITIONAL="${1}"
			shift
			;;
		esac
	done

	if [ -z "${RED__POSITIONAL}" ]; then
		RED__POSITIONAL="."
	fi

	if [ ! -d "${RED__POSITIONAL}" ]; then
		red__git_clean_help "invalid directory"
		return 1
	fi

	if [ "${RED__MODE}" = "status" ]; then
		red__git_clean_status "${RED__POSITIONAL}" "${RED__RUN_TYPE}"
	elif [ "${RED__MODE}" == "recursive" ]; then
		red__git_clean_recursive "${RED__POSITIONAL}" "${RED__RUN_TYPE}"
	else
		red__git_clean_safe "${RED__POSITIONAL}" "${RED__RUN_TYPE}"
	fi
}

#------------------------------------------------------------------------------#

red__docker_clean_help() {
	if [ "${1}" = "red-cmd" ]; then
		local RED__INDENT="  "
	else
		local RED__INDENT=""
	fi

	echo "${RED__INDENT}red-docker-clean: clean up dangling docker resources."
	echo "${RED__INDENT}red-docker-clean:  red-docker-clean [--purge] <vol/img/cnt/all/net>"
	echo "${RED__INDENT}red-docker-clean:  net command does not support purge."

	if [ "${1}" != "red-cmd" ]; then
		echo "red-docker-clean:  'bld' prunes docker builder"
		echo "red-docker-clean:  'vol' prunes docker volumes."
		echo "red-docker-clean:  'img' prunes docker images."
		echo "red-docker-clean:  'cnt' prunes docker containers."
		echo "red-docker-clean:  'all' prunes the docker system (including volumes)."
		echo "red-docker-clean:  '--purge' aggressively remove a docker resource based on the command."
		echo "red-docker-clean:  'net' prunes docker networks; no purge option available."
	fi

	echo ""
}

red-docker-clean() {
	local RED__IS_PURGE=0
	local RED__DOCKER_CMD=""
	while [ $# -gt 0 ]; do
		case "${1}" in
		--purge)
			RED__IS_PURGE=1
			shift
			;;
		*)
			RED__DOCKER_CMD="${1}"
			shift
			;;
		esac
	done

	case "${RED__DOCKER_CMD}" in
	bld)
		if [ ${RED__IS_PURGE} -eq 0 ]; then
			echo "red-docker-clean: pruning builder"
			docker builder prune -f
		else
			echo "red-docker-clean: purging builder"
			docker builder prune --all -f
		fi
		;;
	vol)
		if [ ${RED__IS_PURGE} -eq 0 ]; then
			echo "red-docker-clean: pruning volumes"
			docker volume prune -f
		else
			echo "red-docker-clean: purging volumes"
			docker volume rm $(docker volume ls -q)
		fi
		;;
	img)
		if [ ${RED__IS_PURGE} -eq 0 ]; then
			echo "red-docker-clean: pruning images"
			docker image prune --all -f
		else
			echo "red-docker-clean: purging images"
			docker rmi --force $(docker images -q)
		fi
		;;
	cnt)
		if [ ${RED__IS_PURGE} -eq 0 ]; then
			echo "red-docker-clean: pruning containers"
			docker container prune -f
		else
			echo "red-docker-clean: purging containers"
			docker rm --force $(docker ps -qa)
		fi
		;;
	net)
		echo "red-docker-clean: pruning networks"
		docker network prune -f
		;;
	all)
		if [ ${RED__IS_PURGE} -eq 0 ]; then
			echo "red-docker-clean: pruning containers, images and volumes"
			docker builder prune -f
			docker system prune --volumes -f
		else
			echo "red-docker-clean: purging containers, images and volumes"
			docker kill $(docker ps -q)
			docker rm --force $(docker ps -qa)
			docker rmi --force $(docker images -q)
			docker volume rm $(docker volume ls -q)
			docker builder prune --all -f
		fi
		;;
	*)
		red__docker_clean_help
		;;
	esac
}

#------------------------------------------------------------------------------#

red__docker_cmd_help() {
	if [ "${1}" = "red-cmd" ]; then
		local RED__INDENT="  "
	else
		local RED__INDENT=""
	fi

	echo "${RED__INDENT}red-docker-cmd: launches a base linux docker container."
	echo "${RED__INDENT}red-docker-cmd:  <alpine/ubuntu> *"
	echo ""
}

red-docker-cmd() {
	local CONTAINER_TYPE
	if [ "${RED__KIND_ARCH}" = "ARM" ]; then
		CONTAINER_TYPE="arm32v6/"
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
		red__docker_cmd_help
		;;
	esac
}

#------------------------------------------------------------------------------#

red__proxy_help() {
	if [ "${1}" = "red-cmd" ]; then
		local RED__INDENT="  "
	else
		local RED__INDENT=""
	fi

	echo "${RED__INDENT}red-proxy: set and unset terminal proxy settings."
	echo "${RED__INDENT}red-proxy:  red-proxy <set/unset>"

	if [ "${1}" != "red-cmd" ]; then
		echo "red-proxy:  RED__HTTP_PROXY=${RED__HTTP_PROXY}"
		echo "red-proxy:  RED__HTTPS_PROXY=${RED__HTTPS_PROXY}"
		echo "red-proxy:  RED__FTP_PROXY=${RED__FTP_PROXY}"
		echo "red-proxy:  RED__SOCKS_PROXY=${RED__SOCKS_PROXY}"
		echo "red-proxy:  RED__NO_PROXY=${RED__NO_PROXY}"
	fi

	echo ""
}

red-proxy() {
	case "${1}" in
	set)
		[ -n "${RED__ALL_PROXY}" ]		&& export {ALL_PROXY,all_proxy}=${RED__ALL_PROXY}
		[ -n "${RED__FTP_PROXY}" ]		&& export {FTP_PROXY,ftp_proxy}=${RED__FTP_PROXY}
		[ -n "${RED__HTTPS_PROXY}" ]	&& export {HTTPS_PROXY,https_proxy}=${RED__HTTPS_PROXY}
		[ -n "${RED__HTTP_PROXY}" ]		&& export {HTTP_PROXY,http_proxy}=${RED__HTTP_PROXY}
		[ -n "${RED__NO_PROXY}" ]		&& export {NO_PROXY,no_proxy}=${RED__NO_PROXY}
		[ -n "${RED__SOCKS_PROXY}" ]	&& export {SOCKS_PROXY,socks_proxy}=${RED__SOCKS_PROXY}
		;;
	unset)
		unset {ALL_PROXY,all_proxy}
		unset {FTP_PROXY,ftp_proxy}
		unset {HTTPS_PROXY,https_proxy}
		unset {HTTP_PROXY,http_proxy}
		unset {NO_PROXY,no_proxy}
		unset {SOCKS_PROXY,socks_proxy}
		;;
	*)
		red__proxy_help "cmd"
		;;
	esac
}

#------------------------------------------------------------------------------#

[ "${RED__KIND_OS}" = "OSX" ] && red__source_if_exists "/opt/homebrew/etc/bash_completion"
[ "${RED__KIND_OS}" = "OSX" ] && red__eval_if_exists "/opt/homebrew/bin/brew" "shellenv"

red__safe_path_add "OSX" "HEAD" "/opt/homebrew/opt/curl/bin"				#brew curl
red__safe_path_add "OSX" "HEAD" "/opt/homebrew/opt/python/libexec/bin"		#brew python
red__safe_path_add "OSX" "HEAD" "/opt/homebrew/opt/make/libexec/gnubin"	#brew make
red__safe_path_add "OSX" "HEAD" "/opt/homebrew/opt/grep/libexec/gnubin"	#brew grep

#------------------------------------------------------------------------------#

[ "${RED__KIND_OS}" = "NIX" ] && red__eval_if_exists "/home/linuxbrew/.linuxbrew/bin/brew" "shellenv"
[ "${RED__KIND_OS}" = "NIX" ] && red__source_if_exists "/home/linuxbrew/.linuxbrew/etc/profile.d/bash_completion.sh"

#------------------------------------------------------------------------------#

[ -f "${HOME}/.fzf.bash" ] && mv "${HOME}/.fzf.bash" "${HOME}/.bashrc.fzf"

red__safe_path_add "${RED__KIND_OS}" "TAIL" "${HOME}/bin"	#local bins
red__safe_path_add "${RED__KIND_OS}" "TAIL" "${HOME}/go/bin"	#go bins

red__source_if_exists "${HOME}/.bashrc.local"
red__source_if_exists "${HOME}/.bashrc.fzf"
red__source_if_exists "${HOME}/.bashrc.git"
