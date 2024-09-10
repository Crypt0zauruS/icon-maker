#!/bin/bash
# Please install imagemagick before running this script
# brew install imagemagick
# example usage: ./icns.sh icon.png

s=$1
ICON_NAME_MAC="${s%.*}.icns"
ICON_NAME_WIN="${s%.*}.ico"
echo "Converting $1 to $ICON_NAME_MAC and $ICON_NAME_WIN..."

# Create icon directories to work in
ICONS_DIR_MAC="tempicon_mac.iconset"
ICONS_DIR_WIN="tempicon_win.iconset"
mkdir $ICONS_DIR_MAC $ICONS_DIR_WIN

# Function to create rounded corner image
create_rounded_image() {
    local input=$1
    local output=$2
    local size=$3
    local radius=$4

    magick "$input" -resize ${size}x${size} \
        \( +clone -alpha extract \
           -draw "fill black polygon 0,0 0,$radius $radius,0 
                  fill white circle $radius,$radius $radius,0" \
           \( +clone -flip \) -compose Multiply -composite \
           \( +clone -flop \) -compose Multiply -composite \
        \) -alpha off -compose CopyOpacity -composite "$output"
}

# Create rounded corner images for all sizes (Mac and Windows)
create_rounded_image "$s" "$ICONS_DIR_MAC/icon_512x512@2x.png" 1024 200
create_rounded_image "$s" "$ICONS_DIR_MAC/icon_512x512.png" 512 100
create_rounded_image "$s" "$ICONS_DIR_MAC/icon_256x256@2x.png" 512 100
create_rounded_image "$s" "$ICONS_DIR_MAC/icon_256x256.png" 256 50
create_rounded_image "$s" "$ICONS_DIR_MAC/icon_128x128@2x.png" 256 50
create_rounded_image "$s" "$ICONS_DIR_MAC/icon_128x128.png" 128 25
create_rounded_image "$s" "$ICONS_DIR_MAC/icon_64x64.png" 64 12
create_rounded_image "$s" "$ICONS_DIR_MAC/icon_32x32.png" 32 6
create_rounded_image "$s" "$ICONS_DIR_MAC/icon_16x16@2x.png" 32 6
create_rounded_image "$s" "$ICONS_DIR_MAC/icon_16x16.png" 16 3

# Copy Mac icons to Windows directory (Windows uses same sizes)
cp $ICONS_DIR_MAC/* $ICONS_DIR_WIN/

# Additional sizes for Windows
create_rounded_image "$s" "$ICONS_DIR_WIN/icon_48x48.png" 48 9
create_rounded_image "$s" "$ICONS_DIR_WIN/icon_24x24.png" 24 5

# Create the icns file for Mac
iconutil -c icns $ICONS_DIR_MAC

# Create the ico file for Windows using magick
magick $ICONS_DIR_WIN/icon_16x16.png $ICONS_DIR_WIN/icon_24x24.png \
    $ICONS_DIR_WIN/icon_32x32.png $ICONS_DIR_WIN/icon_48x48.png \
    $ICONS_DIR_WIN/icon_64x64.png $ICONS_DIR_WIN/icon_128x128.png \
    $ICONS_DIR_WIN/icon_256x256.png $ICON_NAME_WIN

# Remove the temporary directories
rm -rf $ICONS_DIR_MAC $ICONS_DIR_WIN

# Rename icns
mv tempicon_mac.icns $ICON_NAME_MAC

echo "Conversion complete. Mac icon saved as $ICON_NAME_MAC"
echo "Windows icon saved as $ICON_NAME_WIN"