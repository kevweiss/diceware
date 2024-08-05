#!/bin/bash

# Directory where the Python script is located
SCRIPT_DIR="$HOME/diceware"
SCRIPT_NAME="diceware_2.0.py"
ALIAS_NAME="diceware_gen"

# Path to the Python script
SCRIPT_PATH="$SCRIPT_DIR/$SCRIPT_NAME"

# Check if the script exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: $SCRIPT_PATH does not exist."
    exit 1
fi

# Add the alias to the bashrc or zshrc
if [ -n "$BASH_VERSION" ]; then
    ALIAS_CMD="alias $ALIAS_NAME='python3 $SCRIPT_PATH'"
    if ! grep -qxF "$ALIAS_CMD" ~/.bashrc; then
        echo "$ALIAS_CMD" >> ~/.bashrc
        echo "Alias $ALIAS_NAME added to ~/.bashrc"
    else
        echo "Alias $ALIAS_NAME already exists in ~/.bashrc"
    fi
elif [ -n "$ZSH_VERSION" ]; then
    ALIAS_CMD="alias $ALIAS_NAME='python3 $SCRIPT_PATH'"
    if ! grep -qxF "$ALIAS_CMD" ~/.zshrc; then
        echo "$ALIAS_CMD" >> ~/.zshrc
        echo "Alias $ALIAS_NAME added to ~/.zshrc"
    else
        echo "Alias $ALIAS_NAME already exists in ~/.zshrc"
    fi
else
    echo "Unknown shell. Please add the alias manually."
    exit 1
fi

# Source the updated shell configuration
if [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
elif [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
fi

echo "Installation complete. You can now run the script using the '$ALIAS_NAME' command."

