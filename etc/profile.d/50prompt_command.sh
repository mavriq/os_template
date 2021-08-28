#
# update PROMPT_COMMAND if necessary
#

case $- in
    *i*) 

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

export PROMPT_COMMAND=_pc
_pc(){
    local RETURN_CODE="$?"

    local color_off='\[\033[0m\]'       # disable color
    local color_user='\[\033[0;33m\]'   # brown/orange
    local color_line='\[\033[1;30m\]'   # light gray
    local color_host='\[\033[1;34m\]'   # light blue
    local color_lred='\[\033[1;31m\]'   # light red
    local color_green='\[\033[1;32m\]'  # green

    # set return code color
    local RC_COLOR="${color_lred}"
    if [[ "$RETURN_CODE" == "0" ]]; then
        RC_COLOR="${color_green}"
    fi

    # set pwd home prefix
    local PWDNAME="$PWD"
    if [[ "$HOME" == "$PWD" ]]; then
        PWDNAME="~"
    else
        if [[ "$HOME" == "${PWD:0:${#HOME}}" ]]; then
            PWDNAME="~${PWD:${#HOME}}"
        fi
    fi

    # detect if root and set color
    local USER_TYPE="$color_green"
    if [[ "$UID" -eq "0" ]]; then
        USER_TYPE="$color_lred"
    fi

    local LINE_LEN=$(( 
        $COLUMNS - ${#USER} - ${#HOSTNAME} - ${#PWDNAME} - ${#RETURN_CODE} - 4
    ))
    local now_len=20
    local now=''
    if [ ${LINE_LEN} -gt ${now_len} ]; then
        now=$( date '+%Y-%m-%d %T' 2>/dev/null || echo '' )
        if [ ${#now} -gt 0 ]; then
            now=" ${color_user}${now}${color_off}"
            LINE_LEN=$(( LINE_LEN - now_len ))
        fi
    fi
    local FILL_LINE=$(printf '─%.0s' $(eval echo {1..$LINE_LEN}))

    PS1="${color_user}\u${color_off}@\
${color_host}${HOSTNAME}${color_off}:\
${PWDNAME} \
${color_line}${FILL_LINE}${color_off}\
${now} \
${RC_COLOR}${RETURN_CODE}${color_off}\n\
${USER_TYPE}➜$color_off ";

    local get_cursor_pos='\033[6n'      # ask term for the cursor position
    # local _garbage                      # env for first part of the response
    local CURPOS                        # env for cursor position
    __cp() {
        local CURPOS                        # env for cursor position
        echo -n ''          # delay
        echo -en "\033[6n"  # send esc to get cursor position
        read -rsdR CURPOS   # read cursor position
        CURPOS="${CURPOS##*;}"
        return "${CURPOS}"
    }
    __cp
    CURPOS=$?
    unset __cp

    local color_error='\033[41;37m'
    local color_error_off='\033[m\017'

    [[ ${CURPOS} -gt 1 ]] && printf "${color_error}↵${color_error_off}\n"
}

    ;;
      *);;
esac

