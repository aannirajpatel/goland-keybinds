# goland-keybinds

Small GoLand + IdeaVim setup for people switching between Windows and macOS.

It keeps OS-level shortcuts native, then puts GoLand code navigation behind portable IdeaVim mappings:

- `Space s`: file structure
- `Space h`: type hierarchy
- `Space u`: find usages
- `Space r`: rename
- `gd`: declaration
- `gi`: implementation
- `Ctrl-o`: back

## Windows

Install IdeaVim in GoLand first, then run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\setup-goland-ideavim.ps1
```

## macOS

Install IdeaVim in GoLand first, then run:

```sh
chmod +x scripts/setup-goland-ideavim.sh
./scripts/setup-goland-ideavim.sh
```

## Manual GoLand Keymap

Create a custom keymap in GoLand and bind these application-level shortcuts:

| Action | Windows | macOS |
| --- | --- | --- |
| Show Settings | `Ctrl+,` | `Cmd+,` |
| Close Active Editor | `Ctrl+W` | `Cmd+W` |
| Back | `Alt+Left` | `Cmd+[` |
| Forward | `Alt+Right` | `Cmd+]` |

The scripts intentionally do not edit GoLand keymap XML or install plugins.
