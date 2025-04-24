function enshort() {
    local input="${1//[-_]/}" # removes - and _
    input="${input:l}"        # lowercase
    local maxlen=10
    if ((${#input} > maxlen)); then
        echo "${input[1, $maxlen]}"
    else
        echo "$input"
    fi
}

function precmd() {
    SHORT_HOST=$(enshort "$(print -P %m)")
}

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}x"
ZSH_THEME_GIT_PROMPT_CLEAN="" #" %{$fg[green]%}✔"

PROMPT='%{$fg_bold[blue]%}${SHORT_HOST} %{$fg_bold[white]%}%2~$(git_prompt_info) %{$reset_color%}%(?..%F{001}%? )%f%{$reset_color%}'
RPROMPT="$(enshort $(kubectx_prompt_info)) %{$fg_bold[blue]%}(%T)%{$reset_color%}"
