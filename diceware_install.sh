#!/bin/bash

# Check if Git is installed
if ! command -v git &> /dev/null
then
    echo "Git is not installed. Please install Git and try again."
    exit 1
fi

# Clone the repository
git clone https://github.com/kevweiss/diceware.git

# Navigate into the cloned repository
cd diceware || { echo "Failed to enter the diceware directory. Exiting."; exit 1; }

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null
then
    echo "Python 3 is not installed. Please install Python 3 and try again."
    exit 1
fi

# Create a virtual environment
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate

# Install dependencies
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "requirements.txt not found. Skipping dependency installation."
fi

# Create an alias to run the diceware script
# Add the alias to the shell configuration file (.bashrc, .zshrc, etc.)
SHELL_CONFIG="$HOME/.bashrc"  # Change this to .zshrc if you're using Zsh
ALIAS_COMMAND="alias diceware_gen='$(pwd)/venv/bin/python3 $(pwd)/diceware_2.0.py'"

# Check if the alias already exists
if ! grep -Fxq "$ALIAS_COMMAND" "$SHELL_CONFIG"; then
    echo "$ALIAS_COMMAND" >> "$SHELL_CONFIG"
    echo "Alias 'diceware_gen' added to $SHELL_CONFIG."
else
    echo "Alias 'diceware_gen' already exists in $SHELL_CONFIG."
fi

# Deactivate the virtual environment
deactivate

# Source the shell configuration file to apply the alias immediately
source "$SHELL_CONFIG"

echo "Setup completed successfully. You can now run the script using 'diceware_gen'."

echo "NOTE: If 'diceware_gen' is not running, please run 'source $SHELL_CONFIG' to apply the alias in your current shell session."


