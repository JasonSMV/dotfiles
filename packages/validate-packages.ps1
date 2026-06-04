# Validate UniGetUI bundle: JSON integrity + winget package existence
param(
  [string]$BundlePath = "$PSScriptRoot\packages.ubundle"
)

$errors = 0

# --- A) JSON validation ---
Write-Host "=== A) Validating JSON ==="
try {
  $bundle = Get-Content $BundlePath -Raw | ConvertFrom-Json
  $count = $bundle.packages.Count
  Write-Host "OK: valid JSON, $count packages"
} catch {
  Write-Error "FAIL: invalid JSON - $_"
  exit 1
}

# Required fields per package
$required = @("Id", "Name", "ManagerName")
$missing = @()
foreach ($pkg in $bundle.packages) {
  foreach ($field in $required) {
    if (-not $pkg.$field) {
      $missing += "$($pkg.Name): missing $field"
    }
  }
}
if ($missing.Count -gt 0) {
  $missing | ForEach-Object { Write-Error "FAIL: $_" }
  $errors += $missing.Count
} else {
  Write-Host "OK: all packages have required fields"
}

# --- B) Winget existence check ---
Write-Host ""
Write-Host "=== B) Checking winget package IDs ==="

$wingetPkgs = $bundle.packages | Where-Object { $_.ManagerName -eq "winget" -and $_.Id }
Write-Host "Checking $($wingetPkgs.Count) winget packages..."

$notFound = @()
foreach ($pkg in $wingetPkgs) {
  $result = winget show --id $pkg.Id --exact --accept-source-agreements 2>&1
  if ($LASTEXITCODE -ne 0) {
    $notFound += "$($pkg.Id) ($($pkg.Name))"
    Write-Host "  MISSING: $($pkg.Id)"
  } else {
    Write-Host "  OK: $($pkg.Id)"
  }
}

if ($notFound.Count -gt 0) {
  Write-Host ""
  Write-Host "--- Missing packages ($($notFound.Count)) ---"
  $notFound | ForEach-Object { Write-Host "  $_" }
  $errors += $notFound.Count
}

Write-Host ""
if ($errors -gt 0) {
  Write-Error "Validation failed: $errors error(s)"
  exit 1
} else {
  Write-Host "All checks passed."
  exit 0
}
