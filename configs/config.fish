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

if set -q SSH_CONNECTION; and not set -q TMUX; and not set -q SSH_ORIGINAL_COMMAND
    if tmux has-session 2>/dev/null
        exec tmux attach
    else
        exec tmux new-session
    end
end

if test -f $HOME/.bash_profile
    source $HOME/.bash_profile
end

atuin init fish | source
oh-my-posh init fish --config $DOTFILES_PATH/configs/adr.omp.yaml | source
