# goland-keybinds

Small GoLand + IdeaVim setup for people switching between Windows and macOS.

It keeps OS-level shortcuts native, then puts GoLand code navigation behind portable IdeaVim mappings. The scripts map both `<leader>` and explicit `<Space>` forms so `Space w` works even if leader expansion is not behaving in a local IdeaVim build.

- `Space s`: file structure
- `Space h`: type hierarchy
- `Space u`: find usages
- `Space r`: rename
- `Space t`: terminal
- `Space w`: close editor tab
- `Space p`: go to file/path
- `Space e`: search everywhere
- `Space 1`: project sidebar
- `gd`: declaration
- `gi`: implementation
- `Ctrl-o`: back
- `Ctrl-i`: forward
- `Ctrl-g`: cancel active popup via JetBrains `EditorEscape`

The same commands are also mapped with a backslash prefix, such as `\w`, `\p`, `\e`, and `\1`.

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
| Back | `Alt+Left` | `Cmd+[` |
| Forward | `Alt+Right` | `Cmd+]` |

Leave `Ctrl+W` with Vim so it remains the Vim window-command prefix. Use `Space w` or `\w` to close the active editor tab.

The scripts intentionally do not edit GoLand keymap XML or install plugins.
