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

# Get plugin UUID based on the plugin name
get_plugin_uuid() {
  case "$1" in
    "builtin")
      echo "00000000-0000-0000-0000-000000000000"
      ;;
    "hello")
      echo "123e4567-e89b-12d3-a456-426614174001"
      ;;
    "pkgmanager")
      echo "123e4567-e89b-12d3-a456-426614174000"
      ;;
    "plugins")
      echo ""
      ;;
    *)
      echo ""
      ;;
  esac
}

# Get the plugin UUID
PLUGIN_UUID=$(get_plugin_uuid "$PLUGIN")

# Verify plugin exists
if [ -z "$PLUGIN_UUID" ] && [ "$PLUGIN" != "plugins" ]; then
  echo "Error: Unknown plugin '$PLUGIN'."
  echo "Available plugins: builtin, hello, pkgmanager, plugins"
  exit 1
fi

# Set the paths based on the plugin and version
if [ "$PLUGIN" == "plugins" ]; then
  PLUGIN_DIR="_patches"
  TRANSLATION_FILE="${PLUGIN_DIR}/translations/${LANG}.yml"
  OUTPUT_FILE="plugins-${LANG}.yml"
else
  PLUGIN_BASE_DIR="${PLUGIN_UUID}/${VERSION}"
  PLUGIN_DIR="${PLUGIN_BASE_DIR}/_patches"
  TRANSLATION_FILE="${PLUGIN_DIR}/translations/${LANG}.yml"
  OUTPUT_FILE="${PLUGIN}-${VERSION}-${LANG}.yml"
fi

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

echo "Applying $LANG translations for $PLUGIN version $VERSION..."

if [ "$PLUGIN" == "plugins" ]; then
  # For the plugins.yml, just copy the translation file
  cp "$TRANSLATION_FILE" "$OUTPUT_FILE"
else
  # For other plugins, merge the base YAML with the translations
  # Copy the original file to the output
  cp "${PLUGIN_BASE_DIR}/${PLUGIN}.yml" "$OUTPUT_FILE"

  # Append the translations from the translation file
  echo "" >> "$OUTPUT_FILE"
  echo "# Translations added from ${LANG}.yml" >> "$OUTPUT_FILE"
  cat "$TRANSLATION_FILE" >> "$OUTPUT_FILE"
fi

echo "Done! Output saved to $OUTPUT_FILE"
