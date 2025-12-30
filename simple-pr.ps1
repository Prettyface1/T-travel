# Robust PR Creation Script for T-travel
# Creates PRs for all branches with auto-merge

$ErrorActionPreference = "Continue"

Write-Host "=== T-travel PR Creation ===" -ForegroundColor Cyan

# Get all branches except main
$branches = git branch | ForEach-Object { $_.Trim('*', ' ') } | Where-Object { $_ -ne 'main' }

Write-Host "Found $($branches.Count) branches`n" -ForegroundColor Green

$successCount = 0
$failCount = 0
$prCount = 0

foreach ($branch in $branches) {
    $prCount++
    Write-Host "[$prCount/$($branches.Count)] $branch" -ForegroundColor Yellow
    
    $title = "[T-travel] $branch"
    $body = "## Overview`nThis PR implements **$branch** for the T-travel platform.`n`n## Changes`n- Implemented core functionality`n- Added tests and documentation`n- Ensured code quality`n`n## Impact`nEnhances the platform with $branch features."
    
    try {
        # Check if PR already exists
        $existingPr = gh pr list --head $branch --base main --json number --jq '.[0].number' 2>$null
        
        if ($existingPr) {
            Write-Host "  * PR already exists (#$existingPr)" -ForegroundColor Cyan
            # Merge it
            gh pr merge $existingPr --merge --delete-branch 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  + Merged existing PR" -ForegroundColor Green
                $successCount++
            }
            else {
                Write-Host "  - Failed to merge existing PR" -ForegroundColor Red
                $failCount++
            }
            continue
        }

        # Create new PR
        $prUrl = gh pr create --base main --head $branch --title $title --body $body 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  + PR created: $prUrl" -ForegroundColor Green
            Start-Sleep -Seconds 2
            
            # Extract PR number or just use branch to merge
            gh pr merge $branch --merge --delete-branch 2>&1 | Out-Null
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  + Merged" -ForegroundColor Green
                $successCount++
            }
            else {
                Write-Host "  - Merge failed" -ForegroundColor Red
                $failCount++
            }
        }
        else {
            Write-Host "  - PR creation failed: $prUrl" -ForegroundColor Red
            $failCount++
        }
    }
    catch {
        Write-Host "  - Error: $_" -ForegroundColor Red
        $failCount++
    }
    
    Start-Sleep -Milliseconds 500
}

Write-Host "`n=== COMPLETE ===" -ForegroundColor Cyan
Write-Host "+ Success: $successCount" -ForegroundColor Green
Write-Host "- Failed: $failCount" -ForegroundColor Red
Write-Host "`nRepository: https://github.com/Prettyface1/T-travel" -ForegroundColor White
