# Define the current year
$CurrentYear = (Get-Date).Year

# Define the output directory and file
$OutputDirectory = ".\EmailAccountReports"
$OutputFile = "EmailAccountsReport_${CurrentYear}.csv"
$FullOutputPath = Join-Path -Path $OutputDirectory -ChildPath $OutputFile

# Create output directory if it doesn't exist
if (-not (Test-Path -Path $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory
    Write-Host "Created directory: $OutputDirectory"
}

# Connect to Exchange Online
Connect-ExchangeOnline

# Get mailbox details
$Mailboxes = Get-EXOMailbox -ResultSize Unlimited | Select-Object DisplayName, UserPrincipalName, PrimarySmtpAddress, WhenCreated

# Filter mailboxes created in the current year
$MailboxesCurrentYear = $Mailboxes | Where-Object { $_.WhenCreated.Year -eq $CurrentYear }

# Export mailbox details to CSV
$MailboxesCurrentYear | Export-Csv -Path $FullOutputPath -NoTypeInformation

Write-Host "Email accounts report for the year $CurrentYear exported to: $FullOutputPath"

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
