#!/bin/bash

set -e

FROXLOR_PKG="froxlor"
FROXLOR_DIR="/var/www/froxlor"
PHP_BIN="/usr/bin/php"
VERSION_FILE="/var/lib/froxlor/.last_migrated_version"

# Ensure file exists
mkdir -p "$(dirname "${VERSION_FILE}")"
touch "${VERSION_FILE}"

# Currently installed version
CURRENT_VERSION=$(dpkg-query -W -f='${Version}' "${FROXLOR_PKG}" 2>/dev/null || echo "none")
LAST_VERSION=$(cat "${VERSION_FILE}")

if [ "${CURRENT_VERSION}" != "${LAST_VERSION}" ] && [ "${CURRENT_VERSION}" != "none" ]; then
    echo "🟡 New Froxlor version detected: ${CURRENT_VERSION} (previous: ${LAST_VERSION})"
    echo "➡️  Starting database migration ..."

    ${PHP_BIN} "${FROXLOR_DIR}/bin/froxlor-cli" froxlor:update -d -A
    EXITCODE=$?

    if [ ${EXITCODE} -eq 0 ]; then
        echo "${CURRENT_VERSION}" > "${VERSION_FILE}"
        echo "✅ Migration finished."
    else
        echo "❌ Migration failed (Exit ${EXITCODE})"
        exit ${EXITCODE}
    fi
else
    echo "ℹ️ No (new) Froxlor version installed. No migration needed."
fi
