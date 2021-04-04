---
external help file: HostPoolAdmin-help.xml
Module Name: HostPoolAdmin
online version:
schema: 2.0.0
---

# Get-AzVdApplicationGroup

## SYNOPSIS
A wrapper for Get-AzWvdApplicationGroup

## SYNTAX

### Name (Default)
```powershell
Get-AzVdApplicationGroup -Name <String> [-ResourceGroupName <String>] [<CommonParameters>]
```

### ID
```powershell
Get-AzVdApplicationGroup -AppGroupID <String> [<CommonParameters>]
```

### HostPool
```powershell
Get-AzVdApplicationGroup -ResourceGroupName <String> -HostPoolName <String> [<CommonParameters>]
```

## DESCRIPTION
Supports pipeline input and includes tab completion for $HostPoolName and $ResourceGroupName

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AzVdApplicationGroup -Name ApplicationGroupName -ResourceGroupName ResourceGroupName
```

Get an Application Group

```powershell
Location Name                   Type
-------- ----                   ----
eastus2  ApplicationGroupName   Microsoft.DesktopVirtualization/applicationgroups
```

### EXAMPLE 2
```powershell
Get-AzVdApplicationGroup -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName
```

Get all Application Groups referenced by a HostPool

```powershell
Location Name                Type
-------- ----                ----
eastus2  Remote Applications Microsoft.DesktopVirtualization/applicationgroups
eastus2  Remote Chrome       Microsoft.DesktopVirtualization/applicationgroups
eastus2  ApplicationGroup... Microsoft.DesktopVirtualization/applicationgroups
```

### EXAMPLE 3
```powershell
Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -AppGroup | Get-AzVdApplicationGroup
```

Get all Application Groups referenced by a HostPool
```powershell
Location Name                   Type
-------- ----                   ----
eastus2  ApplicationGroupName   Microsoft.DesktopVirtualization/applicationgroups
```

## PARAMETERS

### -AppGroupID
Resource Id of Application Group

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

### -Name
Name of Application Group

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Name of Resource Group

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```


### -HostPoolName
Name of HostPool

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

