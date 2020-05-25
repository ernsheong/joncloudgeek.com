#!/bin/bash

if [ -z "${POST_DIR}" ]; then
  echo Missing POST_DIR
  exit 1
fi

echo $POST_DIR
pandoc -o "${POST_DIR}/index.md" --wrap=preserve -t markdown "${POST_DIR}/index.html"
sed -i'.bak' -e 's/{width=.*}//g' "$POST_DIR/index.md"
sed -i'.bak' -e 's/\\\$/$/g' "$POST_DIR/index.md"
sed -i'.bak' -e 's/(\.\//(https:\/\/joncloudgeek.com\/blog\/deploy-postgres-container-to-compute-engine\//g' "$POST_DIR/index.md"