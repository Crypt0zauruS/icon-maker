# Icon Maker

[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://semver.org)

<p align="center">
  <img src="Screenshot.jpg" alt="Scrennshot Icon Maker" width="400"/>
</p>

Icon Maker is a simple yet powerful tool for macOS that generates both macOS (.icns) and Windows (.ico) icon files from a single PNG image. It creates icons with rounded corners for a polished look.

## Features

- Generates macOS (.icns) and Windows (.ico) icon files
- Creates icons with rounded corners
- Supports multiple icon sizes for both platforms
- Easy to use command-line interface

## Prerequisites

Before you can use Icon Maker, you need to install ImageMagick. The easiest way to do this on macOS is using Homebrew.

1. Install Homebrew (if you haven't already):

   ```
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install ImageMagick:
   ```
   brew install imagemagick
   ```

## Installation

1. Clone this repository or download the `icns.sh` script.
2. Make the script executable:
   ```
   chmod +x icns.sh
   ```

## Usage

1. Open Terminal and navigate to the directory containing the `icns.sh` script.
2. Run the script with your PNG file as an argument:
   ```
   ./icns.sh path/to/your/icon.png
   ```
3. The script will generate two files in the same directory as your original PNG:
   - `icon.icns` (macOS icon file)
   - `icon.ico` (Windows icon file)

## How It Works

The script performs the following steps:

1. Creates temporary directories for macOS and Windows icons
2. Generates rounded corner images for all required sizes
3. Creates the .icns file for macOS using the `iconutil` command
4. Creates the .ico file for Windows using ImageMagick
5. Cleans up temporary files

## License

This project is open source and available under the [MIT License](LICENSE).

## Acknowledgements

This script was created to simplify the process of generating cross-platform icon files. Special thanks to the ImageMagick community for their powerful image manipulation tools.
