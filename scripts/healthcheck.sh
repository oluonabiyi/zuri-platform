#!/usr/bin/env bash
# Zuri Market daily health check.
# Calls the backend health endpoint and APPENDS one line to the report.
set -uo pipefail

URL="${HEALTH_URL:-http://localhost/api/health}"
REPORT="${REPORT_FILE:-/var/log/zuri/health-report.log}"
BODY_FILE="$(mktemp)"

mkdir -p "$(dirname "$REPORT")"
TIMESTAMP="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

RESULT="$(curl -s -o "$BODY_FILE" -w '%{http_code} %{time_total}' --max-time 10 "$URL")"
HTTP_CODE="${RESULT%% *}"
TIME_TAKEN="${RESULT##* }"

if [[ "$HTTP_CODE" == "200" ]] && grep -q '"status":"ok"' "$BODY_FILE"; then
  STATUS="HEALTHY"
else
  STATUS="UNHEALTHY"
fi

# >> appends (keeps old lines). A single > would wipe the file every day.
echo "$TIMESTAMP | $STATUS | http=$HTTP_CODE | time=${TIME_TAKEN}s | url=$URL" >> "$REPORT"
rm -f "$BODY_FILE"

[[ "$STATUS" == "HEALTHY" ]]