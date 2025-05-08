#!/usr/bin/env sh
set -e

# Function to parse a URL into its components
parse_url() {
  eval "$(echo "$1" | sed -E \
    -e "s#^(([^:]+)://)?(([^:@]+)(:([^@]+))?@)?([^/?]+)(/(.*))?#\
${PREFIX:-URL_}SCHEME='\2' \
${PREFIX:-URL_}USER='\4' \
${PREFIX:-URL_}PASSWORD='\6' \
${PREFIX:-URL_}HOSTPORT='\7' \
${PREFIX:-URL_}DATABASE='\9'#")"
}

# Parse the DATABASE_URL and extract components
PREFIX="SHLINK_DB_" parse_url "$DATABASE_URL"

# Separate host and port
SHLINK_DB_HOST="$(echo $SHLINK_DB_HOSTPORT | sed -E 's,:.*,,')"
SHLINK_DB_PORT="$(echo $SHLINK_DB_HOSTPORT | sed -E 's,.*:([0-9]+).*,\1,')"

# Export database environment variables
export DB_DRIVER="postgres"
export DB_HOST="$SHLINK_DB_HOST"
export DB_PORT="$SHLINK_DB_PORT"
export DB_NAME="$SHLINK_DB_DATABASE"
export DB_USER="$SHLINK_DB_USER"
export DB_PASSWORD="$SHLINK_DB_PASSWORD"

cd /etc/shlink

# Create data directories if they do not exist. This allows data dir to be mounted as an empty dir if needed
mkdir -p data/cache data/locks data/log data/proxies

flags="--no-interaction --clear-db-cache"

# Read env vars through Shlink command, so that it applies the `_FILE` env var fallback logic
geolite_license_key=$(bin/cli env-var:read GEOLITE_LICENSE_KEY)
skip_initial_geolite_download=$(bin/cli env-var:read SKIP_INITIAL_GEOLITE_DOWNLOAD)
initial_api_key=$(bin/cli env-var:read INITIAL_API_KEY)

# Skip downloading GeoLite2 db file if the license key env var was not defined or skipping was explicitly set
if [ -z "${geolite_license_key}" ] || [ "${skip_initial_geolite_download}" = "true" ]; then
  flags="${flags} --skip-download-geolite"
fi

# If INITIAL_API_KEY was provided, create an initial API key
if [ -n "${initial_api_key}" ]; then
  flags="${flags} --initial-api-key=${initial_api_key}"
fi

php vendor/bin/shlink-installer init ${flags}

if [ "$SHLINK_RUNTIME" = 'rr' ]; then
  # Run with `exec` so that signals are properly handled
  exec ./bin/rr serve -c config/roadrunner/.rr.yml
fi
