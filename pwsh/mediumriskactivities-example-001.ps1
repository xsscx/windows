# Define the number of days to look back for high-risk activities
$NumberOfDaysToAudit = 30

# Define output directory and file with date and time stamp
$OutputDirectory = ".\HighRiskOperations"
$OutputFile = "HighRiskMailActivities_$(Get-Date -Format 'MM-dd-yyyy_HH-mm-ss').csv"
$FullOutputPath = Join-Path -Path $OutputDirectory -ChildPath $OutputFile

# Create output directory if it doesn't exist
if (-not (Test-Path -Path $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory
    Write-Host "Created directory: $OutputDirectory"
}

# Connect to Exchange Online
Connect-ExchangeOnline 

# Define the operations to search for
$HighRiskOperations = @(
    "HardDelete", 
    "SoftDelete", 
    "MoveToDeletedItems", 
    "UpdateInboxRules"
    # Add other relevant operations from the provided list
)

# Search the mailbox audit log for high-risk activities
$StartDate = (Get-Date).AddDays(-$NumberOfDaysToAudit)
$EndDate = Get-Date

$HighRiskActivities = Search-MailboxAuditLog -StartDate $StartDate -EndDate $EndDate -Operations $HighRiskOperations -ShowDetails | Select-Object MailboxOwnerUPN, Operation, LogonType, LastAccessed, ExternalAccess, ClientInfoString, ClientIPAddress, ClientMachineName, OperationResult, OperationResultReason, Parameters, LogItems

# Export the results to a CSV file
$HighRiskActivities | Export-Csv -Path $FullOutputPath -NoTypeInformation

Write-Host "High-risk mail activities export complete. File located at: $FullOutputPath"

# Disconnect from Exchange Online
