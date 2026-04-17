$TargetIPs = @(
    "192.168.10.88",
    "192.168.10.198",
    "192.168.10.133",
    "192.168.10.155"
)

$CheckInterval = 30   # seconds
$FailThreshold = 2

$EmailFrom = "example@email.com"
$EmailTo = @(
    "example@email.com",
    "example@email.com",
    "example@email.com",
    "example@email.com"
    
)

$SMTPServer = "smtp.office365.com"
$SMTPPort = 587

$Username = "example@email.com"
$Password = "Password"

$logFile = "C:\Scripts\monitor.log"




function Log($msg) {
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$time - $msg"
}



$failCount = 0
$alertSent = $false


function Test-Ping($ip) {
    try {
        $result = Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue
        return $result
    } catch {
        return $false
    }
}


function Send-AlertEmail {
    try {
        $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($Username, $securePassword)

        Send-MailMessage `
            -From $EmailFrom `
            -To $EmailTo `
            -Subject "Power Failure Alert (Testing)" `
            -Body "(Testing) ALERT: Power failure detected. Please inform system admin immediately." `
            -SmtpServer $SMTPServer `
            -Port $SMTPPort `
            -UseSsl `
            -Credential $cred

        Write-Host "Alert email sent"
        Log "ALERT EMAIL SENT"

    } catch {
        Write-Host " Email error: $_"
        Log "EMAIL ERROR: $_"
    }
}


Write-Host " Monitoring started..."
Log "===== Monitoring Started ====="


while ($true) {

    $downCount = 0

    foreach ($ip in $TargetIPs) {
        if (Test-Ping $ip) {
            Write-Host " $ip UP"
            Log "$ip UP"
        } else {
            Write-Host " $ip DOWN"
            Log "$ip DOWN"
            $downCount++
        }
    }

    $total = $TargetIPs.Count
    Write-Host "Down systems: $downCount / $total"
    Log "Down systems: $downCount / $total"

    if ($downCount -eq $total) {
        $failCount++
        Write-Host "Failure count: $failCount / $FailThreshold"
        Log "Failure count: $failCount / $FailThreshold"

        if ($failCount -ge $FailThreshold -and -not $alertSent) {
            Send-AlertEmail
            $alertSent = $true
        }
    } else {
        Write-Host " Not a power failure"
        Log "System normal (not power failure)"

        $failCount = 0
        $alertSent = $false
    }

    Start-Sleep -Seconds $CheckInterval
}