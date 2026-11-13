
import json
import socket
import shutil
import subprocess
from pathlib import Path
from datetime import datetime

# Project directories
BASE_DIR = Path(__file__).resolve().parent.parent
REPORT_DIR = BASE_DIR / "reports"
REPORT_DIR.mkdir(exist_ok=True)


def get_system_information():
    """Collect Windows system information using PowerShell."""

    ps_script = r"""
    $computer = Get-CimInstance Win32_ComputerSystem
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1

    $total = [math]::Round($computer.TotalPhysicalMemory / 1GB, 2)
    $free = [math]::Round($os.FreePhysicalMemory / 1MB, 2)

    [PSCustomObject]@{
        Computer = $computer.Name
        OS = $os.Caption
        Processor = $cpu.Name
        CPU_Load = $cpu.LoadPercentage
        Total_RAM_GB = $total
        Used_RAM_GB = [math]::Round($total - $free, 2)
        Free_RAM_GB = $free
    } | ConvertTo-Json -Compress
    """

    result = subprocess.run(
        ["powershell", "-NoProfile", "-Command", ps_script],
        capture_output=True,
        text=True,
        timeout=20,
        check=True
    )

    return json.loads(result.stdout.strip())


def check_dns():
    """Check DNS resolution."""

    try:
        ip = socket.gethostbyname("google.com")
        return f"SUCCESS - Resolved IP: {ip}"
    except socket.gaierror:
        return "FAILED - DNS resolution unsuccessful"


def check_https():
    """Check TCP connectivity to HTTPS port 443."""

    try:
        with socket.create_connection(
            ("google.com", 443), timeout=5
        ):
            return "SUCCESS - HTTPS port 443 reachable"
    except OSError:
        return "FAILED - HTTPS connection unsuccessful"


def generate_report():

    report = []

    report.append("IT INFRASTRUCTURE HEALTH REPORT")
    report.append("=" * 45)
    report.append(f"Generated: {datetime.now()}")

    # System information
    report.append("\nSYSTEM INFORMATION")

    try:
        system = get_system_information()

        for key, value in system.items():
            report.append(f"{key}: {value}")

    except (OSError, subprocess.SubprocessError, json.JSONDecodeError) as error:
        report.append(f"System information error: {error}")

    # Disk monitoring
    report.append("\nDISK INFORMATION")

    disk = shutil.disk_usage("C:/")

    total = round(disk.total / (1024 ** 3), 2)
    used = round(disk.used / (1024 ** 3), 2)
    free = round(disk.free / (1024 ** 3), 2)
    percentage = round((disk.used / disk.total) * 100, 2)

    report.append(f"Total Disk: {total} GB")
    report.append(f"Used Disk: {used} GB")
    report.append(f"Free Disk: {free} GB")
    report.append(f"Disk Utilization: {percentage}%")

    if percentage >= 85:
        report.append("Disk Status: HIGH UTILIZATION")
    else:
        report.append("Disk Status: NORMAL")

    # Network monitoring
    report.append("\nNETWORK INFORMATION")

    report.append(f"DNS Status: {check_dns()}")
    report.append(f"HTTPS Status: {check_https()}")

    # Generate text report
    report_file = REPORT_DIR / "python_health_report.txt"

    report_file.write_text(
        "\n".join(report),
        encoding="utf-8"
    )

    print("\n".join(report))
    print("\nReport generated successfully!")
    print(f"Saved at: {report_file}")


if __name__ == "__main__":
    generate_report()
