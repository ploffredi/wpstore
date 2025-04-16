# WPStore CLI Translation Patches

This repository contains Kustomize patches for managing translations of multiple WPStore CLI plugins. The patches follow the JSON Patch format and are designed to be applied directly to each plugin's base YAML file.

## Repository Structure

```
00000000-0000-0000-0000-000000000000/  # Builtin plugin UUID directory
└── 1.0.0/                           # Version directory
    ├── builtin.yml                  # Base plugin definition
    └── _patches/                    # Patches directory
        ├── kustomization.yml        # Kustomize config for builtin
        └── translations/            # Translations for builtin
            ├── en.yml               # English translations
            ├── es.yml               # Spanish translations
            └── it.yml               # Italian translations

123e4567-e89b-12d3-a456-426614174001/  # Hello plugin UUID directory
├── 0.1.0/                           # Version directory (current)
│   ├── hello.yml                    # Base plugin definition
│   └── _patches/                    # Patches directory
│       ├── kustomization.yml        # Kustomize config for hello
│       └── translations/            # Translations for hello
│           ├── en.yml               # English translations
│           ├── es.yml               # Spanish translations
│           └── it.yml               # Italian translations
└── 0.0.1/                           # Version directory (previous)
    ├── hello.yml                    # Base plugin definition
    └── _patches/                    # Patches directory
        ├── kustomization.yml        # Kustomize config for hello
        └── translations/            # Translations for hello
            ├── en.yml               # English translations
            ├── es.yml               # Spanish translations
            └── it.yml               # Italian translations

123e4567-e89b-12d3-a456-426614174000/  # Pkgmanager plugin UUID directory
└── 1.0.0/                           # Version directory
    ├── pkgmanager.yml               # Base plugin definition
    └── _patches/                    # Patches directory
        ├── kustomization.yml        # Kustomize config for pkgmanager
        └── translations/            # Translations for pkgmanager
            ├── en.yml               # English translations
            ├── es.yml               # Spanish translations
            └── it.yml               # Italian translations

_patches/                            # Main configuration patches directory
├── kustomization.yml                # Kustomize config for plugins.yml
└── translations/                    # Translations for plugins.yml
    ├── en.yml                       # English translations
    ├── es.yml                       # Spanish translations
    └── it.yml                       # Italian translations

plugins.yml                          # Main plugins configuration
apply-translation.sh                 # Helper script for applying translations
```

## Available Plugins and Configurations

- builtin - Built-in commands for WPStore CLI
- hello - Test plugin that prints greetings (version 0.1.0)
- hello-0.0.1 - Test plugin that prints greetings (previous version 0.0.1)
- pkgmanager - Package manager plugin
- plugins - Main plugins configuration file (plugins.yml)

## Available Languages

- English (en)
- Spanish (es)
- Italian (it)

## How to Use

### Prerequisites

- Kustomize installed (v3.8.0 or higher) - for Kustomize method
- Bash shell (for the helper script)
- Python 3.12+ with pip (for the Python CLI tool)

### Applying Translations

#### Option 1: Using the Python CLI Tool (Recommended)

Install the Python CLI tool:

```bash
# From the project directory
pip install -e .
```

Apply translations using the CLI tool:

```bash
# Apply translations to plugins
wpstore-patch apply-translation builtin 1.0.0 es     # Apply Spanish translations to the builtin plugin
wpstore-patch apply-translation hello 0.0.1 it       # Apply Italian translations to the hello plugin
wpstore-patch apply-translation pkgmanager 1.0.0 en  # Apply English translations to the pkgmanager plugin

# With custom output file
wpstore-patch apply-translation builtin 1.0.0 es --output custom-output.yml
```

Validate translations using the CLI tool:

```bash
# Validate translations
wpstore-patch validate-patch builtin 1.0.0 es
wpstore-patch validate-patch hello 0.0.1 it --dry-run  # With operation details
```

For more information, see the [CLI tool documentation](./wpstore/README.md).

#### Option 2: Using the Bash Helper Script

Run the provided helper script with the plugin name and language:

```bash
# Apply translations to plugins
./apply-translation.sh builtin es     # Apply Spanish translations to the builtin plugin
./apply-translation.sh hello it       # Apply Italian translations to the hello plugin
./apply-translation.sh pkgmanager en  # Apply English translations to the pkgmanager plugin

# Apply translations to plugins.yml configuration
./apply-translation.sh plugins es     # Apply Spanish translations to plugins.yml
```

This will:
1. Select the appropriate plugin or configuration
2. Apply the specified language translation
3. Generate an output file with a descriptive name (e.g., `builtin-es.yml`, `plugins-es.yml`)

#### Option 3: Manual Application with Kustomize

1. Navigate to the plugin's _patches directory:

```bash
cd 00000000-0000-0000-0000-000000000000/1.0.0/_patches  # For builtin plugin
# OR
cd _patches  # For plugins.yml
```

2. Edit the `kustomization.yml` file to uncomment the language translation you want to apply:

```yaml
# Language selection - uncomment one to apply
patchesStrategicMerge:
  # - translations/en.yml
  - translations/es.yml  # Uncomment this line for Spanish
  # - translations/it.yml
```

3. Run Kustomize from within the _patches directory:

```bash
kustomize build --load-restrictor LoadRestrictionsNone . > ../../../builtin-es.yml
# OR for plugins.yml
kustomize build --load-restrictor LoadRestrictionsNone . > ../plugins-es.yml
```

### Adding a New Plugin

1. Create a directory structure following the pattern: `<plugin-uuid>/<version>/`
2. Add the base plugin definition YAML file in the version directory
3. Create an `_patches` directory with a `kustomization.yml` file pointing to the plugin's base YAML file
4. Create a `translations` subdirectory inside `_patches` with translation files for each language (e.g., `en.yml`, `es.yml`, etc.)
5. Update the plugin directory mapping in the `apply-translation.sh` script

### Adding a New Language

1. Create new translation files for each plugin in their respective `_patches/translations` directory
2. Add the language code to the supported languages list in each plugin's kustomization file
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
