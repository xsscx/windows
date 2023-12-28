# Define the output directory and file
$OutputDirectory = ".\Log_Directory"
$OutputFile = "Amount_Of_Audit_Logs-12-27-2023-365-days-test-002.csv"
$FullOutputPath = Join-Path -Path $OutputDirectory -ChildPath $OutputFile

# Start time of the script
$ScriptStartTime = Get-Date
Write-Host "Script started at: $ScriptStartTime"

# Check if output directory exists, if not, create it
if (-not (Test-Path -Path $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory
    Write-Host "Created directory: $OutputDirectory"
}

# Define the record types to be audited
# Define the record types to be audited
$RecordTypes = @("ExchangeAdmin", "ExchangeItem", "ExchangeItemGroup", "SharePoint", "SyntheticProbe", "SharePointFileOperation", "OneDrive", "AzureActiveDirectory", "AzureActiveDirectoryAccountLogon", "DataCenterSecurityCmdlet", "ComplianceDLPSharePoint", "Sway", "ComplianceDLPExchange", "SharePointSharingOperation", "AzureActiveDirectoryStsLogon", "SkypeForBusinessPSTNUsage", "SkypeForBusinessUsersBlocked", "SecurityComplianceCenterEOPCmdlet", "ExchangeAggregatedOperation", "PowerBIAudit", "CRM", "Yammer", "SkypeForBusinessCmdlets", "Discovery", "MicrosoftTeams", "ThreatIntelligence", "MailSubmission", "MicrosoftFlow", "AeD", "MicrosoftStream", "ComplianceDLPSharePointClassification", "ThreatFinder", "Project", "SharePointListOperation", "SharePointCommentOperation", "DataGovernance", "Kaizala", "SecurityComplianceAlerts", "ThreatIntelligenceUrl", "SecurityComplianceInsights", "MIPLabel", "WorkplaceAnalytics", "PowerAppsApp", "PowerAppsPlan", "ThreatIntelligenceAtpContent", "LabelContentExplorer", "TeamsHealthcare", "ExchangeItemAggregated", "HygieneEvent", "DataInsightsRestApiAudit", "InformationBarrierPolicyApplication", "SharePointListItemOperation", "SharePointContentTypeOperation", "SharePointFieldOperation", "MicrosoftTeamsAdmin", "HRSignal", "MicrosoftTeamsDevice", "MicrosoftTeamsAnalytics", "InformationWorkerProtection", "Campaign", "DLPEndpoint", "AirInvestigation", "Quarantine", "MicrosoftForms", "ApplicationAudit", "ComplianceSupervisionExchange", "CustomerKeyServiceEncryption", "OfficeNative", "MipAutoLabelSharePointItem", "MipAutoLabelSharePointPolicyLocation", "MicrosoftTeamsShifts", "MipAutoLabelExchangeItem", "CortanaBriefing", "Search", "WDATPAlerts", "MDATPAudit")

# Define start and end dates for the audit log search
$StartDate = [datetime]::Now.AddDays(-365)  # Starting from 365 days ago
$EndDate = [datetime]::Now  # Ending today
Write-Host "Audit log search period: $StartDate to $EndDate"

# Initialize the total count variable
$TotalCount = 0

# Process each record type and write to the output file
foreach ($record in $RecordTypes) {
    Write-Host "Processing RecordType: $record"
    $OperationStartTime = Get-Date

    $SpecificResult = Search-UnifiedAuditLog -StartDate $StartDate -EndDate $EndDate -RecordType $record -ResultSize 1 | Out-String -Stream | Select-String "ResultCount"

    if ($SpecificResult -and $SpecificResult.ToString().Split(":").Count -gt 1) {
        $number = $SpecificResult.ToString().Split(":")[1].Trim()
        $TotalCount += [int]$number
        $recordData = "$record,$number"
        Write-Output $recordData | Out-File -FilePath $FullOutputPath -Append
    } else {
        Write-Output "$record,0" | Out-File -FilePath $FullOutputPath -Append
    }

    $OperationEndTime = Get-Date
    $OperationDuration = $OperationEndTime - $OperationStartTime
    Write-Host "Completed $record - Duration: $($OperationDuration.TotalSeconds) seconds"
}

# Output the total count to the console and file
$ScriptEndTime = Get-Date
$TotalScriptDuration = $ScriptEndTime - $ScriptStartTime
Write-Host "--------------------------------------"
Write-Host "Total count: $TotalCount"
Write-Host "Script completed at: $ScriptEndTime"
Write-Host "Total script duration: $($TotalScriptDuration.TotalMinutes) minutes"
Write-Host "Count complete. File is written to $FullOutputPath"
Write-Output "Total Count,$TotalCount" | Out-File -FilePath $FullOutputPath -Append
