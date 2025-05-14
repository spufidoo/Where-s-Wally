codefind() {
    local OPTIND opt REGEX=false OPEN=false

    while getopts "rc" opt; do
        case $opt in
            r) REGEX=true ;;
            c) OPEN=true ;;
            *) echo "Usage: codefind [-r] [-c] PATTERN [DIRECTORY]"; return 1 ;;
        esac
    done
    shift $((OPTIND -1))

    local PATTERN="$1"
    local DIR="${2:-.}"

    if [[ -z "$PATTERN" ]]; then
        echo "Usage: codefind [-r] [-c] PATTERN [DIRECTORY]"   
        echo "Find files by name or regex in a directory."
        echo "  -r       Use regex for pattern matching"
        echo "  -c       Open matching files in VS Code"
        return 1
    fi

    local FILES
    if $REGEX; then
        FILES=$(find "$DIR" -type f | grep -E "$PATTERN")
    else
        FILES=$(find "$DIR" -type f -name "$PATTERN")
    fi

    if [[ -z "$FILES" ]]; then
        echo "No files found matching '$PATTERN'"
        return 0
    fi

    echo "$FILES"

    if $OPEN; then
        xargs -r code
    fi
}
