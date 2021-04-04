---
external help file: HostPoolAdmin-help.xml
Module Name: HostPoolAdmin
online version:
schema: 2.0.0
---

# Get-AzVdHostPool

## SYNOPSIS
A wrapper for Get-AzWvdHostPool

## SYNTAX

```powershell
Get-AzVdHostPool [-HostPoolName] <String> [-ResourceGroupName] <String> [-AppGroup] [<CommonParameters>]
```

## DESCRIPTION
Includes tab completion for $HostPoolName and $ResourceGroupName

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName
```

Get a WVD HostPool

```powershell
Location Name           Type
-------- ----           ----
eastus2  HostPoolName   Microsoft.DesktopVirtualization/hostpools
```

### EXAMPLE 2
```powershell
Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -AppGroup
```

List Application Group ResourceId's assocaited with the WVD HostPool.
Use the -AppGroup switch when piping
this command to Get-AzVdApplicationGroup or Get-AzVdAssignments

```powershell
AppGroupID
----------
/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/ResourceGroupName/providers/Microsoft.DesktopVirtualization/applicationgroups/ApplicationGroupName
```

## PARAMETERS

### -HostPoolName
Name of the HostPool

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Name of the Resource Group containing the HostPool

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppGroup
Returns the Resource Ids of Application Groups associated with the HostPool

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

