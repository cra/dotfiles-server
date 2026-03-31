# === Nord PS1 (multiline, for use with tmux) ===
#
# Set PS1_ACCENT before sourcing to pick a machine color:
#   frost    - light blue (default)
#   aurora   - green
#   orange   - warm orange
#   purple   - soft purple
#   red      - nord red
#   yellow   - nord yellow
#   teal     - nord teal
#   white    - plain white (safe for any terminal)

__nord_ps1() {
    local last_exit=$?

    # Nord true-color (kitty/256color)
    local reset='\[\e[0m\]'
    local red='\[\e[38;2;191;97;106m\]'      # nord11
    local teal='\[\e[38;2;143;188;187m\]'     # nord7
    local blue='\[\e[38;2;129;161;193m\]'     # nord9
    local yellow='\[\e[38;2;235;203;139m\]'   # nord13
    local green='\[\e[38;2;163;190;140m\]'    # nord14
    local dim='\[\e[38;2;76;86;106m\]'        # nord3

    # Machine accent color for timestamp (set PS1_ACCENT to pick)
    local accent
    case "${PS1_ACCENT:-frost}" in
        frost)  accent='\[\e[38;2;136;192;208m\]' ;;  # nord8
        aurora) accent='\[\e[38;2;163;190;140m\]' ;;  # nord14
        orange) accent='\[\e[38;2;208;135;112m\]' ;;  # nord12
        purple) accent='\[\e[38;2;180;142;173m\]' ;;  # nord15
        red)    accent='\[\e[38;2;191;97;106m\]'  ;;  # nord11
        yellow) accent='\[\e[38;2;235;203;139m\]' ;;  # nord13
        teal)   accent='\[\e[38;2;143;188;187m\]' ;;  # nord7
        white)  accent='\[\e[37m\]'               ;;  # basic white
        *)      accent='\[\e[38;2;136;192;208m\]' ;;  # fallback: frost
    esac

    local ps=""

    # Timestamp (accent color, shows when command finished)
    ps+="${accent}\t${reset} "

    # Exit code (red, only on failure)
    if [ $last_exit -ne 0 ]; then
        ps+="${red}[$last_exit] ${reset}"
    fi

    # Python virtualenv
    if [ -n "$VIRTUAL_ENV" ]; then
        ps+="${teal}($(basename "$VIRTUAL_ENV")) ${reset}"
    fi

    # Working directory
    ps+="${blue}\w${reset}"

    # Git branch
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        ps+=" ${yellow}${branch}${reset}"
    fi

    # Newline + prompt symbol
    ps+="\n${green}\$${reset} "

    PS1="$ps"
}

# Disable built-in virtualenv prompt (we handle it ourselves)
export VIRTUAL_ENV_DISABLE_PROMPT=1

PROMPT_COMMAND="__nord_ps1${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
