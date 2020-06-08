#!/bin/bash

BUILD_DIR="export"

if [ -z "${PLATFORM}" ]; then
  echo Missing PLATFORM
  exit 1
fi

if [ -z "${POST_PATH}" ]; then
  echo Missing POST_PATH
  exit 1
fi

if [ -z "${SLUG}" ]; then
  echo Missing SLUG
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

# Strip all figcaption if medium
if [[ $PLATFORM == "medium" ]]; then
  gsed -i 's/<figcaption>.*<\/figcaption>/ \\/g' $TARGET
fi

# Replace relative path with absolute path
gsed -i "s/(\.\//(https:\/\/joncloudgeek.com\/blog\/${SLUG}\//" $TARGET

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
  print "<!-- MEDIUM_LIST_PRESERVE -->"
}
{
  if (match($0,/##\s(.*)$/, a) != 0) {
    split(a[1], b, " ")
    printf "  1. [%s](#%s)\n", a[1], joinlower(b,1,length(b),"-")
  }
}
END { print "" } ' $TARGET > "$BUILD_DIR/toc"

# Prepend Credits to target
BLOG_PATH=${POST_PATH%index.md}
BLOG_PATH=${BLOG_PATH#content/}
FREE=""
if [[ "$PLATFORM" == "medium" ]]; then
  FREE=" (free)"
fi
gsed -i "1s;^;\nThis post was originally posted on [JonCloudGeek](https://joncloudgeek.com/${BLOG_PATH})${FREE}\n\n;" $TARGET

if [[ "$PLATFORM" == "dev" ]]; then
  # Insert TOC file contents before first image
  gsed -i "/\.jpg/e cat ${BUILD_DIR}/toc" $TARGET
fi

# Promote books at end
gawk '
  { print }
  END { print "\n## My GCP Books\n\nIf you found this blog post helpful, kindly check out my [books on GCP topics](https://joncloudgeek.com/books/)!" }
' $TARGET > $TARGET_TEMP
mv $TARGET_TEMP $TARGET

#
# MARKDOWN OPTIMIZED FOR MEDIUM
#

gawk '
  BEGIN { preserve=0 }
  /MEDIUM_LIST_PRESERVE/ { preserve=1 }

   # Reset
  /^$/ { preserve=0 }
  /##/ { preserve=0 }

  /INLINE_IMAGES_END/ { inline=0 }
  /^\s*[0-9]*\.?\s+/ {
    if (preserve == 0) {
      gsub(/^\s*[0-9]\.\s+/, "")
      gsub(/$/, "\n")
    }
  }
  /##/ { gsub(/##/, "#") }
  /^\s+/ {
    if (preserve == 0) {
      gsub(/^\s+/, "")
    }
  } 1
' $TARGET > "$BUILD_DIR/medium.md"

# Generate medium.html
pandoc -o "$BUILD_DIR/medium.html" "$BUILD_DIR/medium.md"

# Add image title as figcaption
gsed -i 's/<img\ssrc=".*"\stitle="\(.*\)"\salt=".*"\s\/>/<figure>\0<figcaption>\1<\/figcaption><\/figure>/' "$BUILD_DIR/medium.html"

# Replace <strong> with <b>
gsed -i 's/strong>/b>/g' "$BUILD_DIR/medium.html"