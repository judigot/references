<h1 align="center">References (Cheat Sheet)</h1>

# Apportable Setup

```sh
curl.exe -L "https://raw.githubusercontent.com/judigot/references/main/Apportable.ps1" | powershell -NoProfile -
```

# Snippets/Aliases

Append to .bashrc to always load aliases to all terminal sessions

```sh
grep -q '#<SNIPPETS>' "$HOME/.bashrc" 2>/dev/null || printf '%s\n' '#<SNIPPETS>' '[[ -f "$HOME/.snippetsrc" ]] && source "$HOME/.snippetsrc"' '#<SNIPPETS/>' >> "$HOME/.bashrc"
```