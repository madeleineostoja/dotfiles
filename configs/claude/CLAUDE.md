## Rules

- Always read documentation and search for reported bugs before going through source code
- If available, always use the Context7 MCP when you need documentation
- Avoid writing superfluous comments that state what is obvious from reading code
- Always confirm implementation plans with the user before writing any code or requesting changes. When the user responds to multiple items, read each response individually — questions or pushback on an item are not approval.

## Context efficient commands

Wrap bash commands with output suppression to preserve context window:

```bash
output=$(<command> 2>&1) && echo "✓ <description>" || { echo "✗ <description>"; echo "$output"; false; }
```

Only show full output on failure.

## Tool Preferences

The following non-standard CLI tools are available for you to use:

- Use `rg` instead of `grep` (example: `rg "pattern"` instead of `grep -r "pattern"`)
- Use `fd` instead of `find` (example: `fd "filename"` instead of `find . -name "filename"`)
- Use `gh` for interacting with Github
