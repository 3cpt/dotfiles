# oh-my-zsh custom theme: adr
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}x"

PROMPT='%{$bg[yellow]%}%{$fg_bold[black]%}%m%{$reset_color%} %{$fg_bold[white]%}%2~$(git_prompt_info) %{$reset_color%}%(?..%F{001}%? )%f%{$reset_color%}'
RPROMPT="%{$fg[blue]%}(%T)%{$reset_color%}"
