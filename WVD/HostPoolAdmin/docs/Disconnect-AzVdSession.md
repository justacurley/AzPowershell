---
external help file: HostPoolAdmin-help.xml
Module Name: HostPoolAdmin
online version:
schema: 2.0.0
---

# Disconnect-AzVdSession

## SYNOPSIS
A wrapper for Disconnect-AzWvdUserSession

## SYNTAX

```powershell
Disconnect-AzVdSession [-Id] <String> [<CommonParameters>]
```

## DESCRIPTION
Supports pipeline input from Get-AzVdSession

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName vdname001.fqdn.local | Get-AzVdSession | Disconnect-AzVdSession
```

Disconnects all sessions on a SessionHost

## PARAMETERS

### -Id
Resource Id of User Session

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

