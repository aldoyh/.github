#!/bin/bash
#
# Script to download Arabic-supported fonts from Google Fonts repository
# Usage:
#   ./download-arabic-fonts.sh              # Download all Arabic fonts
#   ./download-arabic-fonts.sh --name Amiri # Download specific font by name
#

set -e

FONTS_REPO="https://github.com/google/fonts.git"
TEMP_DIR="/tmp/google-fonts-$$"
OUTPUT_DIR="arabic-fonts"
SPECIFIC_FONT=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            SPECIFIC_FONT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--name FONT_NAME]"
            exit 1
            ;;
    esac
done

echo "=================================================="
echo "Arabic Fonts Downloader from Google Fonts"
echo "=================================================="
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Clone the Google Fonts repository
echo "Cloning Google Fonts repository..."
if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi
git clone --depth 1 "$FONTS_REPO" "$TEMP_DIR" 2>&1 | head -n 5
echo "✓ Repository cloned successfully"
echo ""

# Function to check if a font is Arabic-supported
is_arabic_font() {
    local metadata_file="$1"
    
    # Check if the metadata file contains "arabic" in subsets or "Arab" in primary_script
    if grep -q 'subsets:.*"arabic"' "$metadata_file" 2>/dev/null || \
       grep -q 'primary_script:.*"Arab"' "$metadata_file" 2>/dev/null; then
        return 0
    fi
    return 1
}

# Function to extract font name from METADATA.pb
get_font_name() {
    local metadata_file="$1"
    grep '^name:' "$metadata_file" | head -n 1 | sed 's/^name: "\(.*\)"$/\1/'
}

# Find all Arabic fonts
echo "Scanning for Arabic-supported fonts..."
arabic_fonts=()
total_fonts=0

for metadata in "$TEMP_DIR"/ofl/*/METADATA.pb "$TEMP_DIR"/apache/*/METADATA.pb "$TEMP_DIR"/ufl/*/METADATA.pb; do
    if [ -f "$metadata" ]; then
        total_fonts=$((total_fonts + 1))
        
        if is_arabic_font "$metadata"; then
            font_dir=$(dirname "$metadata")
            font_name=$(get_font_name "$metadata")
            
            # If specific font is requested, only process that one
            if [ -n "$SPECIFIC_FONT" ]; then
                if [ "$font_name" = "$SPECIFIC_FONT" ]; then
                    arabic_fonts+=("$font_dir:$font_name")
                fi
            else
                arabic_fonts+=("$font_dir:$font_name")
            fi
        fi
    fi
done

echo "✓ Scanned $total_fonts font families"
echo "✓ Found ${#arabic_fonts[@]} Arabic-supported fonts"
echo ""

# If specific font was requested but not found
if [ -n "$SPECIFIC_FONT" ] && [ ${#arabic_fonts[@]} -eq 0 ]; then
    echo "Error: Font '$SPECIFIC_FONT' not found or does not support Arabic script"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Download the fonts
if [ ${#arabic_fonts[@]} -eq 0 ]; then
    echo "No Arabic fonts found to download"
    rm -rf "$TEMP_DIR"
    exit 0
fi

echo "Downloading Arabic fonts..."
echo ""

count=0
for font_info in "${arabic_fonts[@]}"; do
    font_dir="${font_info%%:*}"
    font_name="${font_info##*:}"
    
    count=$((count + 1))
    
    # Create font-specific directory
    font_output_dir="$OUTPUT_DIR/$font_name"
    mkdir -p "$font_output_dir"
    
    # Copy all font files (ttf, otf) and metadata
    cp "$font_dir"/*.ttf "$font_output_dir"/ 2>/dev/null || true
    cp "$font_dir"/*.otf "$font_output_dir"/ 2>/dev/null || true
    cp "$font_dir"/METADATA.pb "$font_output_dir"/ 2>/dev/null || true
    cp "$font_dir"/OFL.txt "$font_output_dir"/ 2>/dev/null || true
    cp "$font_dir"/LICENSE.txt "$font_output_dir"/ 2>/dev/null || true
    
    # Count downloaded files
    num_files=$(find "$font_output_dir" -name "*.ttf" -o -name "*.otf" | wc -l)
    
    echo "[$count/${#arabic_fonts[@]}] $font_name ($num_files font files)"
done

echo ""
echo "=================================================="
echo "✓ Download Complete!"
echo "=================================================="
echo "Downloaded ${#arabic_fonts[@]} Arabic font families to: $OUTPUT_DIR/"
echo ""

# Create a summary file
cat > "$OUTPUT_DIR/README.md" << EOF
# Arabic Fonts from Google Fonts

This directory contains Arabic-supported fonts downloaded from the [Google Fonts](https://github.com/google/fonts) repository.

## Downloaded Fonts

Total: ${#arabic_fonts[@]} font families

EOF

for font_info in "${arabic_fonts[@]}"; do
    font_name="${font_info##*:}"
    echo "- **$font_name**" >> "$OUTPUT_DIR/README.md"
done

cat >> "$OUTPUT_DIR/README.md" << EOF

## License

Each font family includes its own license file (OFL.txt or LICENSE.txt).
Most fonts are licensed under the SIL Open Font License (OFL).

## Download Date

$(date +"%Y-%m-%d %H:%M:%S %Z")

## Source

Downloaded from: https://github.com/google/fonts
EOF

echo "Created summary file: $OUTPUT_DIR/README.md"

# Cleanup
rm -rf "$TEMP_DIR"
echo "✓ Cleaned up temporary files"
echo ""
echo "Done!"
