#!/bin/bash

# Script to apply translations for WPStore CLI plugins
# Usage: ./apply-translation.sh <plugin_name> <version> <language>
# Example: ./apply-translation.sh hello 0.1.0 es

if [ $# -lt 3 ]; then
  echo "Usage: $0 <plugin_name> <version> <language>"
  echo "Example: $0 hello 0.1.0 es"
  echo "Available plugins: builtin, hello, pkgmanager, plugins"
  echo "Available languages: en, es, it"
  exit 1
fi

PLUGIN=$1
VERSION=$2
LANG=$3

# Plugin UUID mapping
declare -A PLUGIN_UUIDS
PLUGIN_UUIDS["builtin"]="00000000-0000-0000-0000-000000000000"
PLUGIN_UUIDS["hello"]="123e4567-e89b-12d3-a456-426614174001"
PLUGIN_UUIDS["pkgmanager"]="123e4567-e89b-12d3-a456-426614174000"
PLUGIN_UUIDS["plugins"]=""  # Root directory

# Verify plugin exists
if [ -z "${PLUGIN_UUIDS[$PLUGIN]}" ] && [ "$PLUGIN" != "plugins" ]; then
  echo "Error: Unknown plugin '$PLUGIN'."
  echo "Available plugins: builtin, hello, pkgmanager, plugins"
  exit 1
fi

# Set the paths based on the plugin and version
if [ "$PLUGIN" == "plugins" ]; then
  PLUGIN_DIR="_patches"
  OUTPUT_FILE="plugins-${LANG}.yml"
else
  PLUGIN_UUID="${PLUGIN_UUIDS[$PLUGIN]}"
  PLUGIN_DIR="${PLUGIN_UUID}/${VERSION}/_patches"
  OUTPUT_FILE="${PLUGIN}-${VERSION}-${LANG}.yml"
fi

TRANSLATION_FILE="${PLUGIN_DIR}/translations/${LANG}.yml"

# Check if plugin directory exists
if [ ! -d "$PLUGIN_DIR" ]; then
  echo "Error: Plugin directory '$PLUGIN_DIR' not found. Check that the plugin and version exist."
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
echo "Applying $LANG translations for $PLUGIN version $VERSION..."
kustomize build --load-restrictor LoadRestrictionsNone "$PLUGIN_DIR" -o "$OUTPUT_FILE"

# Remove the temporary file
rm "$TMP_KUST" "${TMP_KUST}.bak"

echo "Done! Output saved to $OUTPUT_FILE"
