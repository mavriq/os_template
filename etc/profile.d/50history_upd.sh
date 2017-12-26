#
# update bash history options
#

case $- in
    *i*) 
        # don't put duplicate lines or lines starting with space in the history.
        : ${HISTCONTROL:=ignoreboth}

        # append to the history file, don't overwrite it
        shopt -s histappend

        # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
        : ${HISTSIZE:=10000}
        : ${HISTFILESIZE=200000}

        : ${HISTTIMEFORMAT:="%Y-%m-%d %T $(
            [[ "$UID" -eq "0" ]] && echo "#" || echo "$") "}
        ;;
      *);;
esac

