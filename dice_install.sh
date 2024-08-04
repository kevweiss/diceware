#!/bin/bash

# Create a temporary directory
TMP_DIR=$(mktemp -d)
SCRIPT_DIR="$HOME/HW/dice_env/scripts"

# Extract the files
tail -n +20 "$0" | tar xz -C "$TMP_DIR"

# Move the files to the desired location
mkdir -p "$SCRIPT_DIR"
mv "$TMP_DIR/diceware_2.0.py" "$SCRIPT_DIR/diceware_2.0.py"
mv "$TMP_DIR/dicegen_install.sh" "$SCRIPT_DIR/dicegen_install.sh"

# Make the scripts executable
chmod +x "$SCRIPT_DIR/dicegen_2.0.py"
chmod +x "$SCRIPT_DIR/dicegen_install.sh"

# Run the installation script
"$SCRIPT_DIR/dicegen_install.sh"

# Clean up
rm -rf "$TMP_DIR"

# Exit the script
exit 0

# Below this line, add your files in a tar.gz format
tar czf - diceware_2.0.py dicegen_install.sh dice_env >> dice_install.sh 