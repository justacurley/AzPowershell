---
external help file: HostPoolAdmin-help.xml
Module Name: HostPoolAdmin
online version:
schema: 2.0.0
---

# Restart-AzVdHost

## SYNOPSIS
A wrapper for Restart-AzVM

## SYNTAX

```powershell
Restart-AzVdHost [[-ResourceId] <String>] [-NoWait] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Supports pipeline input from Get-AzVdHost

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName vdname001.fqdn.local | Restart-AzVdHost -Confirm:$false -Force
```

Restart a Session Host without confirmation

```powershell
OperationId : 973605fd-a8f0-4355-b4b9-92e5b215ee15
Status      : Succeeded
StartTime   : 4/4/2021 3:58:30 PM
EndTime     : 4/4/2021 3:59:53 PM
Error       :
```

### EXAMPLE 2
```powershell
Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName vdname001.fqdn.local | Restart-AzVdHost -Confirm:$false -Force -NoWait
```

Request a Session Host be restarted and return to console

```powershell
RequestId                            IsSuccessStatusCode StatusCode ReasonPhrase
---------                            ------------------- ---------- ------------
98dd96a5-3426-4bb6-87b3-653ee130b77b                True   Accepted Accepted
```

## PARAMETERS

### -ResourceId
Resource Id of Virtual Machine

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

### -NoWait
Fire and forget Restart-AzVM

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Skip confirmation

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```


### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

