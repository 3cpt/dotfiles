set -x PATH $PATH $HOME/.local/bin $HOME/.atuin/bin
set -x ZSH_PROMPT_EMOJI 🌀
set -x TMUX_MAIN_DISK_NAME /dev/disk3s1
set -Ux DOTFILES_PATH __DOTFILES_PATH__
set -Ux EXTRA_FILES_PATH __EXTRA_FILES_PATH__

if test -d "$EXTRA_FILES_PATH" && test "$EXTRA_FILES_PATH" != __EXTRA_FILES_PATH__
    for config_file in $EXTRA_FILES_PATH/*.fish
        if test -r "$config_file"
            echo "Loading extra file: $config_file"
            source "$config_file"
        end
    end
else
    echo "No extra files found"
end

if test -n "$SSH_CONNECTION"
    if not test -n "$TMUX"
        tmux attach || tmux new-session
    end
end

if test -f ~/.bash_profile
    source ~/.bash_profile
end

fzf --fish | source
atuin init fish | source
oh-my-posh init fish --config $DOTFILES_PATH/configs/adr.omp.yaml | source
