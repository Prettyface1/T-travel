# Fix and Auto-Merge PRs
# Adds an empty commit to branches that fail PR creation to force GitHub to recognize changes

$ErrorActionPreference = "Continue"

Write-Host "=== T-travel PR Fixer ===" -ForegroundColor Cyan

# Get all branches except main
$branches = git branch | ForEach-Object { $_.Trim('*', ' ') } | Where-Object { $_ -ne 'main' }

Write-Host "Found $($branches.Count) pending branches`n" -ForegroundColor Green

$successCount = 0
$failCount = 0
$prCount = 0

foreach ($branch in $branches) {
    $prCount++
    Write-Host "[$prCount/$($branches.Count)] Processing $branch" -ForegroundColor Yellow
    
    $title = "[T-travel] $branch"
    $body = "## Overview`nImplements **$branch** features.`n`n## Changes`n- Core functionality implementation`n- Tests and documentation`n`n## Impact`nfeature addition."
    
    # Function to try create/merge
    function Try-Merge {
        $existingPr = gh pr list --head $branch --base main --json number --jq '.[0].number' 2>$null
        if ($existingPr) {
            Write-Host "  * Merging existing PR #$existingPr" -ForegroundColor Cyan
            gh pr merge $existingPr --merge --delete-branch 2>&1 | Out-Null
            return $LASTEXITCODE -eq 0
        }
        
        $prOut = gh pr create --base main --head $branch --title $title --body $body 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  + PR Created" -ForegroundColor Green
            Start-Sleep -Seconds 2
            gh pr merge $branch --merge --delete-branch 2>&1 | Out-Null
            return $LASTEXITCODE -eq 0
        }
        elseif ($prOut -match "No commits between") {
            Write-Host "  ! GitHub says no commits. Adding empty commit..." -ForegroundColor Magenta
            
            git checkout $branch 2>$null | Out-Null
            git pull origin $branch 2>$null | Out-Null
            git commit --allow-empty -m "chore: trigger pr sync" 2>$null | Out-Null
            git push origin $branch 2>$null | Out-Null
            
            # Retry
            Start-Sleep -Seconds 2
            $prOutRetry = gh pr create --base main --head $branch --title $title --body $body 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  + PR Created (Retry)" -ForegroundColor Green
                Start-Sleep -Seconds 2
                gh pr merge $branch --merge --delete-branch 2>&1 | Out-Null
                return $LASTEXITCODE -eq 0
            }
        }
        
        Write-Host "  - Failed: $prOut" -ForegroundColor Red
        return $false
    }
    
    if (Try-Merge) {
        Write-Host "  + Success" -ForegroundColor Green
        $successCount++
        # Delete local branch to clean up
        git checkout main 2>$null | Out-Null
        git branch -D $branch 2>$null | Out-Null
    }
    else {
        $failCount++
    }
    
    Start-Sleep -Milliseconds 500
}

Write-Host "`n=== COMPLETE ===" -ForegroundColor Cyan
Write-Host "+ Success: $successCount" -ForegroundColor Green
Write-Host "- Failed: $failCount" -ForegroundColor Red
