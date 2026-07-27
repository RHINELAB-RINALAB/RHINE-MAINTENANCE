# Force TLS 1.2 / 1.3 for secure downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

Write-Host "==> Installing cargo-binstall for fast Windows binary retrieval..." -ForegroundColor Green
cargo install cargo-binstall --no-track

$packages = @(
    "mdbook",
    "mdbook-admonish",
    "mdbook-tabs",
    "mdbook-pagetoc",
    "mdbook-toc",
    "mdbook-collapsible-code-blocks",
    "mdbook-wikilink",
    "mdbook-content-collections",
    "mdbook-glossary",
    "mdbook-abbr",
    "mdbook-index",
    "mdbook-gitinfo",
    "mdbook-anchors-aweigh",
    "mdbook-rss-feed",
    "mdbook-mermaid",
    "mdbook-plantuml",
    "mdbook-d2",
    "mdbook-graphviz",
    "mdbook-kroki",
    "mdbook-railroad",
    "mdbook-rustviz",
    "mdbook-katex",
    "mdbook-mathjax",
    "mdbook-typst-math",
    "mdbook-include-rs",
    "mdbook-treesitter",
    "mdbook-inline-highlighting",
    "mdbook-files",
    "mdbook-quiz",
    "mdbook-cmdrun",
    "mdbook-lang",
    "mdbook-exercise",
    "mdbook-variables",
    "mdbook-minijinja",
    "mdbook-shiftinclude",
    "mdbook-embed",
    "mdbook-i18n-helpers",
    "mdbook-open-on-gh",
    "mdbook-linkcheck",
    "mdbook-image-size",
    "mdbook-numthm"
)

Write-Host "==> Downloading and installing mdBook + all preprocessors..." -ForegroundColor Green
foreach ($pkg in $packages) {
    Write-Host "Installing $pkg..." -ForegroundColor Yellow
    cargo binstall $pkg --no-confirm
}

Write-Host "==> Creating required asset directories..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path "theme" | Out-Null
New-Item -ItemType Directory -Force -Path "css" | Out-Null

Write-Host "==> Downloading Catppuccin theme stylesheets..." -ForegroundColor Green
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/catppuccin/mdbook/main/theme/catppuccin.css" -OutFile "theme/catppuccin.css"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/catppuccin/mdbook/main/theme/catppuccin-admonish.css" -OutFile "theme/catppuccin-admonish.css"

if (-not (Test-Path "css/custom1.css")) {
    New-Item -ItemType File -Path "css/custom1.css" | Out-Null
}

Write-Host "==> Injecting CSS/JS assets into theme directory..." -ForegroundColor Green
mdbook-admonish install .

Write-Host "==> Setup complete! Executing build verification..." -ForegroundColor Green
mdbook build