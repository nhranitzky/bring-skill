---
name: bring
description: Manage Bring! shopping lists by reading lists, showing items, adding groceries, checking off bought items, and removing entries through the bundled CLI.
version: 1.0.0
author: N.Hranitzky
license: MIT
platforms: [macos, linux]
metadata:
  hermes:
    tags: [shopping, groceries, bring, cli]
    config:
      - key: bring.default_list
        description: "Optional default Bring! shopping list name or UUID, passed through BRING_LIST."
        prompt: "Default Bring! shopping list name or UUID"
required_environment_variables:
  - name: BRING_EMAIL
    prompt: "Bring! account email address"
    required_for: "All Bring! CLI commands"
  - name: BRING_PASSWORD
    prompt: "Bring! account password"
    required_for: "All Bring! CLI commands"
---

# Bring!

Use this skill to manage Bring! shopping lists through the bundled CLI.

Run the CLI through the skill-relative executable:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli
```

`BRING_EMAIL` and `BRING_PASSWORD` must be available in the environment for all commands. Treat `BRING_PASSWORD` as a secret: never print it, log it, echo it, or include it in responses.

`BRING_LIST` may be configured as an optional default list name or UUID. Prefer explicit list names or UUIDs when the user provides them, especially before write operations. Use UUIDs for automation when available because names can be ambiguous.

For agent-internal inspection, prefer `--output json`. For direct user-facing display, text output is acceptable.

## Safety Rules

- Reads can be performed when useful for resolving context.
- Before modifying a list, ask a clarification question if the target list, item, or specification is materially ambiguous.
- Use `check-off` for bought, done, completed, checked off, or got-it intent.
- Use `remove` only when the user clearly wants an item deleted from the shopping list completely.
- Before destructive removal, show or inspect the target list first unless the user already identified the exact item and list.
- Keep quantities and package details in specifications where possible. For example, add `Milk` with `--spec "2l"` rather than adding an item named `Milk 2l`.

## List Shopping Lists

Use `lists` to discover available Bring! shopping lists and their UUIDs.

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli lists
```

Use JSON when selecting a list programmatically:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli lists --output json
```

Use this first when the user names an unknown list, when a default list may be stale, or when ambiguity matters before a write.

## Show List Items

Use `show` to display active shopping list items. Include a list name or UUID when known.

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli show "Weekly groceries"
```

Use `--include-recent` when the user wants recently bought items too:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli show "Weekly groceries" --include-recent
```

Use JSON when inspecting current state before another action:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli show "Weekly groceries" --include-recent --output json
```

If no list is provided and `BRING_LIST` is configured, the CLI can use that default:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli show
```

## Add One Item

Use `add` for one item.

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli add "Weekly groceries" "Milk"
```

Use `--spec` for quantities, package sizes, or other item specifications:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli add "Weekly groceries" "Milk" --spec "2l"
```

Use JSON when confirming the result programmatically:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli add "Weekly groceries" "Ice cream" --spec "1 tub" --output json
```

If the user omits a list and the configured default is intended, the CLI can use `BRING_LIST`:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli add "Milk" --spec "2l"
```

## Add Multiple Items

Use `add-items` for multiple items. Create a temporary JSON file containing a list of item objects or strings.

Example input file:

```json
[
  {
    "name": "Milk",
    "specification": "2l"
  },
  {
    "name": "Butter"
  },
  "Eggs"
]
```

Then call:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli add-items "Weekly groceries" /path/to/items.json
```

Use JSON when confirming the result programmatically:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli add-items "Weekly groceries" /path/to/items.json --output json
```

Although the command can fall back to `BRING_LIST`, prefer passing the list explicitly for bulk additions:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli add-items "$BRING_LIST" /path/to/items.json
```

## Check Off Bought Items

Use `check-off` when an item was bought or completed. This moves it into Bring!'s recently bought area.

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli check-off "Weekly groceries" "Milk"
```

Use JSON when confirming the result programmatically:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli check-off "Weekly groceries" "Milk" --output json
```

If the configured default list is intended:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli check-off "Milk"
```

## Remove Items

Use `remove` only when the user wants an item deleted completely from the shopping list.

Inspect the target list first when there is any ambiguity:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli show "Weekly groceries" --output json
```

Then remove the exact item:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli remove "Weekly groceries" "Milk"
```

Use JSON when confirming the result programmatically:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli remove "Weekly groceries" "Milk" --output json
```

If the configured default list is intended:

```bash
${HERMES_SKILL_DIR}/scripts/bin/bring-cli remove "Milk"
```

## Troubleshooting

- If credentials are missing, ask the user to configure `BRING_EMAIL` and `BRING_PASSWORD`.
- If no list was provided and no default exists, ask for the target list or discover lists with `lists --output json`.
- If a list name is ambiguous, use the list UUID.
- If bulk-add JSON fails, ensure the file contains a JSON array. Entries may be strings or objects with `name` and optional `specification`.
- If a Bring! API request fails, report the CLI error without exposing credentials.
