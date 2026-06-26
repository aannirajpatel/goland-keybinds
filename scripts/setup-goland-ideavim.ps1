# Safe, non-destructive GoLand + IdeaVim bootstrap for Windows.
#
# Run:
#   Set-ExecutionPolicy -Scope Process Bypass
#   .\scripts\setup-goland-ideavim.ps1

[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

function Write-Info([string]$Message) {
    Write-Host $Message -ForegroundColor Cyan
}

function Write-Ok([string]$Message) {
    Write-Host $Message -ForegroundColor Green
}

$ideaVimRc = Join-Path $HOME '.ideavimrc'
$snippetDir = Join-Path $HOME '.config\ideavim'
$snippetPath = Join-Path $snippetDir 'goland-cross-platform.vim'
$backupDir = Join-Path (Join-Path $HOME 'goland-keybinds-backups') (Get-Date -Format 'yyyyMMdd-HHmmss')

$goLandProcesses = Get-Process -ErrorAction SilentlyContinue |
    Where-Object { $_.ProcessName -match '^goland(64)?$' }

if ($goLandProcesses -and -not $Force) {
    throw 'GoLand appears to be running. Quit it, then rerun this script. Use -Force only if you understand the risk.'
}

New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
New-Item -ItemType Directory -Path $snippetDir -Force | Out-Null

if (Test-Path -LiteralPath $ideaVimRc) {
    Copy-Item -LiteralPath $ideaVimRc -Destination (Join-Path $backupDir '.ideavimrc') -Force
}

if (Test-Path -LiteralPath $snippetPath) {
    Copy-Item -LiteralPath $snippetPath -Destination (Join-Path $backupDir 'goland-cross-platform.vim') -Force
}

$snippet = @'
" GoLand + IdeaVim cross-platform mappings.
" Use nmap with <Action>(...) because IdeaVim does not support <Action> with noremap.
let mapleader = " "
set clipboard+=unnamedplus

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
'@

Set-Content -LiteralPath $snippetPath -Value $snippet -Encoding utf8

$sourceLine = 'source ~/.config/ideavim/goland-cross-platform.vim'

if (Test-Path -LiteralPath $ideaVimRc) {
    $existing = Get-Content -LiteralPath $ideaVimRc -Raw
    if ($existing -notmatch [regex]::Escape($sourceLine)) {
        Add-Content -LiteralPath $ideaVimRc -Value ("`r`n" + $sourceLine + "`r`n") -Encoding utf8
        Write-Info 'Added source line to existing ~/.ideavimrc.'
    }
    else {
        Write-Info 'Existing ~/.ideavimrc already sources the GoLand snippet.'
    }
}
else {
    Set-Content -LiteralPath $ideaVimRc -Value ($sourceLine + "`r`n") -Encoding utf8
    Write-Info 'Created ~/.ideavimrc.'
}

Write-Ok 'Done.'
Write-Host "Snippet: $snippetPath"
Write-Host "Config:  $ideaVimRc"
Write-Host "Backup:  $backupDir"
