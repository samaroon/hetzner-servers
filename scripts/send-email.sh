#!/usr/bin/env bash
# Usage: send-email.sh <to_address> <subject> <html_body_as_json_string>
# Requires env vars: SENDGRID_API_KEY, NOTIFY_FROM_EMAIL, NOTIFY_FROM_NAME
set -euo pipefail

TO="$1"
SUBJECT="$2"
BODY_JSON="$3"   # must be a JSON-encoded string (use python3 -c "import json; print(json.dumps(...))")

FROM_EMAIL="${NOTIFY_FROM_EMAIL:-noreply@example.com}"
FROM_NAME="${NOTIFY_FROM_NAME:-DevOps}"

if [[ -z "${SENDGRID_API_KEY:-}" ]]; then
  echo "ERROR: SENDGRID_API_KEY is not set" >&2
  exit 1
fi

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  --request POST \
  --url https://api.sendgrid.com/v3/mail/send \
  --header "Authorization: Bearer $SENDGRID_API_KEY" \
  --header "Content-Type: application/json" \
  --data "{
    \"personalizations\": [{\"to\": [{\"email\": \"$TO\"}]}],
    \"from\": {\"email\": \"$FROM_EMAIL\", \"name\": \"$FROM_NAME\"},
    \"subject\": \"$SUBJECT\",
    \"content\": [{\"type\": \"text/html\", \"value\": $BODY_JSON}]
  }")

if [[ "$HTTP_STATUS" -ge 200 && "$HTTP_STATUS" -lt 300 ]]; then
  echo "Email sent to $TO (HTTP $HTTP_STATUS)"
else
  echo "ERROR: SendGrid returned HTTP $HTTP_STATUS" >&2
  exit 1
fi
