# General

- I prefer readable code that I can go back to after a long time and still be able to understand it.
- Use "current datetime" for chat titles.
- Show code before explanations.
- Avoid Nano; use Vim-compatible instructions.
- ESLint: Follow 'plugin:@typescript-eslint/strict-type-checked'.

# TypeScript

- Use unknown instead of any.
- Prefer interfaces (prefix with "I") over types.
- Wrap variables in String() when interpolating.
- Avoid unnecessary type casts.
- Handle null, undefined, 0, or NaN explicitly.
- Always use braces for void arrow functions.

# React

- Use function components only.
- Include all dependencies in hooks.
- Fix click handlers on non-interactive elements.

# Formatting

- Block Comments: Use `/* This is a comment */` for inline comments.
- SQL: Use heredoc syntax.

# Bash

- Avoid grep; prefer awk.
- Follow this structure in script files:

  ```bash
  #!/bin/bash
  # Global variables here
  main() {
      action1
  }
  action1() {
      echo -e "Action 1"
  }
  main
  ```
- Omit unused global variables.