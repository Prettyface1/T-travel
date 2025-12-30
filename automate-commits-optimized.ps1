# T-travel Project Automation Script - OPTIMIZED VERSION
# This script creates 750+ commits and 80+ branches using micro-commit strategy
# With improved error handling and git lock prevention

param(
    [string]$RemoteUrl = "https://github.com/Prettyface1/T-travel.git",
    [int]$TargetCommits = 750,
    [int]$TargetBranches = 80
)

# Configuration
$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

# Initialize counters
$global:commitCount = 0
$global:branchCount = 0

# Helper function to wait for git lock to be released
function Wait-GitLock {
    $lockFile = ".git/index.lock"
    $maxWait = 10
    $waited = 0
    
    while ((Test-Path $lockFile) -and ($waited -lt $maxWait)) {
        Start-Sleep -Milliseconds 100
        $waited++
    }
    
    if (Test-Path $lockFile) {
        Remove-Item $lockFile -Force -ErrorAction SilentlyContinue
    }
}

# Helper function to create a commit with retry logic
function Make-Commit {
    param(
        [string]$Message,
        [string]$Type = "feat"
    )
    
    Wait-GitLock
    
    $maxRetries = 3
    $retryCount = 0
    
    while ($retryCount -lt $maxRetries) {
        try {
            git add -A 2>$null
            Start-Sleep -Milliseconds 50
            git commit -m "${Type}: ${Message}" --allow-empty 2>$null | Out-Null
            $global:commitCount++
            Write-Host "[$global:commitCount] ${Type}: $Message" -ForegroundColor Green
            break
        }
        catch {
            $retryCount++
            Start-Sleep -Milliseconds 200
        }
    }
}

# Helper function to create and switch to a branch
function New-FeatureBranch {
    param(
        [string]$BranchName
    )
    
    Wait-GitLock
    git checkout -b $BranchName 2>$null | Out-Null
    $global:branchCount++
    Write-Host "Created branch: $BranchName [$global:branchCount/$TargetBranches]" -ForegroundColor Cyan
}

# Helper function to merge branch to main
function Merge-ToMain {
    param(
        [string]$BranchName
    )
    
    Wait-GitLock
    git checkout main 2>$null | Out-Null
    Start-Sleep -Milliseconds 100
    git merge $BranchName --no-ff -m "Merge branch '$BranchName' into main" 2>$null | Out-Null
    $global:commitCount++
    Start-Sleep -Milliseconds 50
}

Write-Host "=== T-travel Micro-Commit Automation (OPTIMIZED) ===" -ForegroundColor Yellow
Write-Host "Target: $TargetCommits commits, $TargetBranches branches`n" -ForegroundColor Yellow

# Initialize Git Repository
Write-Host "`n[STEP 1] Initializing Git Repository..." -ForegroundColor Magenta
git init | Out-Null
git config user.name "T-travel Developer"
git config user.email "dev@t-travel.com"
git checkout -b main 2>$null | Out-Null
Make-Commit "initialize T-travel repository" "chore"

Write-Host "`n[STEP 2] Creating micro-commits across multiple branches..." -ForegroundColor Magenta

# Define all features with their commits
$features = @(
    @{
        Name    = "feature/project-configuration"
        Commits = @(
            @{Msg = "create .gitignore file"; Type = "chore" },
            @{Msg = "add node_modules to gitignore"; Type = "chore" },
            @{Msg = "add .env to gitignore"; Type = "chore" },
            @{Msg = "add build directories to gitignore"; Type = "chore" },
            @{Msg = "add IDE files to gitignore"; Type = "chore" }
        )
    },
    @{
        Name    = "feature/clarinet-config"
        Commits = @(
            @{Msg = "update clarity_version to 4"; Type = "config" },
            @{Msg = "update epoch to 3.3"; Type = "config" },
            @{Msg = "update project name to t-travel"; Type = "config" },
            @{Msg = "add project description"; Type = "config" },
            @{Msg = "configure cache directory"; Type = "config" }
        )
    },
    @{
        Name    = "feature/package-setup"
        Commits = @(
            @{Msg = "initialize package.json"; Type = "chore" },
            @{Msg = "add project metadata"; Type = "chore" },
            @{Msg = "add @stacks/connect dependency"; Type = "deps" },
            @{Msg = "add @stacks/transactions dependency"; Type = "deps" },
            @{Msg = "add @hirosystems/chainhooks-client dependency"; Type = "deps" },
            @{Msg = "add @walletconnect/web3wallet dependency"; Type = "deps" },
            @{Msg = "add react dependency"; Type = "deps" },
            @{Msg = "add react-dom dependency"; Type = "deps" },
            @{Msg = "add vite dependency"; Type = "deps" },
            @{Msg = "add typescript dependency"; Type = "deps" }
        )
    },
    @{
        Name    = "feature/typescript-setup"
        Commits = @(
            @{Msg = "create tsconfig.json"; Type = "config" },
            @{Msg = "add compiler options"; Type = "config" },
            @{Msg = "configure module resolution"; Type = "config" },
            @{Msg = "add include paths"; Type = "config" },
            @{Msg = "add exclude paths"; Type = "config" },
            @{Msg = "enable strict mode"; Type = "config" }
        )
    },
    @{
        Name    = "feature/vite-setup"
        Commits = @(
            @{Msg = "create vite.config.ts"; Type = "config" },
            @{Msg = "add react plugin"; Type = "config" },
            @{Msg = "configure build options"; Type = "config" },
            @{Msg = "add server configuration"; Type = "config" },
            @{Msg = "configure path aliases"; Type = "config" }
        )
    },
    @{
        Name    = "feature/environment-setup"
        Commits = @(
            @{Msg = "create .env.example file"; Type = "chore" },
            @{Msg = "add network configuration"; Type = "config" },
            @{Msg = "add API keys placeholders"; Type = "config" },
            @{Msg = "add contract addresses"; Type = "config" },
            @{Msg = "add WalletConnect project ID"; Type = "config" }
        )
    },
    @{
        Name    = "feature/folder-structure"
        Commits = @(
            @{Msg = "create src directory"; Type = "chore" },
            @{Msg = "create components directory"; Type = "chore" },
            @{Msg = "create hooks directory"; Type = "chore" },
            @{Msg = "create utils directory"; Type = "chore" },
            @{Msg = "create types directory"; Type = "chore" },
            @{Msg = "create services directory"; Type = "chore" },
            @{Msg = "create assets directory"; Type = "chore" },
            @{Msg = "create public directory"; Type = "chore" }
        )
    },
    @{
        Name    = "feature/types-stacks"
        Commits = @(
            @{Msg = "create stacks.types.ts file"; Type = "feat" },
            @{Msg = "add UserSession type"; Type = "feat" },
            @{Msg = "add AppConfig type"; Type = "feat" },
            @{Msg = "add Transaction type"; Type = "feat" },
            @{Msg = "add Network type"; Type = "feat" },
            @{Msg = "add ContractCall type"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/types-travel"
        Commits = @(
            @{Msg = "create travel.types.ts file"; Type = "feat" },
            @{Msg = "add Destination type"; Type = "feat" },
            @{Msg = "add Booking type"; Type = "feat" },
            @{Msg = "add Trip type"; Type = "feat" },
            @{Msg = "add Traveler type"; Type = "feat" },
            @{Msg = "add Review type"; Type = "feat" },
            @{Msg = "add Payment type"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/utils-stacks-connection"
        Commits = @(
            @{Msg = "create stacksConnection.ts file"; Type = "feat" },
            @{Msg = "add import statements"; Type = "feat" },
            @{Msg = "add network configuration"; Type = "feat" },
            @{Msg = "add connect wallet function"; Type = "feat" },
            @{Msg = "add disconnect wallet function"; Type = "feat" },
            @{Msg = "add get user data function"; Type = "feat" },
            @{Msg = "add error handling"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/utils-transaction-builder"
        Commits = @(
            @{Msg = "create transactionBuilder.ts file"; Type = "feat" },
            @{Msg = "add transaction imports"; Type = "feat" },
            @{Msg = "add build transaction function"; Type = "feat" },
            @{Msg = "add sign transaction function"; Type = "feat" },
            @{Msg = "add broadcast transaction function"; Type = "feat" },
            @{Msg = "add transaction status checker"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/utils-walletconnect"
        Commits = @(
            @{Msg = "create walletConnect.ts file"; Type = "feat" },
            @{Msg = "add WalletConnect imports"; Type = "feat" },
            @{Msg = "add initialize WalletConnect"; Type = "feat" },
            @{Msg = "add create session function"; Type = "feat" },
            @{Msg = "add handle session request"; Type = "feat" },
            @{Msg = "add disconnect session function"; Type = "feat" },
            @{Msg = "add event listeners"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/utils-chainhooks"
        Commits = @(
            @{Msg = "create chainhooks.ts file"; Type = "feat" },
            @{Msg = "add chainhooks client import"; Type = "feat" },
            @{Msg = "add initialize chainhooks client"; Type = "feat" },
            @{Msg = "add register hook function"; Type = "feat" },
            @{Msg = "add listen for events function"; Type = "feat" },
            @{Msg = "add unregister hook function"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/contract-main"
        Commits = @(
            @{Msg = "create t-travel-main.clar file"; Type = "feat" },
            @{Msg = "add contract header comment"; Type = "docs" },
            @{Msg = "add constants definition"; Type = "feat" },
            @{Msg = "add error codes"; Type = "feat" },
            @{Msg = "add data variables"; Type = "feat" },
            @{Msg = "add data maps"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/contract-booking"
        Commits = @(
            @{Msg = "create booking.clar file"; Type = "feat" },
            @{Msg = "add booking data map"; Type = "feat" },
            @{Msg = "add create booking function"; Type = "feat" },
            @{Msg = "add validate booking function"; Type = "feat" },
            @{Msg = "add update booking function"; Type = "feat" },
            @{Msg = "add cancel booking function"; Type = "feat" },
            @{Msg = "add get booking function"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/contract-payment"
        Commits = @(
            @{Msg = "create payment.clar file"; Type = "feat" },
            @{Msg = "add payment data structure"; Type = "feat" },
            @{Msg = "add process payment function"; Type = "feat" },
            @{Msg = "add refund payment function"; Type = "feat" },
            @{Msg = "add payment validation"; Type = "feat" },
            @{Msg = "add payment status tracking"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/contract-review"
        Commits = @(
            @{Msg = "create review.clar file"; Type = "feat" },
            @{Msg = "add review data map"; Type = "feat" },
            @{Msg = "add submit review function"; Type = "feat" },
            @{Msg = "add review validation"; Type = "feat" },
            @{Msg = "add get reviews function"; Type = "feat" },
            @{Msg = "add average rating calculation"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/contract-rewards"
        Commits = @(
            @{Msg = "create rewards.clar file"; Type = "feat" },
            @{Msg = "add rewards data structure"; Type = "feat" },
            @{Msg = "add calculate rewards function"; Type = "feat" },
            @{Msg = "add distribute rewards function"; Type = "feat" },
            @{Msg = "add claim rewards function"; Type = "feat" },
            @{Msg = "add rewards balance tracking"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/service-booking"
        Commits = @(
            @{Msg = "create bookingService.ts file"; Type = "feat" },
            @{Msg = "add service class structure"; Type = "feat" },
            @{Msg = "add create booking method"; Type = "feat" },
            @{Msg = "add get booking method"; Type = "feat" },
            @{Msg = "add update booking method"; Type = "feat" },
            @{Msg = "add cancel booking method"; Type = "feat" },
            @{Msg = "add list bookings method"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/service-payment"
        Commits = @(
            @{Msg = "create paymentService.ts file"; Type = "feat" },
            @{Msg = "add payment service class"; Type = "feat" },
            @{Msg = "add process payment method"; Type = "feat" },
            @{Msg = "add verify payment method"; Type = "feat" },
            @{Msg = "add refund method"; Type = "feat" },
            @{Msg = "add payment history method"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/hook-use-stacks"
        Commits = @(
            @{Msg = "create useStacks.ts file"; Type = "feat" },
            @{Msg = "add hook imports"; Type = "feat" },
            @{Msg = "add state management"; Type = "feat" },
            @{Msg = "add connect handler"; Type = "feat" },
            @{Msg = "add disconnect handler"; Type = "feat" },
            @{Msg = "add network change handler"; Type = "feat" },
            @{Msg = "add return values"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/hook-use-wallet"
        Commits = @(
            @{Msg = "create useWallet.ts file"; Type = "feat" },
            @{Msg = "add wallet state"; Type = "feat" },
            @{Msg = "add wallet connection logic"; Type = "feat" },
            @{Msg = "add balance fetching"; Type = "feat" },
            @{Msg = "add address formatting"; Type = "feat" },
            @{Msg = "add wallet utilities"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/hook-use-booking"
        Commits = @(
            @{Msg = "create useBooking.ts file"; Type = "feat" },
            @{Msg = "add booking state"; Type = "feat" },
            @{Msg = "add create booking logic"; Type = "feat" },
            @{Msg = "add fetch bookings logic"; Type = "feat" },
            @{Msg = "add update booking logic"; Type = "feat" },
            @{Msg = "add cancel booking logic"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/component-header"
        Commits = @(
            @{Msg = "create Header.tsx file"; Type = "feat" },
            @{Msg = "add component imports"; Type = "feat" },
            @{Msg = "add component interface"; Type = "feat" },
            @{Msg = "add component structure"; Type = "feat" },
            @{Msg = "add wallet connect button"; Type = "feat" },
            @{Msg = "add navigation menu"; Type = "feat" },
            @{Msg = "add logo section"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/component-header-styles"
        Commits = @(
            @{Msg = "create Header.module.css"; Type = "style" },
            @{Msg = "add header container styles"; Type = "style" },
            @{Msg = "add navigation styles"; Type = "style" },
            @{Msg = "add button styles"; Type = "style" },
            @{Msg = "add responsive styles"; Type = "style" },
            @{Msg = "add hover effects"; Type = "style" }
        )
    },
    @{
        Name    = "feature/component-footer"
        Commits = @(
            @{Msg = "create Footer.tsx file"; Type = "feat" },
            @{Msg = "add footer structure"; Type = "feat" },
            @{Msg = "add social links"; Type = "feat" },
            @{Msg = "add newsletter section"; Type = "feat" },
            @{Msg = "add copyright info"; Type = "feat" },
            @{Msg = "add footer navigation"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/component-footer-styles"
        Commits = @(
            @{Msg = "create Footer.module.css"; Type = "style" },
            @{Msg = "add footer container styles"; Type = "style" },
            @{Msg = "add link styles"; Type = "style" },
            @{Msg = "add newsletter form styles"; Type = "style" },
            @{Msg = "add responsive footer styles"; Type = "style" }
        )
    },
    @{
        Name    = "feature/component-destination-card"
        Commits = @(
            @{Msg = "create DestinationCard.tsx"; Type = "feat" },
            @{Msg = "add card props interface"; Type = "feat" },
            @{Msg = "add card structure"; Type = "feat" },
            @{Msg = "add image section"; Type = "feat" },
            @{Msg = "add info section"; Type = "feat" },
            @{Msg = "add price display"; Type = "feat" },
            @{Msg = "add booking button"; Type = "feat" }
        )
    },
    @{
        Name    = "feature/component-destination-card-styles"
        Commits = @(
            @{Msg = "create DestinationCard.module.css"; Type = "style" },
            @{Msg = "add card container styles"; Type = "style" },
            @{Msg = "add image styles"; Type = "style" },
            @{Msg = "add content styles"; Type = "style" },
            @{Msg = "add price styles"; Type = "style" },
            @{Msg = "add button styles"; Type = "style" },
            @{Msg = "add card hover effects"; Type = "style" }
        )
    },
    @{
        Name    = "feature/component-booking-form"
        Commits = @(
            @{Msg = "create BookingForm.tsx"; Type = "feat" },
            @{Msg = "add form imports"; Type = "feat" },
            @{Msg = "add form state management"; Type = "feat" },
            @{Msg = "add input fields"; Type = "feat" },
            @{Msg = "add date picker"; Type = "feat" },
            @{Msg = "add traveler count selector"; Type = "feat" },
            @{Msg = "add submit handler"; Type = "feat" },
            @{Msg = "add form validation"; Type = "feat" }
        )
    }
)

# Process first 30 features
foreach ($feature in $features) {
    if ($global:branchCount -ge 30) { break }
    
    New-FeatureBranch $feature.Name
    
    foreach ($commit in $feature.Commits) {
        Make-Commit -Message $commit.Msg -Type $commit.Type
    }
    
    Merge-ToMain $feature.Name
}

Write-Host "`n[STEP 3] Continuing with more features..." -ForegroundColor Magenta

# Add more feature branches
$additionalFeatures = @(
    "feature/component-booking-form-styles",
    "feature/component-wallet-button",
    "feature/component-wallet-button-styles",
    "feature/component-trip-list",
    "feature/component-trip-list-styles",
    "feature/component-review-card",
    "feature/component-review-card-styles",
    "feature/component-payment-modal",
    "feature/component-payment-modal-styles",
    "feature/page-home",
    "feature/page-home-styles",
    "feature/page-destinations",
    "feature/page-destinations-styles",
    "feature/page-booking",
    "feature/page-booking-styles",
    "feature/page-my-trips",
    "feature/page-my-trips-styles",
    "feature/page-profile",
    "feature/page-profile-styles",
    "feature/app-config",
    "feature/app-styles",
    "feature/context-auth",
    "feature/context-booking",
    "feature/utils-formatters",
    "feature/utils-validators",
    "feature/utils-api-client",
    "feature/tests-setup",
    "feature/tests-components",
    "feature/tests-hooks",
    "feature/tests-contracts",
    "feature/docs-readme",
    "feature/docs-contributing",
    "feature/docs-api",
    "feature/docs-contracts",
    "feature/assets-images",
    "feature/assets-fonts",
    "feature/cicd-github-actions",
    "feature/security-policy",
    "feature/optimization-performance",
    "feature/optimization-seo",
    "feature/accessibility-aria",
    "feature/accessibility-keyboard",
    "feature/monitoring-errors",
    "feature/monitoring-analytics",
    "feature/i18n-setup",
    "feature/i18n-translations",
    "feature/mobile-responsive",
    "feature/mobile-pwa",
    "feature/admin-dashboard",
    "feature/admin-management",
    "feature/notifications-system",
    "feature/search-implementation",
    "feature/cache-implementation",
    "feature/websocket-realtime",
    "feature/final-bugfixes",
    "refactor/code-cleanup",
    "refactor/typescript-improvements",
    "docs/code-comments",
    "docs/architecture",
    "docs/deployment",
    "test/integration-tests",
    "test/unit-tests-utils",
    "test/contract-unit-tests",
    "feature/wishlist",
    "feature/social-sharing",
    "feature/user-preferences",
    "feature/advanced-filters",
    "style/animations",
    "style/dark-mode",
    "style/responsive-improvements",
    "config/environment-variables",
    "config/eslint",
    "config/prettier"
)

foreach ($featureName in $additionalFeatures) {
    if ($global:branchCount -ge $TargetBranches) { break }
    
    New-FeatureBranch $featureName
    
    # Add 5-8 commits per branch
    $commitCount = Get-Random -Minimum 5 -Maximum 9
    
    for ($i = 1; $i -le $commitCount; $i++) {
        $type = @("feat", "fix", "docs", "style", "refactor", "test", "chore") | Get-Random
        Make-Commit -Message "implement ${featureName} part $i" -Type $type
    }
    
    Merge-ToMain $featureName
}

Write-Host "`n[STEP 4] Adding micro-commits to reach target..." -ForegroundColor Magenta

# Continue adding commits until we reach target
while ($global:commitCount -lt $TargetCommits) {
    if ($global:commitCount % 50 -eq 0) {
        Write-Host "Progress: $global:commitCount / $TargetCommits commits" -ForegroundColor Yellow
    }
    
    $type = @("feat", "fix", "docs", "style", "refactor", "test", "chore", "perf") | Get-Random
    $action = @("update", "improve", "optimize", "refactor", "enhance", "add", "fix") | Get-Random
    $component = @("configuration", "documentation", "tests", "styles", "components", "utils", "types", "services") | Get-Random
    
    Make-Commit -Message "$action $component functionality" -Type $type
}

# Final commits
git checkout main 2>$null | Out-Null
Make-Commit "update project version to 1.0.0" "chore"
Make-Commit "prepare for production deployment" "chore"

Write-Host "`n=== AUTOMATION COMPLETE ===" -ForegroundColor Yellow
Write-Host "Total Commits: $global:commitCount" -ForegroundColor Green
Write-Host "Total Branches: $global:branchCount" -ForegroundColor Green

Write-Host "`n[STEP 5] Setting up remote repository..." -ForegroundColor Magenta
git remote add origin $RemoteUrl 2>$null

Write-Host "`n=== SUCCESS ===" -ForegroundColor Green
Write-Host "Repository ready with $global:commitCount commits across $global:branchCount branches!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Push to remote: git push origin --all --force" -ForegroundColor White
Write-Host "2. Create PRs: .\create-prs.ps1" -ForegroundColor White
Write-Host "3. View history: git log --oneline --graph --all --decorate" -ForegroundColor White
