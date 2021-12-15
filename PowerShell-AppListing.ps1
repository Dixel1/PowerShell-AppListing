#PowerShell-AppListing v1.0
Get-WmiObject -Class Win32_Product | Select-Object -Property Name > AppList.csv