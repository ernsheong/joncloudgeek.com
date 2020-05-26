#!/bin/bash

if [[ -z "$TITLE" ]]; then
  echo "Missing TITLE"
  exit 1
fi
# if [[ -z "$HTML_CONTENT" ]]; then
#   echo "Missing HTML_CONTENT"
#   exit 1
# fi
if [[ -z "$CANONICAL_URL" ]]; then
  echo "Missing CANONICAL_URL"
  exit 1
fi
if [[ -z "$TAGS" ]]; then
  echo "Missing TAGS"
  exit 1
fi

HTML_CONTENT=$(cat export/medium.html)

USER_ID=$(curl -sS -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}" https://api.medium.com/v1/me \
 | jq -r '.data.id')

JSON_DATA=$( jq -n \
  --arg title "$TITLE" \
  --arg content "$HTML_CONTENT" \
  --arg canonicalUrl "$CANONICAL_URL" \
  --argjson tags "$TAGS" \
  --arg publishStatus "draft" \
  --arg contentFormat "html" \
  '{title:$title,content:$content,canonicalUrl:$canonicalUrl,publishStatus:$publishStatus,contentFormat:$contentFormat,tags:$tags}'
)

curl -sS -d "$JSON_DATA" \
  -H "Accept: application/json" -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" "https://api.medium.com/v1/users/${USER_ID}/posts"