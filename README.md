# Bring Skill for Hermes

Use this skill to manage [Bring!](https://www.getbring.com/) shopping lists from Hermes. It can list shopping lists, show list items, add one or more groceries, check off bought items, and remove items through the bundled CLI.

## Installation

### Managed skill directory (via Hermes CLI)

```bash
hermes skills install nhranitzky/bring-skill/bring
```

> **Note:** The installation may be blocked by default:
> ```
> Installation blocked: Blocked (community source + caution verdict, 2 findings).
> Use --force to override.
> ```
> This is expected because the skill requires sensitive environment variables (`BRING_EMAIL`, `BRING_PASSWORD`).
> Review the source code, then install with:

```bash
hermes skills install nhranitzky/bring-skill/bring --force
```

### Custom directory (skills.external_dirs)

```bash
git clone https://github.com/nhranitzky/bring-skill.git
cd bring-skill
./install-skill.sh /path/to/target   # installs into /path/to/target/bring/
```

The install script will ask for confirmation before replacing an existing `/path/to/target/bring/` directory.

## Configuration

Add the following variables to your Hermes `.env` file:

```dotenv
BRING_EMAIL=you@example.com       # Bring! account email address
BRING_PASSWORD=<your-password>    # Bring! account password
BRING_LIST=Weekly groceries       # optional default list name or UUID
```

`BRING_EMAIL` and `BRING_PASSWORD` are required for all commands. `BRING_LIST` is optional; when omitted, agents should pass an explicit list name or UUID.


## License

MIT

## Creation

Created with the help of an AI coding tool, then human reviewed and tested.
