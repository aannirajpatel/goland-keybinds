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
" Use nmap with <Action>(...) because IdeaVim does not support <Action> with noremap.
let mapleader = " "

" Semantic navigation
nmap gd <Action>(GotoDeclaration)
nmap gi <Action>(GotoImplementation)
nmap <C-o> <Action>(Back)
nmap <C-i> <Action>(Forward)
nmap <C-g> <Action>(EditorEscape)

" Inspect code shape / hierarchy
nmap <leader>s <Action>(FileStructurePopup)
nmap <leader>h <Action>(TypeHierarchy)

" Common IDE workflows
nmap <leader>u <Action>(FindUsages)
nmap <leader>r <Action>(RenameElement)
nmap <leader>t <Action>(ActivateTerminalToolWindow)
nmap <leader>w <Action>(CloseEditor)
nmap <leader>p <Action>(GotoFile)
nmap <leader>e <Action>(SearchEverywhere)
nmap <leader>1 <Action>(ActivateProjectToolWindow)

" Explicit Space mappings.
nmap <Space>s <Action>(FileStructurePopup)
nmap <Space>h <Action>(TypeHierarchy)
nmap <Space>u <Action>(FindUsages)
nmap <Space>r <Action>(RenameElement)
nmap <Space>t <Action>(ActivateTerminalToolWindow)
nmap <Space>w <Action>(CloseEditor)
nmap <Space>p <Action>(GotoFile)
nmap <Space>e <Action>(SearchEverywhere)
nmap <Space>1 <Action>(ActivateProjectToolWindow)

" Explicit backslash mappings.
nmap <Bslash>s <Action>(FileStructurePopup)
nmap <Bslash>h <Action>(TypeHierarchy)
nmap <Bslash>u <Action>(FindUsages)
nmap <Bslash>r <Action>(RenameElement)
nmap <Bslash>t <Action>(ActivateTerminalToolWindow)
nmap <Bslash>w <Action>(CloseEditor)
nmap <Bslash>p <Action>(GotoFile)
nmap <Bslash>e <Action>(SearchEverywhere)
nmap <Bslash>1 <Action>(ActivateProjectToolWindow)

" Discover action IDs in your GoLand build:
"   :actionlist close
"   :actionlist method
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
