#!/usr/bin/env sh
set -eu

# Safe, non-destructive GoLand + IdeaVim bootstrap for macOS.
#
# Run:
#   chmod +x scripts/setup-goland-ideavim.sh
#   ./scripts/setup-goland-ideavim.sh

idea_vim_rc="$HOME/.ideavimrc"
snippet_dir="$HOME/.config/ideavim"
snippet_path="$snippet_dir/goland-cross-platform.vim"
backup_dir="$HOME/goland-keybinds-backups/$(date +%Y%m%d-%H%M%S)"
source_line='source ~/.config/ideavim/goland-cross-platform.vim'

mkdir -p "$backup_dir" "$snippet_dir"

if [ -f "$idea_vim_rc" ]; then
  cp "$idea_vim_rc" "$backup_dir/.ideavimrc"
fi

if [ -f "$snippet_path" ]; then
  cp "$snippet_path" "$backup_dir/goland-cross-platform.vim"
fi

cat > "$snippet_path" <<'EOF'
" GoLand + IdeaVim cross-platform mappings.
let mapleader = " "

" Semantic navigation
map gd <Action>(GotoDeclaration)
map gi <Action>(GotoImplementation)
map <C-o> <Action>(Back)
map <C-i> <Action>(Forward)

" Inspect code shape / hierarchy
map <leader>s <Action>(FileStructurePopup)
map <leader>h <Action>(TypeHierarchy)

" Common IDE workflows
map <leader>u <Action>(FindUsages)
map <leader>r <Action>(RenameElement)
map <leader>t <Action>(ActivateTerminalToolWindow)
map <leader>w <Action>(CloseEditor)
map <leader>p <Action>(GotoFile)
map <leader>e <Action>(SearchEverywhere)

" Discover method-navigation action IDs in your GoLand build:
"   :actionlist method
" Then add, for example:
"   map ]m <Action>(YourExactActionId)
"   map [m <Action>(YourExactActionId)
EOF

if [ -f "$idea_vim_rc" ]; then
  if ! grep -Fqx "$source_line" "$idea_vim_rc"; then
    {
      printf '\n'
      printf '%s\n' "$source_line"
    } >> "$idea_vim_rc"
    printf '%s\n' 'Added source line to existing ~/.ideavimrc.'
  else
    printf '%s\n' 'Existing ~/.ideavimrc already sources the GoLand snippet.'
  fi
else
  printf '%s\n' "$source_line" > "$idea_vim_rc"
  printf '%s\n' 'Created ~/.ideavimrc.'
fi

printf '%s\n' 'Done.'
printf 'Snippet: %s\n' "$snippet_path"
printf 'Config:  %s\n' "$idea_vim_rc"
printf 'Backup:  %s\n' "$backup_dir"
