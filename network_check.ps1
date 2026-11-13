Write-Host "===================================="
Write-Host " NETWORK TROUBLESHOOTING"
Write-Host "===================================="

Write-Host "`n1. IP CONFIGURATION"

Get-NetIPConfiguration |
    Select-Object InterfaceAlias,
                  @{Name="IPv4";Expression={$_.IPv4Address.IPAddress}},
                  @{Name="Gateway";Expression={$_.IPv4DefaultGateway.NextHop}} |
    Format-Table -AutoSize

Write-Host "`n2. INTERNET CONNECTIVITY TEST"

if (Test-Connection -ComputerName "8.8.8.8" -Count 2 -Quiet) {
    Write-Host "Internet IP connectivity: SUCCESS" -ForegroundColor Green
}
else {
    Write-Host "Internet IP connectivity: FAILED" -ForegroundColor Red
}

Write-Host "`n3. DNS RESOLUTION TEST"

try {
    $DNS = Resolve-DnsName -Name "google.com" -Type A -ErrorAction Stop

    Write-Host "DNS Resolution: SUCCESS" -ForegroundColor Green

    $DNS | Select-Object -First 2 Name, IPAddress |
        Format-Table -AutoSize
}
catch {
    Write-Host "DNS Resolution: FAILED" -ForegroundColor Red
}

Write-Host "`n4. HTTPS CONNECTIVITY TEST"

$Connection = Test-NetConnection google.com -Port 443 -WarningAction SilentlyContinue

if ($Connection.TcpTestSucceeded) {
    Write-Host "HTTPS connectivity: SUCCESS" -ForegroundColor Green
}
else {
    Write-Host "HTTPS connectivity: FAILED" -ForegroundColor Red
}

Write-Host "`nNetwork troubleshooting completed!" -ForegroundColor Cyan
