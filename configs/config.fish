set -g fish_greeting "Welcome to Fish! 🐟"

set -x PATH $PATH $HOME/.local/bin $HOME/.atuin/bin
set -x GIT_EDITOR micro

# Source another file with environment variables
if test -f $HOME/.env.fish
    source $HOME/.env.fish
    echo ".env.fish loaded"
end

# Load custom functions
if test -f "$DOTFILES_PATH/configs/functions.fish"
    source "$DOTFILES_PATH/configs/functions.fish"
end

# Load aliases
if test -f "$DOTFILES_PATH/configs/aliases.fish"
    source "$DOTFILES_PATH/configs/aliases.fish"
end

# Load extra files from $DOTFILES_PATH/extra if the folder exists
if test -d "$DOTFILES_PATH/extra"
    for config_file in $DOTFILES_PATH/extra/*.fish
        if test -r "$config_file"
            echo "Loading extra file: $config_file"
            source "$config_file"
        end
    end
else
    echo "No extra files found in: $DOTFILES_PATH/extra"
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
