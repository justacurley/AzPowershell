---
Module Name: HostPoolAdmin
Module Guid: 00000000-0000-0000-0000-000000000000
Download Help Link:
Help Version: 0.0.0.1
Locale: en-US
---

# HostPoolAdmin Module
## Description
Az.DesktopVirtualization does not currently support pipeline processing or tab completion in many of its functions. This module wraps those commands most in need of pipeline support to ease the burden of managing WVD environments via powershell.

## HostPoolAdmin Cmdlets
### [Get-AzVdHostPool](docs/Get-AzVdHostPool.md)
A wrapper for Get-AzWvdHostPool. Includes tab completion for $HostPoolName and $ResourceGroupName.

### [Get-AzVdApplicationGroup](docs/Get-AzVdApplicationGroup.md)
A wrapper for Get-AzWvdApplicationGroup

### [Get-AzVdAssignment](docs/Get-AzVdAssignment.md)
Get 'Desktop Virtualization User' role assignments. Get role assignments for a given Application Group(s)

### [Get-AzVdHost](docs/Get-AzVdHost.md)
A wrapper for Get-AzWvdSessionHost. Supports pipeline input, wildcards for SessionHost names, and includes tab completion for $HostPoolName and $ResourceGroupName

### [Set-AzVdLogin](docs/Set-AzVdLogin.md)
A wrapper for Update-AzWvdSessionHost -AllowNewSession. Designed for pipeline input. Does not include ResourceGroupName/HostPoolName.

### [Get-AzVdSession](docs/Get-AzVdSession.md)
A wrapper for Get-AzWvdUserSession. Supports pipeline input from Get-AzVdHost and includes tab completion for $HostPoolName and $ResourceGroupName

### [Disconnect-AzVdSession](docs/Disconnect-AzVdSession.md)
A wrapper for Disconnect-AzWvdUserSession. Supports pipeline input from Get-AzVdSession

### [Remove-AzVdSession](docs/Remove-AzVdSession.md)
A wrapper for Remove-AzWvdUserSession. Supports pipeline input from Get-AzVdSession.

### [Restart-AzVdHost](docs/Restart-AzVdHost.md)
A wrapper for Restart-AzVM. Supports pipeline input from Get-AzVdHost.

### [Stop-AzVdHost](docs/Stop-AzVdHost.md)
A wrapper for Stop-AzVM. Supports pipeline input from Get-AzVdHost.





