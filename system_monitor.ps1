Write-Host "===================================="
Write-Host " SYSTEM HEALTH MONITORING"
Write-Host "===================================="

$Computer = Get-CimInstance Win32_ComputerSystem
$OS = Get-CimInstance Win32_OperatingSystem
$CPU = Get-CimInstance Win32_Processor

$TotalRAM = [math]::Round($Computer.TotalPhysicalMemory / 1GB, 2)
$FreeRAM = [math]::Round($OS.FreePhysicalMemory / 1MB, 2)
$UsedRAM = [math]::Round($TotalRAM - $FreeRAM, 2)


$Disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

Write-Host "`nCOMPUTER INFORMATION"
Write-Host "Computer Name: $($Computer.Name)"
Write-Host "Operating System: $($OS.Caption)"
Write-Host "Processor: $($CPU.Name)"
Write-Host "CPU Load: $($CPU.LoadPercentage)%"

Write-Host "`nMEMORY INFORMATION"
Write-Host "Total RAM: $TotalRAM GB"
Write-Host "Used RAM: $UsedRAM GB"
Write-Host "Free RAM: $FreeRAM GB"

Write-Host "`nDISK INFORMATION"

foreach ($Disk in $Disks) {

    $Total = [math]::Round($Disk.Size / 1GB, 2)
    $Free = [math]::Round($Disk.FreeSpace / 1GB, 2)
    $Used = [math]::Round(
        (($Disk.Size - $Disk.FreeSpace) / $Disk.Size) * 100, 2
    )

    Write-Host "Drive: $($Disk.DeviceID)"
    Write-Host "Total: $Total GB"
    Write-Host "Free: $Free GB"
    Write-Host "Used: $Used %"
    Write-Host "-------------------------"
}

Write-Host "`nSystem monitoring completed!" -ForegroundColor Green
