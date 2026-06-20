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
let mapleader = " "

" Semantic navigation
map gd <Action>(GotoDeclaration)
map gi <Action>(GotoImplementation)
map <C-o> <Action>(Back)

" Inspect code shape / hierarchy
map <leader>s <Action>(FileStructurePopup)
map <leader>h <Action>(TypeHierarchy)

" Common IDE workflows
map <leader>u <Action>(FindUsages)
map <leader>r <Action>(RenameElement)

" Discover method-navigation action IDs in your GoLand build:
"   :actionlist method
" Then add, for example:
"   map ]m <Action>(YourExactActionId)
"   map [m <Action>(YourExactActionId)
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
