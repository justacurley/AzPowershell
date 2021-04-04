---
external help file: HostPoolAdmin-help.xml
Module Name: HostPoolAdmin
online version:
schema: 2.0.0
---

# Get-AzVdAssignment

## SYNOPSIS
Get 'Desktop Virtualization User' role assignments

## SYNTAX

### GetAzVdHostPool
```powershell
Get-AzVdAssignment -AppGroupID <String> [<CommonParameters>]
```

### GetAzVdApplicationGroup
```powershell
Get-AzVdAssignment -Id <String> [<CommonParameters>]
```

## DESCRIPTION
Get role assignments for a given Application Group(s)

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AzVdApplicationGroup -Name ApplicationGroupName -ResourceGroupName ResourceGroupName | Get-AzVdAssignment
```

Get role assignments for and Application Group

```powershell
RoleAssignmentId   : /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/ResourceGroupName/providers/Microsoft.DesktopVirtualization/applicationgroups/ApplicationGroupName/providers/Microsoft.Authorization/roleAssignments/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Scope              : /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/ResourceGroupName/providers/Microsoft.DesktopVirtualization/applicationgroups/ApplicationGroupName
DisplayName        : Group Display Name
SignInName         :
RoleDefinitionName : Desktop Virtualization User
...
```

### EXAMPLE 2
```powershell
Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -AppGroup | Get-AzVdAssignment
```

Get role assignments for all Application Groups referenced by HostPool

```powershell
RoleAssignmentId   : /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/ResourceGroupName/providers/Microsoft.DesktopVirtualization/applicationgroups/ApplicationGroupName1/providers/Microsoft.Authorization/roleAssignments/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Scope              : /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/ResourceGroupName/providers/Microsoft.DesktopVirtualization/applicationgroups/ApplicationGroupName1
DisplayName        : Group Display Name
SignInName         :
RoleDefinitionName : Desktop Virtualization User
...
RoleAssignmentId   : /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/ResourceGroupName/providers/Microsoft.DesktopVirtualization/applicationgroups/ApplicationGroupName2/providers/Microsoft.Authorization/roleAssignments/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Scope              : /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/ResourceGroupName/providers/Microsoft.DesktopVirtualization/applicationgroups/ApplicationGroupName2
DisplayName        : Group Display Name
SignInName         :
RoleDefinitionName : Desktop Virtualization User
...
```

## PARAMETERS

### -AppGroupID
Output of Get-AzVdHostPool

```yaml
Type: String
Parameter Sets: Get-AzVdHostPool
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Id
ResourceId of Application Group

```yaml
Type: String
Parameter Sets: Get-AzVdApplicationGroup
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


