set -g fish_greeting "Welcome to Fish! 🐟"

set -x PATH $PATH $HOME/.local/bin $HOME/.atuin/bin
set -x GIT_EDITOR micro

# Source another file with environment variables
if test -f $HOME/.config/fish/.env.fish
    source $HOME/.config/fish/.env.fish
    echo ".env.fish loaded"
end

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

if test -f $HOME/.bash_profile
    source $HOME/.bash_profile
end

fzf --fish | source
atuin init fish | source
oh-my-posh init fish --config $DOTFILES_PATH/configs/adr.omp.yaml | source
