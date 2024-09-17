#!/bin/bash
# Please install imagemagick before running this script
# brew install imagemagick
# example usage: ./icns.sh icon.png

# Check if a file is specified
if [ $# -eq 0 ]; then
    echo "Error: No file specified."
    echo "Usage: $0 <png_file>"
    read -n 1 -s -r -p "Press any key to exit"
    exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "Error: File '$1' does not exist."
    read -n 1 -s -r -p "Press any key to exit"
    exit 1
fi

# Check if the file has a .png extension
if [[ ${1,,} != *.png ]]; then
    echo "Error: File '$1' is not a PNG file (based on extension)."
    read -n 1 -s -r -p "Press any key to exit"
    exit 1
fi

# Check if the file is actually a PNG using the 'file' command
if ! file "$1" | grep -qi "PNG image data"; then
    echo "Error: File '$1' is not a valid PNG file."
    read -n 1 -s -r -p "Press any key to exit"
    exit 1
fi

s=$1
ICON_NAME_MAC="${s%.*}.icns"
ICON_NAME_WIN="${s%.*}.ico"
ICONS_DIR_LINUX="linux_icons"

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

# Ask user for each system
read -p "Create icons for macOS? (y/n): " mac_choice
read -p "Create icons for Windows? (y/n): " win_choice
read -p "Create icons for Linux? (y/n): " linux_choice

# Process for macOS
if [[ $mac_choice =~ ^[Yy]$ ]]; then
    echo "Creating macOS icons..."
    ICONS_DIR_MAC="tempicon_mac.iconset"
    mkdir -p $ICONS_DIR_MAC
    
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
    
    iconutil -c icns $ICONS_DIR_MAC
    mv tempicon_mac.icns $ICON_NAME_MAC
    rm -rf $ICONS_DIR_MAC
    echo "macOS icon saved as $ICON_NAME_MAC"
fi

# Process for Windows
if [[ $win_choice =~ ^[Yy]$ ]]; then
    echo "Creating Windows icons..."
    ICONS_DIR_WIN="tempicon_win.iconset"
    mkdir -p $ICONS_DIR_WIN
    
    create_rounded_image "$s" "$ICONS_DIR_WIN/icon_256x256.png" 256 50
    create_rounded_image "$s" "$ICONS_DIR_WIN/icon_128x128.png" 128 25
    create_rounded_image "$s" "$ICONS_DIR_WIN/icon_64x64.png" 64 12
    create_rounded_image "$s" "$ICONS_DIR_WIN/icon_48x48.png" 48 9
    create_rounded_image "$s" "$ICONS_DIR_WIN/icon_32x32.png" 32 6
    create_rounded_image "$s" "$ICONS_DIR_WIN/icon_24x24.png" 24 5
    create_rounded_image "$s" "$ICONS_DIR_WIN/icon_16x16.png" 16 3
    
    magick $ICONS_DIR_WIN/icon_256x256.png $ICONS_DIR_WIN/icon_128x128.png \
        $ICONS_DIR_WIN/icon_64x64.png $ICONS_DIR_WIN/icon_48x48.png \
        $ICONS_DIR_WIN/icon_32x32.png $ICONS_DIR_WIN/icon_24x24.png \
        $ICONS_DIR_WIN/icon_16x16.png $ICON_NAME_WIN
    rm -rf $ICONS_DIR_WIN
    echo "Windows icon saved as $ICON_NAME_WIN"
fi

# Process for Linux
if [[ $linux_choice =~ ^[Yy]$ ]]; then
    echo "Creating Linux icons..."
    mkdir -p $ICONS_DIR_LINUX
    create_rounded_image "$s" "$ICONS_DIR_LINUX/icon_16x16.png" 16 3
    create_rounded_image "$s" "$ICONS_DIR_LINUX/icon_32x32.png" 32 6
    create_rounded_image "$s" "$ICONS_DIR_LINUX/icon_48x48.png" 48 9
    create_rounded_image "$s" "$ICONS_DIR_LINUX/icon_64x64.png" 64 12
    create_rounded_image "$s" "$ICONS_DIR_LINUX/icon_128x128.png" 128 25
    create_rounded_image "$s" "$ICONS_DIR_LINUX/icon_256x256.png" 256 50
    echo "Linux icons saved in $ICONS_DIR_LINUX directory"
fi

echo "Conversion complete."
read -n 1 -s -r -p "Press any key to exit"