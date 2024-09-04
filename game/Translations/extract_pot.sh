#!/bin/bash

# NOTE: This script needs to be run within a Python virtual environment (venv):
#
# python3 -m venv env
# source env/bin/activate
# ./extract_pot.sh
# deactivate

# Install the Python packages.
pip3 install -r requirements.txt

# Extract the .pot file.
pybabel extract -F babelrc.txt -k text -k LineEdit/placeholder_text -k tr \
    -k load_button_text -k status_text_one -k status_text_multiple -k hint_tooltip \
    -k window_title -o godot-l10n.pot ..
