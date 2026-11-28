#!/usr/bin/env bash
# Create Git Bash shims for the php.new / Herd Lite Composer and Laravel installers.
# PowerShell resolves composer.bat / laravel.bat through PATHEXT; Git Bash needs
# extensionless executables, so we add composer and laravel alongside the .bat files.
#
# PHP and XAMPP are installed on demand: each is checked first, and the php.new
# installer / scoop is only invoked when the matching tool is missing.

set -euo pipefail

BIN_DIR="${HOME}/.config/herd-lite/bin"
XAMPP_DIR="${HOME}/scoop/apps/xampp/current"
PHP_BIN=""

powershell_executable() {
    command -v powershell.exe || command -v powershell || command -v pwsh || true
}

php_install_command() {
    cat <<'POWERSHELL'
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://php.new/install/windows'))
POWERSHELL
}

find_php() {
    if [[ -x "${BIN_DIR}/php.exe" ]]; then
        PHP_BIN="${BIN_DIR}/php.exe"
        return 0
    fi

    local path_php
    path_php="$(command -v php || true)"
    if [[ -n "${path_php}" ]]; then
        PHP_BIN="${path_php}"
        return 0
    fi

    return 1
}

ensure_php() {
    # if find_php; then
    #     echo "PHP found: ${PHP_BIN}"
    #     return 0
    # fi
    # echo "PHP not found; installing with php.new..." >&2

    rm -rf "$BIN_DIR"

    local ps_exe
    ps_exe="$(powershell_executable)"
    if [[ -z "${ps_exe}" ]]; then
        echo "PowerShell not found; install PHP manually from https://php.new" >&2
        return 1
    fi

    if ! "${ps_exe}" -NoProfile -Command "$(php_install_command)"; then
        echo "php.new installation failed." >&2
        return 1
    fi

    hash -r

    if ! find_php; then
        echo "PHP was installed but is not visible in this shell. Restart your terminal and rerun this script." >&2
        return 1
    fi

    echo "PHP installed: ${PHP_BIN}"
}

xampp_available() {
    [[ -d "${XAMPP_DIR}" ]] || command -v xampp >/dev/null 2>&1
}

ensure_xampp() {
    if xampp_available; then
        echo "XAMPP found."
        return 0
    fi

    if ! command -v scoop >/dev/null 2>&1; then
        echo "XAMPP not found and scoop is unavailable. Install Scoop from https://scoop.sh, then run 'scoop install xampp'." >&2
        return 1
    fi

    echo "XAMPP not found; installing with scoop..." >&2
    if ! scoop install xampp; then
        echo "scoop install xampp failed." >&2
        return 1
    fi

    hash -r

    if ! xampp_available; then
        echo "XAMPP was installed but is not visible in this shell. Restart your terminal and rerun this script." >&2
        return 1
    fi

    echo "XAMPP installed."
}

warn_missing_bin_dir() {
    if [[ ! -d "${BIN_DIR}" ]]; then
        echo "Herd Lite bin directory not found: ${BIN_DIR}" >&2
        echo "Skipping shim creation; install PHP with php.new or edit BIN_DIR in this script." >&2
    fi
}

create_shim() {
    local name="$1"
    local phar="${BIN_DIR}/${name}.phar"
    local shim="${BIN_DIR}/${name}"

    if [[ ! -d "${BIN_DIR}" ]]; then
        echo "Warning: ${BIN_DIR} not found; skipping ${name}." >&2
        return 0
    fi

    if [[ ! -f "${phar}" ]]; then
        echo "Warning: ${phar} not found; skipping ${name}." >&2
        return 0
    fi

    if [[ -e "${shim}" ]] && ! grep -Eq 'setup_php\.sh|fix-git-bash-shims\.sh' "${shim}" 2>/dev/null; then
        cp "${shim}" "${shim}.bak"
        echo "Backed up existing ${shim} to ${shim}.bak"
    fi

    cat >"${shim}" <<EOF
#!/usr/bin/env bash
# Git Bash shim created by setup_php.sh
exec "${PHP_BIN}" "${phar}" "\$@"
EOF

    chmod +x "${shim}"
    echo "Created ${shim}"
}

verify_shims() {
    echo
    echo "Verifying in Git Bash:"

    if command -v composer >/dev/null 2>&1; then
        composer --version
    else
        echo "composer shim is not on PATH." >&2
    fi

    if command -v laravel >/dev/null 2>&1; then
        laravel --version
    else
        echo "laravel shim is not on PATH." >&2
    fi
}

main() {
    ensure_php
    ensure_xampp || echo "Continuing without XAMPP." >&2
    warn_missing_bin_dir

    create_shim composer
    create_shim laravel

    hash -r
    verify_shims
}

main "$@"
