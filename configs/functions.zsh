# docker ps -a, but with fzf selection
#
# This works like docker ps -a, but each line is selectable with fzf. The
# selected container ID is printed to stdout.
function dps() {
    local containers
    containers=$(docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}")

    # Check if only the header is present (no containers)
    if [ "$(echo "$containers" | wc -l)" -le 1 ]; then
        echo "🚫 No containers found."
        return 1
    fi

    echo "$containers" | fzf --header-lines=1 | awk '{print}'
}

# Interactively select a Docker container from the list of running containers using fzf
# and display the last 100 lines of the container's logs. If the "-f" flag is provided,
# follow the logs instead of displaying a fixed number of lines.
#
# Options:
#   -f    Follow the container's logs instead of displaying a fixed number of lines.
function logs() {
    local follow_flag=""

    if [[ "$1" == "-f" ]]; then
        follow_flag="-f"
    fi

    local container
    container=$(docker ps --format '{{.Names}}' | fzf --height 20% --border --prompt="Select container: ")

    if [[ -z "$container" ]]; then
        echo "No container selected."
        return 1
    fi

    docker logs -n 100 $follow_flag "$container"
}

# This function allows the user to interactively select a GitHub pull request (PR) from a list of
# their own PRs using fzf. The user can either print the PR title and link or checkout the selected PR.
#
# Options:
#   -u    Print the PR title and link instead of checking out the PR.
#   -h    Display the usage message.
#
# If no PR is selected, it outputs "No PR selected".
function ghprc() {
    local usage="Usage: ghprc [-u] [-h]
    -u    Print the PR title and link instead of checking out
    -h    Show this help message"

    local show_url=false

    while getopts "uh" opt; do
        case $opt in
        u) show_url=true ;;
        h)
            echo "$usage"
            return 0
            ;;
        *)
            echo "$usage"
            return 1
            ;;
        esac
    done

    local pr_data
    pr_data=$(gh pr list --author "@me" --limit 100 --json number,title,url --jq '.[] | select(.number != null) | [.number, .title, .url] | @tsv' | fzf --header="Select a PR" --delimiter="\t" --preview='echo {2}')

    if [[ -n "$pr_data" ]]; then
        local pr_number pr_title pr_url
        read -r pr_number pr_title pr_url <<<"$pr_data"

        if [[ -z "$pr_number" || -z "$pr_title" || -z "$pr_url" ]]; then
            echo "Error: PR data is null"
            return 1
        fi

        if [[ "$show_url" == true ]]; then
            echo "PR: $pr_title"
            echo "Link: $pr_url"
        else
            gh pr checkout "$pr_number" || return 1
        fi
    else
        echo "No PR selected"
    fi
}
