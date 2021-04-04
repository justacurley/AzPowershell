---
external help file: HostPoolAdmin-help.xml
Module Name: HostPoolAdmin
online version:
schema: 2.0.0
---

# Set-AzVdLogin

## SYNOPSIS
A wrapper for Update-AzWvdSessionHost -AllowNewSession

## SYNTAX

```
Set-AzVdLogin [[-Id] <String>] [-AllowNewSession] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Designed for pipeline input.
Does not include ResourceGroupName/HostPoolName.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName vdbasename001.fqdn.local | Set-AzVdLogin -AllowNewSession:$false | Select Name,AllowNewSession
```

Drain a specific WVD Session Host

```powershell
Name                                    AllowNewSession
----                                    ---------------
HostPoolName/VDBASENAME001.fqdn.local   False
```

### EXAMPLE 2
```powershell
Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName "*vdbasename00[1-3]*" | Set-AzVdLogin -AllowNewSession:$false | Select Name,AllowNewSession
```

Drain a list of WVD Session Hosts

```powershell
Name                                    AllowNewSession
----                                    ---------------
HostPoolName/VDBASENAME001.fqdn.local   False
HostPoolName/VDBASENAME002.fqdn.local   False
HostPoolName/VDBASENAME003.fqdn.local   False
```

## PARAMETERS

### -Id
Resource Id of Session Host

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AllowNewSession
Enable/Disable Drain Mode for Session Host

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


