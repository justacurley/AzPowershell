---
external help file: HostPoolAdmin-help.xml
Module Name: HostPoolAdmin
online version:
schema: 2.0.0
---

# Get-AzVdHost

## SYNOPSIS
A wrapper for Get-AzWvdSessionHost

## SYNTAX

### ID
```powershell
Get-AzVdHost -Id <String> [-VDName <String>] [<CommonParameters>]
```

### Name
```powershell
Get-AzVdHost -HostPoolName <String> -ResourceGroupName <String> [-VDName <String>] [<CommonParameters>]
```

## DESCRIPTION
Supports pipeline input, wildcards for SessionHost names, and includes tab completion for $HostPoolName and $ResourceGroupName

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName
```

Get all WVD SessionHosts in a HostPool

```powershell
Name                                                  Type
----                                                  ----
HostPoolName/VDBASENAME001.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
HostPoolName/VDBASENAME002.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
HostPoolName/VDBASENAME003.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
HostPoolName/VDBASENAME004.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
```

### EXAMPLE 2
```powershell
Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName | Get-AzVdHost
```

Get a all WVD SessionHosts in a HostPool by piping Get-AzVdHostPool

```powershell
Name                                                  Type
----                                                  ----
HostPoolName/VDBASENAME001.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
HostPoolName/VDBASENAME002.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
HostPoolName/VDBASENAME003.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
HostPoolName/VDBASENAME004.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
```

### EXAMPLE 3
```powershell
Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName | Get-AzVdHost -VDName vdbasename001.fqdn.local
```

Get a specific WVD SessionHost

```powershell
Name                                                  Type
----                                                  ----
HostPoolName/VDBASENAME001.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
```

### EXAMPLE 4
```powershell
Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName | Get-AzVdHost -VDName "*vdbasename[1-2]*"
```

Get a list of WVD SessionHosts using wildcards

```powershell
Name                                                  Type
----                                                  ----
HostPoolName/VDBASENAME001.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
HostPoolName/VDBASENAME002.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
```

## PARAMETERS

### -Id
Resource Id of Session Host

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -HostPoolName
Name of the HostPool containing the Session Host

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ResourceGroupName
Name of the Resource Group containing the HostPool

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VDName
Name of the Session Host.
If not provided, all Session Hosts in the HostPool will be returned

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

