# WPStore CLI Translation Patches

This repository contains Kustomize patches for managing translations of multiple WPStore CLI plugins. The patches follow the JSON Patch format and are designed to be applied directly to each plugin's base YAML file.

## Repository Structure

```
00000000-0000-0000-0000-000000000000/  # Builtin plugin UUID directory
└── 1.0.0/                           # Version directory
    ├── builtin.yml                  # Base plugin definition
    ├── kustomization.yml            # Kustomize config for builtin
    └── translations/                # Translations for builtin
        ├── en.yml                   # English translations
        ├── es.yml                   # Spanish translations
        └── it.yml                   # Italian translations

123e4567-e89b-12d3-a456-426614174001/  # Hello plugin UUID directory
└── 0.1.0/                           # Version directory
    ├── hello.yml                    # Base plugin definition
    ├── kustomization.yml            # Kustomize config for hello
    └── translations/                # Translations for hello
        ├── en.yml                   # English translations
        ├── es.yml                   # Spanish translations
        └── it.yml                   # Italian translations

123e4567-e89b-12d3-a456-426614174000/  # Pkgmanager plugin UUID directory
└── 1.0.0/                           # Version directory
    ├── pkgmanager.yml               # Base plugin definition
    ├── kustomization.yml            # Kustomize config for pkgmanager
    └── translations/                # Translations for pkgmanager
        ├── en.yml                   # English translations
        ├── es.yml                   # Spanish translations
        └── it.yml                   # Italian translations

apply-translation.sh                  # Helper script for applying translations
```

## Available Plugins

- builtin - Built-in commands for WPStore CLI
- hello - Test plugin that prints greetings
- pkgmanager - Package manager plugin

## Available Languages

- English (en)
- Spanish (es)
- Italian (it)

## How to Use

### Prerequisites

- Kustomize installed (v3.8.0 or higher)
- Bash shell (for the helper script)

### Applying Translations for a Plugin

#### Option 1: Using the Helper Script (Recommended)

Run the provided helper script with the plugin name and language:

```bash
./apply-translation.sh builtin es  # Apply Spanish translations to the builtin plugin
```

This will:
1. Select the appropriate plugin
2. Apply the specified language translation
3. Generate an output file named `<plugin>-<language>.yml` (e.g., `builtin-es.yml`)

#### Option 2: Manual Application

1. Navigate to the plugin version directory:

```bash
cd 00000000-0000-0000-0000-000000000000/1.0.0  # For builtin plugin
```

2. Edit the plugin's `kustomization.yml` file to uncomment the language translation you want to apply:

```yaml
# Language selection - uncomment one to apply
patchesStrategicMerge:
  # - translations/en.yml
  - translations/es.yml  # Uncomment this line for Spanish
  # - translations/it.yml
```

3. Run Kustomize from within the plugin directory:

```bash
kustomize build --load-restrictor LoadRestrictionsNone . > ../../builtin-es.yml
```

### Adding a New Plugin

1. Create a directory structure following the pattern: `<plugin-uuid>/<version>/`
2. Add the base plugin definition YAML file in the version directory
3. Create a `kustomization.yml` file in the version directory pointing to the plugin's base YAML file
4. Create a `translations` subdirectory with translation files for each language (e.g., `en.yml`, `es.yml`, etc.)
5. Update the plugin directory mapping in the `apply-translation.sh` script

### Adding a New Language

1. Create new translation files for each plugin in their respective `translations` directory (e.g., `00000000-0000-0000-0000-000000000000/1.0.0/translations/fr.yml`)
2. Add the language code to the supported languages list in each plugin's kustomization file:

```yaml
configMapGenerator:
  - name: builtin-translation-config
    literals:
      - plugin_name=builtin
      - plugin_version=1.0.0
      - supported_languages=en,es,it,fr
```

3. Update the helper script to include the new language in its help text

## Translation File Format

Each language translation file uses the JSON Patch format and contains:

- Replacements for existing plugin descriptions, commands, examples, arguments, and flags
- Additions for new commands or features that don't exist in the base file

Example translation operation:

```yaml
- op: replace
  path: /description
  value: "Built-in commands for WPStore CLI following SAI standards"
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
