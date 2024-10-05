# Define the output file name and path
$OutputFile = ".\UnifiedAuditLog_YTD-$(Get-Date -Format 'yyyyMMdd').csv"

# Get the first day of the current year
$StartOfYear = (Get-Date -Year (Get-Date).Year -Month 1 -Day 1)

# Get today's date
$Today = Get-Date

# Iterate from the start of the year to today
$Date = $StartOfYear
while ($Date -le $Today) {
    # Iterate over each hour of the day
    for ($HourIndex = 0; $HourIndex -lt 24; $HourIndex++) {
        # Calculate start and end times for the audit log search
        $StartDate = $Date.AddHours($HourIndex)
        $EndDate = $StartDate.AddHours(1)

        # Search the Unified Audit Log within the specified time window
        $AuditLogs = Search-UnifiedAuditLog -StartDate $StartDate -EndDate $EndDate -ResultSize 5000

        # Convert and select relevant audit data
        $ProcessedLogs = $AuditLogs | ForEach-Object {
            $AuditData = $_.AuditData | ConvertFrom-Json
            $AuditData | Select-Object CreationTime, UserId, Operation, Workload, ObjectID, SiteUrl, SourceFileName, ClientIP, UserAgent
        }

        # Export the processed data to a CSV file
        $ProcessedLogs | Export-Csv -Path $OutputFile -NoTypeInformation -Append

        # Write a log entry for the current operation
        Write-Host "Processed logs for $StartDate - Count: $($AuditLogs.Count)"
    }

    # Move to the next day
    $Date = $Date.AddDays(1)
}
