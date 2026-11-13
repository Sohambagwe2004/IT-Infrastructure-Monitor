
# IT Infrastructure Monitoring & Troubleshooting Toolkit

## Project Overview
A beginner-level IT infrastructure monitoring toolkit
developed using Python and Windows PowerShell.

The project collects local system information, monitors
RAM and disk utilization, tests network connectivity,
performs DNS resolution checks, and generates system
health reports.

## Technologies Used
- Python 3.14
- Windows PowerShell 5.1
- Windows 11 Pro
- Windows Management Instrumentation (WMI/CIM)
- Networking utilities

## Project Features

1. System Information Monitoring
   - Computer name
   - Operating system
   - Processor information
   - CPU load

2. Memory and Disk Monitoring
   - Total and available RAM
   - Disk capacity and utilization
   - High disk utilization warning

3. Network Troubleshooting
   - IP configuration
   - Internet connectivity testing
   - DNS resolution
   - HTTPS connectivity testing

4. Automated Reporting
   - PowerShell system reports
   - Python-generated health reports

## Project Structure

IT-Infrastructure-Monitor/
├── scripts/
│   ├── system_monitor.ps1
│   └── network_check.ps1
├── python/
│   └── monitor.py
├── reports/
├── README.md

## How to Run

### PowerShell System Monitoring
powershell -ExecutionPolicy Bypass -File .\scripts\system_monitor.ps1

### Network Troubleshooting
powershell -ExecutionPolicy Bypass -File .\scripts\network_check.ps1

### Python Monitoring
python .\python\monitor.py

## Learning Outcomes

- Practiced Windows system administration fundamentals.
- Used PowerShell for system information collection.
- Used Python for IT monitoring and automation.
- Practiced DNS and network connectivity troubleshooting.
- Generated automated system health reports.

## Project Scope
This project monitors the local Windows computer.
It is a learning project and is not a production
server monitoring or remote infrastructure solution.
