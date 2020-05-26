#!/bin/bash

BUILD_DIR="export"

if [ -z "${POST_PATH}" ]; then
  echo Missing POST_PATH
  exit 1
fi
echo "Converting from ${POST_PATH}..."

# Wipe and re-create build dir
rm -r ${BUILD_DIR}
mkdir $BUILD_DIR

TARGET="$BUILD_DIR/index.md"
TARGET_TEMP="$BUILD_DIR/temp"
cp "$POST_PATH" $TARGET

# Replace figure with markdown image format
gsed -i 's/{{<\sfigure\ssrc="\(.*\)"\salt="\(.*\)"\scaption="\(.*\)".*}}/!\[\2\](\1 "\3")<figcaption>\3<\/figcaption>/' $TARGET
# Remove captured width="..."
gsed -i 's/"\swidth="[0-9]*//g' $TARGET

# Strip all figcaption unless FIGCAPTION=1
if [[ $FIGCAPTION != "1" ]]; then
  gsed -i 's/<figcaption>.*<\/figcaption>//g' $TARGET
fi

# Replace relative path with absolute path
gsed -i "s/(\.\//(https:\/\/joncloudgeek.com\/blog\/deploy-postgres-container-to-compute-engine\//" $TARGET

# Wipe out Frontmatter
gawk '
  BEGIN { del=2 }
  del == 0 { print }
  /---/ { del -= 1 }
' $TARGET > $TARGET_TEMP
mv $TARGET_TEMP $TARGET

# Create Table of Contents
gawk '
@include "join"
BEGIN {
  print "## Table of Contents"
}
{
  if (match($0,/##\s(.*)$/, a) != 0) {
    split(a[1], b, " ")
    printf "  1. [%s](#%s)\n", a[1], joinlower(b,1,length(b),"-")
  }
}
END { print "" } ' $TARGET > "$BUILD_DIR/toc"

# Prepend Credits to TOC file
BLOG_PATH=${POST_PATH%index.md}
BLOG_PATH=${BLOG_PATH#content/}
gsed -i "1s;^;This post was originally posted on [JonCloudGeek](https://joncloudgeek.com/${BLOG_PATH}).\n\n;" "$BUILD_DIR/toc"

# Insert TOC file contents after first image
gsed -i "/meta\.jpg/e cat ${BUILD_DIR}/toc" $TARGET

# Promote books at end
gawk '
  { print }
  END { print "\n## My GCP Books\n\nIf you found this blog post helpful, kindly check out my [books on GCP topics](https://joncloudgeek.com/books/)!" }
' $TARGET > $TARGET_TEMP
mv $TARGET_TEMP $TARGET

# Generate index.html
pandoc -o "$BUILD_DIR/index.html" "$BUILD_DIR/index.md"