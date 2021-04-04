---
external help file: HostPoolAdmin-help.xml
Module Name: HostPoolAdmin
online version:
schema: 2.0.0
---

# Get-AzVdSession

## SYNOPSIS
A wrapper for Get-AzWvdUserSession

## SYNTAX

### ID
```powershell
Get-AzVdSession -Id <String> [<CommonParameters>]
```

### HostPool
```powershell
Get-AzVdSession -HostPoolName <String> -ResourceGroupName <String> [<CommonParameters>]
```

## DESCRIPTION
Supports pipeline input from Get-AzVdHost and includes tab completion for $HostPoolName and $ResourceGroupName

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AzVdSession -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName
```

Lists WVD Sessions in a HostPool

```powershell
Name                                                      Type
----                                                      ----
HostPoolName/VDBASENAME001.fqdn.local/7   Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
HostPoolName/VDBASENAME001.fqdn.local/10  Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
HostPoolName/VDBASENAME002.fqdn.local/7   Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
HostPoolName/VDBASENAME003.fqdn.local/3   Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
HostPoolName/VDBASENAME003.fqdn.local/60  Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
```

### EXAMPLE 2
```powershell
Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName "*vdbasename001*" | Get-AzVdSession
```

Lists WVD Sessions in a SessionHost

```powershell
Name                                                      Type
----                                                      ----
HostPoolName/VDBASENAME001.fqdn.local/7   Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
HostPoolName/VDBASENAME001.fqdn.local/10  Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
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
Parameter Sets: HostPool
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Name of the Resource Group containing the HostPool

```yaml
Type: String
Parameter Sets: HostPool
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


