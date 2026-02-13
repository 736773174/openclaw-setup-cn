# ─────────────────────────────────────────────
# OpenClaw One-Click Installer (Windows)
# Installs Node.js + OpenClaw, runs natively
# ─────────────────────────────────────────────

function Write-Info($msg)    { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Ok($msg)      { Write-Host "[DONE] $msg" -ForegroundColor Green }
function Write-Warn($msg)    { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err($msg)     { Write-Host "[ERROR] $msg" -ForegroundColor Red; throw $msg }

function Write-Header {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor White
    Write-Host "  OpenClaw One-Click Installer (Windows)" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor White
    Write-Host ""
}

try {

Write-Header

# ─────────────────────────────────────────────
# Step 1: Check / Install Node.js 22+
# ─────────────────────────────────────────────
Write-Info "Checking Node.js..."

$needsNode = $true

try {
    $nodeVersion = (node -v 2>$null)
    if ($nodeVersion -match "v(\d+)") {
        $major = [int]$Matches[1]
        if ($major -ge 22) {
            Write-Ok "Found Node.js $nodeVersion"
            $needsNode = $false
        } else {
            Write-Warn "Found Node.js $nodeVersion, but v22+ is required. Upgrading..."
        }
    }
} catch {
    Write-Warn "Node.js not found."
}

if ($needsNode) {
    Write-Info "Installing Node.js 22..."

    $installed = $false

    # Method 1: winget (built into Windows 11 / Windows 10)
    if (-not $installed -and (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Info "Installing via winget..."
        winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements 2>$null
        if ($LASTEXITCODE -eq 0) {
            $installed = $true
            Write-Ok "Node.js installed via winget"
        }
    }

    # Method 2: Chocolatey
    if (-not $installed -and (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Info "Installing via Chocolatey..."
        choco install nodejs-lts -y 2>$null
        if ($LASTEXITCODE -eq 0) {
            $installed = $true
            Write-Ok "Node.js installed via Chocolatey"
        }
    }

    # Method 3: Manual download prompt
    if (-not $installed) {
        Write-Err "Could not install Node.js automatically. Please install manually and re-run this script:`n`n  Download: https://nodejs.org/en/download/`n`n  After installing, reopen PowerShell and run this script again."
    }

    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    # Verify installation
    try {
        $nodeVersion = (node -v 2>$null)
        Write-Ok "Node.js $nodeVersion installed successfully"
    } catch {
        Write-Err "Node.js verification failed after install. Please close and reopen PowerShell, then try again."
    }
}

# ─────────────────────────────────────────────
# Step 2: Check / Install Git
# ─────────────────────────────────────────────
Write-Info "Checking Git..."

if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Ok "Found Git."
} else {
    Write-Info "Installing Git (required by OpenClaw dependencies)..."

    $gitInstalled = $false

    if (-not $gitInstalled -and (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Info "Installing Git via winget..."
        winget install Git.Git --accept-package-agreements --accept-source-agreements 2>$null
        if ($LASTEXITCODE -eq 0) {
            $gitInstalled = $true
            Write-Ok "Git installed via winget"
        }
    }

    if (-not $gitInstalled -and (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Info "Installing Git via Chocolatey..."
        choco install git -y 2>$null
        if ($LASTEXITCODE -eq 0) {
            $gitInstalled = $true
            Write-Ok "Git installed via Chocolatey"
        }
    }

    # Method 3: Direct download and silent install
    if (-not $gitInstalled) {
        Write-Info "Downloading Git installer directly..."
        $gitInstaller = Join-Path $env:TEMP "git-installer.exe"
        try {
            $releases = Invoke-RestMethod "https://api.github.com/repos/git-for-windows/git/releases/latest" -ErrorAction Stop
            $asset = $releases.assets | Where-Object { $_.name -match "Git-.*-64-bit\.exe$" } | Select-Object -First 1
            if ($asset) {
                Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $gitInstaller -ErrorAction Stop
                Write-Info "Installing Git silently..."
                Start-Process -FilePath $gitInstaller -ArgumentList "/VERYSILENT", "/NORESTART", "/NOCANCEL", "/SP-", "/CLOSEAPPLICATIONS", "/RESTARTAPPLICATIONS" -Wait
                Remove-Item $gitInstaller -Force -ErrorAction SilentlyContinue
                $gitInstalled = $true
                Write-Ok "Git installed via direct download"
            }
        } catch {
            Write-Warn "Direct download failed: $_"
        }
    }

    if (-not $gitInstalled) {
        Write-Err "Could not install Git automatically. Please install manually and re-run this script:`n`n  Download: https://git-scm.com/download/win`n`n  After installing, reopen PowerShell and run this script again."
    }

    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# ─────────────────────────────────────────────
# Step 3: Install OpenClaw
# ─────────────────────────────────────────────
Write-Info "Checking OpenClaw..."

$needsInstall = $true

try {
    $null = Get-Command openclaw -ErrorAction Stop
    Write-Ok "Found OpenClaw."
    $needsInstall = $false
} catch {
    Write-Info "Installing OpenClaw..."
}

if ($needsInstall) {
    npm install -g openclaw@latest 2>&1 | Write-Host
    if ($LASTEXITCODE -ne 0) {
        Write-Err "OpenClaw installation failed. Please run manually: npm install -g openclaw@latest"
    }

    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    # Add npm global bin to PATH
    try {
        $npmPrefix = (npm config get prefix 2>$null).Trim()
        if ($npmPrefix) {
            $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
            if (-not ($userPath -split ";" | Where-Object { $_ -ieq $npmPrefix })) {
                [Environment]::SetEnvironmentVariable("Path", "$userPath;$npmPrefix", "User")
                $env:Path += ";$npmPrefix"
            }
        }
    } catch {}

    Write-Ok "OpenClaw installed."
}

# ─────────────────────────────────────────────
# Step 3: Launch interactive setup
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  OpenClaw installed! Starting setup..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Tip: When the setup wizard asks for a provider," -ForegroundColor White
Write-Host "  choose MiniMax for a 7-day free trial - no credit card needed." -ForegroundColor White
Write-Host "  Sign up: https://platform.minimax.io" -ForegroundColor Cyan
Write-Host ""

openclaw onboard --accept-risk --flow quickstart --node-manager npm --skip-skills

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor White
Write-Host "    1. Navigate to your project: cd your-project-path" -ForegroundColor Gray
Write-Host "    2. Start OpenClaw: openclaw" -ForegroundColor Gray
Write-Host "    3. Add skills (optional): openclaw configure --section skills" -ForegroundColor Gray
Write-Host "    4. Browse available skills: openclaw skills" -ForegroundColor Gray
Write-Host ""

} catch {
    Write-Host ""
    Write-Host "[ERROR] Script failed: $_" -ForegroundColor Red
    Write-Host ""
} finally {
    Write-Host ""
    Read-Host "Press Enter to close this window"
}
