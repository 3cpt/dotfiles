# Print a random motivational phrase to the terminal.
# Set NO_MOTIVATION=1 to disable this output.
function show_motivation() {
    # Only show in interactive shells and if not disabled
    [[ $- != *i* || -n "$NO_MOTIVATION" ]] && return
    local phrases=(
        # Chuck Norris quotes
        "The terminal doesn't fear you. It fears whoever taught you."
        "Chuck Norris doesn't do git push. The code deploys itself."
        "Every error is just one line closer to greatness."
        "Your code doesn't have bugs — it has surprise features."
        "Who needs coffee when you've got logs?"
        "npm install is life's way of teaching you patience."
        "Debugging: the art of fixing what you thought wasn't broken."
        "You don't use the terminal. The terminal uses you to feel productive."
        "Compiling isn't failure. It's an act of bravery."
        "When you run rm -rf /, even the universe flinches."
        "Programming: solving problems you didn't know you had in ways you don't understand."
        "Chuck Norris deploys to production. On Fridays. Without backups."
        "The error is in the user. You are the user."
        "Life is like an if-statement: forget the else and chaos reigns."
        "Small commit, peaceful mind."
        "Only people who never coded think the computer is the problem."
        "If it works, don't touch it. If it doesn't, pretend it's in staging."
        "Motivation is just Ctrl+C on fear."
        "Don't cry over production being down. Rebuild the container and rise."
        "In the terminal, everyone hears you type. But only logs judge you."
        # Yoda quotes
        "Code or code not. There is no try."
        "Powerful with the logs, you must become."
        "Fear is the path to the dark side. Fear leads to bugs."
        "Named your variables well, you have not."
        "Hmm. Broken it is. Fix it, you must."
        "Much to learn, still you have — even with Stack Overflow open."
        "In production, push you must not. Unless wise, you are."
        "Debug, you must. Panic, you shall not."
        "To master git, patience you need."
        "Strong in the force, your linter is."
        "Warnings ignored, failures invited are."
        "Type checking — the Jedi's weapon it is."
        "May the semicolon be with you."
        "With great indentation, clarity comes."
        "Read the docs, a true Jedi does."
        "Bugs, the dark side's whispers they are."
        "Commit or not commit. There is no maybe."
        "Through testing, confidence flows."
        "Review your code, like a lightsaber you sharpen."
        "In your terminal, peace you must find."
    )
    local random_index=$((RANDOM % ${#phrases[@]}))
    # Use tput for color if available, fallback to ANSI
    local yellow reset
    if command -v tput &>/dev/null; then
        yellow="$(
            tput setaf 3
            tput bold
        )"
        reset="$(tput sgr0)"
    else
        yellow='\033[1;33m'
        reset='\033[0m'
    fi
    echo -e "${yellow}${phrases[$random_index]}${reset}"
}
