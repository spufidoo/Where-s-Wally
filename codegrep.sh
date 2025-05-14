codegrep() {
    local OPTIND opt EXT OPEN=false

    while getopts "e:c" opt; do
        case $opt in
            e) EXT="$OPTARG" ;;
            c) OPEN=true ;;
            *) echo "Usage: codegrep [-e EXT] [-c] PATTERN [DIRECTORY]"; return 1 ;;
        esac
    done
    shift $((OPTIND -1))

    local PATTERN="$1"
    local DIR="${2:-.}"

    if [[ -z "$PATTERN" ]]; then
        echo "Usage: codegrep [-e EXT] [-c] PATTERN [DIRECTORY]"
        echo "Search for file names matching a pattern in a directory."
        echo "  -e EXT   Search for files with the specified extension"
        echo "  -c       Open matching files in VS Code"
        return 1
    fi

    local FILES
    if [[ -n "$EXT" ]]; then
        FILES=$(find "$DIR" -type f -name "*.$EXT")
    else
        FILES=$(find "$DIR" -type f)
    fi

    local MATCHED=()
    while IFS= read -r file; do
        if grep -q "$PATTERN" "$file" 2>/dev/null; then
            echo "$file"
            MATCHED+=("$file")
        fi
    done <<< "$FILES"

    if $OPEN && [[ ${#MATCHED[@]} -gt 0 ]]; then
        code "${MATCHED[@]}"
    fi
}
