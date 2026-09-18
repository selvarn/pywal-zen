#!/usr/bin/env bash
# pywal-zen installer
#
# usage: ./install.sh [--profile DIR] [--skip-pywalfox]
#
#   --profile DIR    zen profile to use (default: autodetect)
#   --skip-pywalfox  don't install/register the pywalfox native host

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE=""
SKIP_PYWALFOX=0

usage() {
    sed -n '4,7p' "$0" | sed 's/^# \{0,1\}//'
}

while [ $# -gt 0 ]; do
    case "$1" in
        --profile) PROFILE="${2:?--profile needs a directory}"; shift 2 ;;
        --skip-pywalfox) SKIP_PYWALFOX=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "unknown option: $1" >&2; usage >&2; exit 1 ;;
    esac
done

info() { printf '\033[1;34m::\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

# the profile zen actually uses is Default= in [Install...], otherwise the one with Default=1
find_profile() {
    local root ini path
    for root in "$HOME/.config/zen" "$HOME/.zen" \
                "$HOME/.var/app/app.zen_browser.zen/.zen"; do
        ini="$root/profiles.ini"
        [ -f "$ini" ] || continue
        path=$(awk -F= '/^\[Install/{s=1;next} /^\[/{s=0} s&&$1=="Default"{print $2;exit}' "$ini")
        if [ -z "$path" ]; then
            path=$(awk -F= '/^\[/{p=""} $1=="Path"{p=$2} $1=="Default"&&$2=="1"&&p!=""{print p;exit}' "$ini")
        fi
        [ -n "$path" ] || continue
        case "$path" in
            /*) echo "$path" ;;
            *)  echo "$root/$path" ;;
        esac
        return 0
    done
    return 1
}

if [ -z "$PROFILE" ]; then
    PROFILE=$(find_profile) || die "zen profile not found, pass it with --profile (see about:profiles)"
fi
[ -d "$PROFILE" ] || die "not a directory: $PROFILE"
info "zen profile: $PROFILE"

if pgrep -x zen-bin >/dev/null 2>&1 || pgrep -x zen >/dev/null 2>&1; then
    warn "zen is running, restart it after install"
fi

# pywalfox native host
if [ "$SKIP_PYWALFOX" -eq 0 ]; then
    PYWALFOX=""
    if command -v pywalfox >/dev/null 2>&1; then
        PYWALFOX=$(command -v pywalfox)
        info "pywalfox already installed: $PYWALFOX"
    elif command -v pipx >/dev/null 2>&1; then
        info "installing pywalfox with pipx"
        pipx install pywalfox
        PYWALFOX="$HOME/.local/bin/pywalfox"
    else
        VENV="$HOME/.local/share/pywalfox-venv"
        info "installing pywalfox into $VENV"
        python3 -m venv "$VENV"
        "$VENV/bin/pip" install --quiet --upgrade pywalfox
        mkdir -p "$HOME/.local/bin"
        ln -sf "$VENV/bin/pywalfox" "$HOME/.local/bin/pywalfox"
        PYWALFOX="$VENV/bin/pywalfox"
    fi
    [ -x "$PYWALFOX" ] || die "pywalfox not found at $PYWALFOX"
    PYWALFOX=$(readlink -f "$PYWALFOX")

    # ~/.mozilla for most builds, ~/.config/mozilla for xdg ones
    for dir in "$HOME/.mozilla/native-messaging-hosts" "$HOME/.config/mozilla/native-messaging-hosts"; do
        mkdir -p "$dir"
        "$PYWALFOX" install --executable "$PYWALFOX" --manifest-path "$dir" --profile-path "$PROFILE" >/dev/null
    done
    info "registered pywalfox native host"
fi

# css
CHROME="$PROFILE/chrome"
mkdir -p "$CHROME"
cp "$REPO_DIR/chrome/pywal-zen.css" "$CHROME/pywal-zen.css"

# @import has to be at the very top
USERCHROME="$CHROME/userChrome.css"
IMPORT='@import url("pywal-zen.css");'
touch "$USERCHROME"
if ! grep -qF "$IMPORT" "$USERCHROME"; then
    printf '%s\n%s' "$IMPORT" "$(cat "$USERCHROME")" > "$USERCHROME.tmp"
    mv "$USERCHROME.tmp" "$USERCHROME"
fi
info "css installed to $CHROME"

# prefs
USERJS="$PROFILE/user.js"
touch "$USERJS"
set_pref() {
    local name="$1" value="$2"
    if grep -qE "^[[:space:]]*user_pref\(\"$name\"" "$USERJS"; then
        sed -i -E "s|^[[:space:]]*user_pref\(\"$name\".*|user_pref(\"$name\", $value);|" "$USERJS"
    else
        printf 'user_pref("%s", %s);\n' "$name" "$value" >> "$USERJS"
    fi
}
set_pref toolkit.legacyUserProfileCustomizations.stylesheets true
set_pref zen.theme.disable-lightweight false
info "updated $USERJS"

cat <<EOF

done, now:
  1. restart zen
  2. install the pywalfox addon: https://addons.mozilla.org/firefox/addon/pywalfox/
  3. click the pywalfox icon -> "Fetch Pywal colors"
  4. after every wal run: wal -i <image> && pywalfox update
EOF
