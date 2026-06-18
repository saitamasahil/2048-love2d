#!/usr/bin/env bash
# Multi-platform build script for 2048 Plus (Linux AppImage & Windows 64-bit)
set -euo pipefail

# Get script and project directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GAME_SRC="$SCRIPT_DIR/gamedata"
BUILD_DIR="$SCRIPT_DIR/build"
WORKSPACE_DIR="$BUILD_DIR/build_workspace"

# Ensure directories exist
mkdir -p "$BUILD_DIR"
rm -rf "$WORKSPACE_DIR"
mkdir -p "$WORKSPACE_DIR"
cd "$WORKSPACE_DIR"

echo -e "\033[1;34m=== 1. Packaging LÖVE game code ===\033[0m"
LOVE_FILE="$WORKSPACE_DIR/2048plus.love"
rm -f "$LOVE_FILE"

# Create game .love zip archive from the local gamedata folder
(
    cp "$SCRIPT_DIR/LICENSE" "$GAME_SRC/LICENSE"
    cd "$GAME_SRC"
    zip -9 -q -r "$LOVE_FILE" .
    rm -f "$GAME_SRC/LICENSE"
)
echo "Created $LOVE_FILE successfully."

# Helper function to download files
download_file() {
    local url="$1"
    local output="$2"
    if [ ! -f "$output" ]; then
        echo "Downloading $output..."
        if command -v curl >/dev/null 2>&1; then
            curl -L -o "$output" "$url"
        elif command -v wget >/dev/null 2>&1; then
            wget -O "$output" "$url"
        else
            echo "Error: Neither curl nor wget is installed."
            exit 1
        fi
    else
        echo "$output already exists, skipping download."
    fi
    chmod +x "$output"
}

# ==============================================================================
# LINUX BUILD (AppImage)
# ==============================================================================
echo -e "\n\033[1;34m=== 2. Building Linux AppImage ===\033[0m"

# Download official love AppImage (v11.5)
download_file \
    "https://github.com/love2d/love/releases/download/11.5/love-11.5-x86_64.AppImage" \
    "love-x86_64.AppImage"

# Download appimagetool
download_file \
    "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" \
    "appimagetool-x86_64.AppImage"

echo "Extracting LÖVE AppImage..."
rm -rf squashfs-root
export APPIMAGE_EXTRACT_AND_RUN=1
./love-x86_64.AppImage --appimage-extract >/dev/null

echo "Fusing Linux game binary..."
cat squashfs-root/bin/love "$LOVE_FILE" > squashfs-root/bin/love-fused
mv squashfs-root/bin/love-fused squashfs-root/bin/love
chmod +x squashfs-root/bin/love

echo "Applying AppImage metadata & icons..."
cp "$SCRIPT_DIR/2048plus.desktop" squashfs-root/love.desktop
cp "$SCRIPT_DIR/2048plus.desktop" squashfs-root/share/applications/love.desktop
cp "$SCRIPT_DIR/LICENSE" squashfs-root/LICENSE
cp "$SCRIPT_DIR/ClearSans_LICENSE.txt" squashfs-root/ClearSans_LICENSE.txt

ICON_SRC="$GAME_SRC/assets/logo_2048.png"
if [ -f "$ICON_SRC" ]; then
    echo "Replacing icons in squashfs-root..."
    # Copy PNG to root and pixmaps
    cp "$ICON_SRC" squashfs-root/love.png
    mkdir -p squashfs-root/share/pixmaps
    cp "$ICON_SRC" squashfs-root/share/pixmaps/love.png
    cp "$ICON_SRC" squashfs-root/.DirIcon
    
    # Remove all default SVG files to prevent fallback
    rm -f squashfs-root/love.svg
    rm -f squashfs-root/share/pixmaps/love.svg
fi

echo "Compiling AppImage..."
OUTPUT_APPIMAGE="$BUILD_DIR/2048_Plus-x86_64.AppImage"
rm -f "$OUTPUT_APPIMAGE"
ARCH=x86_64 ./appimagetool-x86_64.AppImage squashfs-root "$OUTPUT_APPIMAGE" >/dev/null

# ==============================================================================
# WINDOWS BUILD (64-bit Zip)
# ==============================================================================
echo -e "\n\033[1;34m=== 3. Building Windows 64-bit Release ===\033[0m"

# Download LÖVE Windows 64-bit package
download_file \
    "https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.zip" \
    "love-11.5-win64.zip"

echo "Extracting LÖVE Windows binaries..."
unzip -q "love-11.5-win64.zip" -d win_workspace

WIN_DIST_DIR="$WORKSPACE_DIR/2048_Plus-win64"
mkdir -p "$WIN_DIST_DIR"

echo "Fusing Windows game binary..."
cat win_workspace/love-11.5-win64/love.exe "$LOVE_FILE" > "$WIN_DIST_DIR/2048 Plus.exe"

# Automatic Windows EXE icon patching using Wine & rcedit
if command -v wine >/dev/null 2>&1; then
    echo "Wine detected! Attempting automatic Windows EXE icon patching..."
    download_file \
        "https://github.com/electron/rcedit/releases/download/v2.0.0/rcedit-x64.exe" \
        "rcedit-x64.exe"
    
    # Convert PNG to ICO using Python Pillow
    if python3 -c "from PIL import Image" >/dev/null 2>&1; then
        echo "Converting PNG icon to Windows ICO format..."
        python3 -c "from PIL import Image; img = Image.open('$ICON_SRC'); img.save('logo_2048.ico', format='ICO', sizes=[(256,256), (128,128), (64,64), (48,48), (32,32), (16,16)])"
        
        # Run rcedit via Wine to replace the PE icon
        echo "Patching 2048 Plus.exe icon..."
        wine rcedit-x64.exe "$WIN_DIST_DIR/2048 Plus.exe" --set-icon "logo_2048.ico" >/dev/null 2>&1 || echo "Warning: Icon patching failed."
    else
        echo "Warning: Python Pillow is not installed. Skipping PNG to ICO conversion."
    fi
else
    echo -e "\033[1;33mWarning: 'wine' is not installed. Skipping automatic Windows EXE icon patching.\033[0m"
    echo "The Windows release will fall back to the default LÖVE icon."
    echo "To enable automatic icon patching, install 'wine' on your Linux host."
fi

echo "Assembling Windows DLL dependencies..."
cp win_workspace/love-11.5-win64/*.dll "$WIN_DIST_DIR/"
cp win_workspace/love-11.5-win64/license.txt "$WIN_DIST_DIR/love_license.txt"
cp "$SCRIPT_DIR/LICENSE" "$WIN_DIST_DIR/LICENSE"
cp "$SCRIPT_DIR/ClearSans_LICENSE.txt" "$WIN_DIST_DIR/ClearSans_LICENSE.txt"

echo "Zipping Windows release..."
OUTPUT_WIN_ZIP="$BUILD_DIR/2048_Plus-win64.zip"
rm -f "$OUTPUT_WIN_ZIP"
(
    cd "$WORKSPACE_DIR"
    zip -9 -q -r "$OUTPUT_WIN_ZIP" "2048_Plus-win64"
)

# ==============================================================================
# CLEANUP
# ==============================================================================
echo -e "\n\033[1;34m=== 4. Cleaning up build workspace ===\033[0m"
cd "$SCRIPT_DIR"
rm -rf "$WORKSPACE_DIR"

echo -e "\n\033[1;32m✅ Build complete!\033[0m"
echo "Generated Linux AppImage: $OUTPUT_APPIMAGE ($(du -sh "$OUTPUT_APPIMAGE" | cut -f1))"
echo "Generated Windows Zip:     $OUTPUT_WIN_ZIP ($(du -sh "$OUTPUT_WIN_ZIP" | cut -f1))"
