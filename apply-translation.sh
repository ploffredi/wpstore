#!/bin/bash

# Script to apply translations for WPStore CLI plugins
# Usage: ./apply-translation.sh <plugin_name> <language>
# Example: ./apply-translation.sh builtin es

if [ $# -lt 2 ]; then
  echo "Usage: $0 <plugin_name> <language>"
  echo "Available plugins: builtin, hello, pkgmanager"
  echo "Available languages: en, es, it"
  exit 1
fi

PLUGIN=$1
LANG=$2

# Plugin directory mapping
declare -A PLUGIN_DIRS
PLUGIN_DIRS["builtin"]="00000000-0000-0000-0000-000000000000/1.0.0"
PLUGIN_DIRS["hello"]="123e4567-e89b-12d3-a456-426614174001/0.1.0"
PLUGIN_DIRS["pkgmanager"]="123e4567-e89b-12d3-a456-426614174000/1.0.0"

# Verify plugin exists
if [ -z "${PLUGIN_DIRS[$PLUGIN]}" ]; then
  echo "Error: Unknown plugin '$PLUGIN'."
  echo "Available plugins: builtin, hello, pkgmanager"
  exit 1
fi

PLUGIN_DIR="${PLUGIN_DIRS[$PLUGIN]}"
TRANSLATION_FILE="${PLUGIN_DIR}/translations/${LANG}.yml"
OUTPUT_FILE="${PLUGIN}-${LANG}.yml"

# Check if plugin directory exists
if [ ! -d "$PLUGIN_DIR" ]; then
  echo "Error: Plugin directory '$PLUGIN_DIR' not found."
  exit 1
fi

# Check if translation file exists
if [ ! -f "$TRANSLATION_FILE" ]; then
  echo "Error: Translation file '$TRANSLATION_FILE' not found."
  exit 1
fi

# Create a temporary kustomization.yml
TMP_KUST="${PLUGIN_DIR}/tmp_kustomization.yml"
cp "${PLUGIN_DIR}/kustomization.yml" "$TMP_KUST"

# Update the temporary kustomization.yml to use the selected language
sed -i.bak "s|# - translations/${LANG}.yml|- translations/${LANG}.yml|g" "$TMP_KUST"

# Apply the kustomization
echo "Applying $LANG translations for $PLUGIN plugin..."
kustomize build --load-restrictor LoadRestrictionsNone "$PLUGIN_DIR" -o "$OUTPUT_FILE"

# Remove the temporary file
rm "$TMP_KUST" "${TMP_KUST}.bak"

echo "Done! Output saved to $OUTPUT_FILE"
