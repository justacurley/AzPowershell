function Get-AzVdHostPool {
    <#
    .SYNOPSIS
        A wrapper for Get-AzWvdHostPool
    .DESCRIPTION
        Includes tab completion for $HostPoolName and $ResourceGroupName
    .EXAMPLE
        PS C:\> Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName

        Get a WVD HostPool

        Location Name           Type
        -------- ----           ----
        eastus2  HostPoolName   Microsoft.DesktopVirtualization/hostpools
    .EXAMPLE
        PS C:\> Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -AppGroup

        List Application Group ResourceId's assocaited with the WVD HostPool. Use the -AppGroup switch when piping
        this command to Get-AzVdApplicationGroup or Get-AzVdAssignments

        AppGroupID
        ----------
        /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/ResourceGroupName/providers/Microsoft.DesktopVirtualization/applicationgroups/ApplicationGroupName
    #>
    [cmdletbinding()]
    param(
        [parameter(Mandatory, HelpMessage = "Name of the HostPool")]
        [string]$HostPoolName,
        [parameter(Mandatory, HelpMessage = "Name of the Resource Group containing the HostPool")]
        [string]$ResourceGroupName,
        [parameter(HelpMessage = "Returns the Resource Ids of Application Groups associated with the HostPool")]
        [switch]$AppGroup
    )
    process {
        try {
            $HP = Get-AzWvdHostPool -Name $HostPoolName -ResourceGroupName $ResourceGroupName
        }
        catch {
            throw $_
        }
        if ($AppGroup) {
            $HP.ApplicationGroupReference | Foreach-Object {
                [pscustomobject]@{
                    AppGroupID = $_
                }
            }
        }
        else {
            $HP
        }
    }
}
Export-ModuleMember Get-AzVdHostPool
function Get-AzVdApplicationGroup {
    <#
    .SYNOPSIS
        A wrapper for Get-AzWvdApplicationGroup
    .DESCRIPTION
        Supports pipeline input and includes tab completion for $HostPoolName and $ResourceGroupName
    .EXAMPLE
        PS C:\> Get-AzVdApplicationGroup -Name ApplicationGroupName -ResourceGroupName ResourceGroupName

        Get an Application Group

        Location Name                   Type
        -------- ----                   ----
        eastus2  ApplicationGroupName   Microsoft.DesktopVirtualization/applicationgroups
    .EXAMPLE
        PS C:\> Get-AzVdApplicationGroup -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName

        Get all Application Groups referenced by a HostPool

        Location Name                Type
        -------- ----                ----
        eastus2  Remote Applications Microsoft.DesktopVirtualization/applicationgroups
        eastus2  Remote Chrome       Microsoft.DesktopVirtualization/applicationgroups
        eastus2  ApplicationGroup... Microsoft.DesktopVirtualization/applicationgroups
    .EXAMPLE
        PS C:\> Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -AppGroup | Get-AzVdApplicationGroup

        Get all Application Groups referenced by a HostPool

        Location Name                   Type
        -------- ----                   ----
        eastus2  ApplicationGroupName   Microsoft.DesktopVirtualization/applicationgroups
    #>
    [cmdletbinding(DefaultParameterSetName = "Name")]
    param(
        [parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = "ID", Mandatory, HelpMessage = "Resource Id of Application Group")]
        [string]$AppGroupID,
        [parameter(ParameterSetName = "Name", Mandatory, HelpMessage="Name of Application Group")]
        [string]$Name,
        [parameter(ParameterSetName = "HostPool", Mandatory, HelpMessage="Name of Resource Group")]
        [parameter(ParameterSetName = "Name")]
        [string]$ResourceGroupName,
        [parameter(ParameterSetName = "HostPool", Mandatory, HelpMessage="Name of HostPool")]
        [string]$HostPoolName
    )
    process {
        if ($PSCmdLet.ParameterSetName -eq 'ID') {
            $GetAzWvdApplicationGroupParams = splitid $AppGroupID
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'HostPool') {
            $GetAzWvdApplicationGroupParams = Get-AzVdHostPool -HostPoolName $HostPoolName -ResourceGroupName $ResourceGroupName -AppGroup | Foreach-Object {
                splitid $_.AppGroupID
            }
        }
        else {
            $GetAzWvdApplicationGroupParams = @{
                Name              = $Name
                ResourceGroupName = $ResourceGroupName
            }
        }

        try {
            $GetAzWvdApplicationGroupParams | Foreach-Object {
                Get-AzWvdApplicationGroup @_
            }
        }
        catch {
            throw $_
        }
    }
}
Export-ModuleMember Get-AzVdApplicationGroup
function Get-AzVdAssignment {
    <#
    .SYNOPSIS
        Get 'Desktop Virtualization User' role assignments
    .DESCRIPTION
        Get role assignments for a given Application Group(s)
    .EXAMPLE
        PS C:\> Get-AzVdApplicationGroup -Name ApplicationGroupName -ResourceGroupName ResourceGroupName | Get-AzVdAssignment

        Get role assignments for and Application Group

        RoleAssignmentId   : /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/ResourceGroupName/providers/Microsoft.DesktopVirtualization/applicationgroups/ApplicationGroupName/providers/Microsoft.Authorization/roleAssignments/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
        Scope              : /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/ResourceGroupName/providers/Microsoft.DesktopVirtualization/applicationgroups/ApplicationGroupName
        DisplayName        : Group Display Name
        SignInName         :
        RoleDefinitionName : Desktop Virtualization User
        ...
    .EXAMPLE
        PS C:\> Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -AppGroup | Get-AzVdAssignment

        Get role assignments for all Application Groups referenced by HostPool

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
    #>
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName = $true, Mandatory, ParameterSetName = "Get-AzVdHostPool", HelpMessage="Output of Get-AzVdHostPool")]
        [string]$AppGroupID,
        [parameter(ValueFromPipelineByPropertyName = $true, Mandatory, ParameterSetName = "Get-AzVdApplicationGroup", HelpMessage="ResourceId of Application Group")]
        [string]$Id
    )
    begin {
        $GetAzRoleAssignmentParams = @{
            RoleDefinitionName = 'Desktop Virtualization User'
            Scope              = $null
        }
    }
    process {
        if ($AppGroupID) {
            $GetAzRoleAssignmentParams.Scope = $AppGroupID
        }
        else { $GetAzRoleAssignmentParams.Scope = $Id }
        try {
            Get-AzRoleAssignment @GetAzRoleAssignmentParams
        }
        catch {
            throw $_
        }
    }
}
Export-ModuleMember Get-AzVdAssignment
function Get-AzVdHost {
    <#
    .SYNOPSIS
        A wrapper for Get-AzWvdSessionHost
    .DESCRIPTION
        Supports pipeline input, wildcards for SessionHost names, and includes tab completion for $HostPoolName and $ResourceGroupName
    .EXAMPLE
        PS C:\> Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName

        Get all WVD SessionHosts in a HostPool

        Name                                                  Type
        ----                                                  ----
        HostPoolName/VDBASENAME001.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
        HostPoolName/VDBASENAME002.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
        HostPoolName/VDBASENAME003.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
        HostPoolName/VDBASENAME004.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
    .EXAMPLE
        PS C:\> Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName | Get-AzVdHost

        Get a all WVD SessionHosts in a HostPool by piping Get-AzVdHostPool

        Name                                                  Type
        ----                                                  ----
        HostPoolName/VDBASENAME001.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
        HostPoolName/VDBASENAME002.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
        HostPoolName/VDBASENAME003.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
        HostPoolName/VDBASENAME004.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
    .EXAMPLE
        PS C:\> Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName | Get-AzVdHost -VDName vdbasename001.fqdn.local

        Get a specific WVD SessionHost

        Name                                                  Type
        ----                                                  ----
        HostPoolName/VDBASENAME001.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
    .EXAMPLE
        PS C:\> Get-AzVdHostPool -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName | Get-AzVdHost -VDName "*vdbasename[1-2]*"

        Get a list of WVD SessionHosts using wildcards

        Name                                                  Type
        ----                                                  ----
        HostPoolName/VDBASENAME001.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
        HostPoolName/VDBASENAME002.fqdn.local Microsoft.DesktopVirtualization/hostpools/sessionhosts
    #>
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName = $true, Mandatory, ParameterSetName = "ID", HelpMessage="Resource Id of Session Host")]
        [string]$Id,
        [parameter(ValueFromPipelineByPropertyName, Mandatory, HelpMessage = "Name of the HostPool containing the Session Host", ParameterSetName = "Name")]
        [string]$HostPoolName,
        [parameter(ValueFromPipelineByPropertyName, Mandatory, HelpMessage = "Name of the Resource Group containing the HostPool", ParameterSetName = "Name")]
        [string]$ResourceGroupName,
        [parameter(HelpMessage = "Name of the Session Host. If not provided, all Session Hosts in the HostPool will be returned")]
        [SupportsWildCards()]
        [string]$VDName
    )
    process {
        try {
            if ($PSCmdLet.ParameterSetName -eq 'ID') {
                $GetAzWvdSessionHostParams = splitid $Id @{Name='HostPoolName'}
            }
            else {
                $GetAzWvdSessionHostParams = @{
                    HostPoolName = $HostPoolName
                    ResourceGroupName = $ResourceGroupName
                }
            }
            if ($VDName) {
                if ($VDName -Match "\*|\[|\?|\^") {
                    Get-AzWvdSessionHost @GetAzWvdSessionHostParams | Where-Object { $_.Name -like $VDName }
                }
                else {
                    Get-AzWvdSessionHost @GetAzWvdSessionHostParams -Name $VDName
                }
            }
            else {
                Get-AzWvdSessionHost @GetAzWvdSessionHostParams
            }
        }
        catch {
            throw $_
        }
    }
}
Export-ModuleMember Get-AzVdHost
function Set-AzVdLogin {
    <#
    .SYNOPSIS
        A wrapper for Update-AzWvdSessionHost -AllowNewSession
    .DESCRIPTION
        Designed for pipeline input. Does not include ResourceGroupName/HostPoolName.
    .EXAMPLE
        PS C:\> Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName vdbasename001.fqdn.local | Set-AzVdLogin -AllowNewSession:$false | Select Name,AllowNewSession

        Drain a specific WVD Session Host

        Name                                    AllowNewSession
        ----                                    ---------------
        HostPoolName/VDBASENAME001.fqdn.local   False

    .EXAMPLE
        PS C:\> Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName "*vdbasename00[1-3]*" | Set-AzVdLogin -AllowNewSession:$false | Select Name,AllowNewSession

        Drain a list of WVD Session Hosts

        Name                                    AllowNewSession
        ----                                    ---------------
        HostPoolName/VDBASENAME001.fqdn.local   False
        HostPoolName/VDBASENAME002.fqdn.local   False
        HostPoolName/VDBASENAME003.fqdn.local   False

    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [parameter(ValueFromPipelineByPropertyName, HelpMessage="Resource Id of Session Host")]
        [string]$Id,
        [parameter(Mandatory, HelpMessage="Enable/Disable Drain Mode for Session Host")]
        [switch]$AllowNewSession
    )
    process {
        try {
            $UpdateAzWvdSessionHostParams = splitid -ResourceId $Id
            Update-AzWvdSessionHost @UpdateAzWvdSessionHostParams -AllowNewSession:$AllowNewSession
        }
        catch {
            throw $_
        }
    }
}
Export-ModuleMember Set-AzVdLogin
function Get-AzVdSession {
    <#
    .SYNOPSIS
        A wrapper for Get-AzWvdUserSession
    .DESCRIPTION
        Supports pipeline input from Get-AzVdHost and includes tab completion for $HostPoolName and $ResourceGroupName
    .EXAMPLE
        PS C:\> Get-AzVdSession -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName

        Lists WVD Sessions in a HostPool

        Name                                                      Type
        ----                                                      ----
        HostPoolName/VDBASENAME001.fqdn.local/7   Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
        HostPoolName/VDBASENAME001.fqdn.local/10  Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
        HostPoolName/VDBASENAME002.fqdn.local/7   Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
        HostPoolName/VDBASENAME003.fqdn.local/3   Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
        HostPoolName/VDBASENAME003.fqdn.local/60  Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
    .EXAMPLE
        PS C:\> Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName "*vdbasename001*" | Get-AzVdSession

        Lists WVD Sessions in a SessionHost

        Name                                                      Type
        ----                                                      ----
        HostPoolName/VDBASENAME001.fqdn.local/7   Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
        HostPoolName/VDBASENAME001.fqdn.local/10  Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions
    #>
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = "ID", Mandatory, HelpMessage="Resource Id of Session Host")]
        [string]$Id,
        [parameter(ParameterSetName = "HostPool", Mandatory, HelpMessage = "Name of the HostPool containing the Session Host")]
        [string]$HostPoolName,
        [parameter(ParameterSetName = "HostPool", Mandatory, HelpMessage = "Name of the Resource Group containing the HostPool")]
        [string]$ResourceGroupName
    )
    process {
        if ($PSCmdLet.ParameterSetName -eq 'ID') {
            $GetAzWvdUserSessionParams = splitid $Id @{Name = 'SessionHostName' }
        }
        else {
            $GetAzWvdUserSessionParams = @{ResourceGroupName = $ResourceGroupName; HostPoolName = $HostPoolName }
        }
        try {
            $GetAzWvdUserSessionParams | ForEach-Object {
                Get-AzWvdUserSession @_
            }
        }
        catch {
            throw $_
        }
    }
}
Export-ModuleMember Get-AzVdSession
function Disconnect-AzVdSession {
    <#
    .SYNOPSIS
        A wrapper for Disconnect-AzWvdUserSession
    .DESCRIPTION
        Supports pipeline input from Get-AzVdSession
    .EXAMPLE
        PS C:\> Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName vdname001.fqdn.local | Get-AzVdSession | Disconnect-AzVdSession

        Disconnects all sessions on a SessionHost
    #>
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName = $true, Mandatory, HelpMessage = "Resource Id of User Session")]
        [string]$Id
    )
    process {
        $DisconnectAzWvdUserSessionParams = splitid $Id
        try {
            Disconnect-AzWvdUserSession @DisconnectAzWvdUserSessionParams
        }
        catch {
            throw $_
        }
    }
}
Export-ModuleMember Disconnect-AzVdSession
function Remove-AzVdSession {
    <#
    .SYNOPSIS
        A wrapper for Remove-AzWvdUserSession
    .DESCRIPTION
        Supports pipeline input from Get-AzVdSession
    .EXAMPLE
        PS C:\> Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName vdname001.fqdn.local | Get-AzVdSession | Remove-AzVdSession

        Removes all sessions on a SessionHost
    #>
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName = $true, Mandatory, HelpMessage = "Resource Id of User Session")]
        [string]$Id
    )
    process {
        $RemoveAzWvdUserSessionParams = splitid $Id
        try {
            Remove-AzWvdUserSession @RemoveAzWvdUserSessionParams
        }
        catch {
            throw $_
        }
    }
}
Export-ModuleMember Remove-AzVdSession
function Stop-AzVdHost {
    <#
    .SYNOPSIS
        A wrapper for Stop-AzVM
    .DESCRIPTION
        Supports pipeline input from Get-AzVdHost
    .EXAMPLE
        PS C:\> Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName vdbasename001.fqdn.local | Stop-AzVdHost -Confirm:$false -Force

        Stop a Session Host without confirmation

        OperationId : 973605fd-a8f0-4355-b4b9-92e5b215ee15
        Status      : Succeeded
        StartTime   : 4/4/2021 3:58:30 PM
        EndTime     : 4/4/2021 3:59:53 PM
        Error       :
    .EXAMPLE
        PS C:\> Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName vdbasename001.fqdn.local | Stop-AzVdHost -Confirm:$false -Force -NoWait

        Request a Session Host be stopped and return to console

        RequestId                            IsSuccessStatusCode StatusCode ReasonPhrase
        ---------                            ------------------- ---------- ------------
        98dd96a5-3426-4bb6-87b3-653ee130b77b                True   Accepted Accepted
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Resource Id of Virtual Machine")]
        [string]$ResourceId,
        [parameter(HelpMessage = "Fire and forget Stop-AzVM")]
        [switch]$NoWait,
        [parameter(HelpMessage = "Skip confirmation")]
        [switch]$Force
    )
    begin {
        if ($Force) {
            $ConfirmPreference = 'None'
        }
    }
    process {
        try {
            $StopAzVMParams = splitid $ResourceId
            if ($PSCmdlet.ShouldProcess($StopAzVMParams.Name, 'Stop-AzVM')) {
                Stop-AzVM @StopAzVMParams -NoWait:$NoWait -Force:$Force
            }
        }
        catch {
            throw $_
        }
    }
}
Export-ModuleMember Stop-AzVdHost
function Restart-AzVdHost {
    <#
    .SYNOPSIS
        A wrapper for Restart-AzVM
    .DESCRIPTION
        Supports pipeline input from Get-AzVdHost
    .EXAMPLE
        PS C:\> Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName vdname001.fqdn.local | Restart-AzVdHost -Confirm:$false -Force

        Restart a Session Host without confirmation

        OperationId : 973605fd-a8f0-4355-b4b9-92e5b215ee15
        Status      : Succeeded
        StartTime   : 4/4/2021 3:58:30 PM
        EndTime     : 4/4/2021 3:59:53 PM
        Error       :
    .EXAMPLE
        PS C:\> Get-AzVdHost -HostPoolName HostPoolName -ResourceGroupName ResourceGroupName -VDName vdname001.fqdn.local | Restart-AzVdHost -Confirm:$false -Force -NoWait

        Request a Session Host be restarted and return to console

        RequestId                            IsSuccessStatusCode StatusCode ReasonPhrase
        ---------                            ------------------- ---------- ------------
        98dd96a5-3426-4bb6-87b3-653ee130b77b                True   Accepted Accepted
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [string]$ResourceId,
        [parameter(HelpMessage = "Fire and forget Restart-AzVM")]
        [switch]$NoWait,
        [parameter(HelpMessage = "Skip confirmation")]
        [switch]$Force
    )
    begin {
        if ($Force) {
            $ConfirmPreference = 'None'
        }
    }
    process {
        try {
            $RestartAzVMParams = splitid $ResourceId
            if ($PSCmdlet.ShouldProcess($Name, 'Restart-AzVM')) {
                Restart-AzVM @RestartAzVMParams -NoWait:$NoWait -Force:$Force
            }
        }
        catch {
            throw $_
        }
    }
}
Export-ModuleMember Restart-AzVdHost
function getAllHostPool {
    $AllHostPool = Get-AzResource -ResourceType Microsoft.DesktopVirtualization/hostpools
    if ($AllHostPool) {
        $AllHostPool | ForEach-Object {
            [pscustomobject]@{
                HostPoolName      = $_.Name
                ResourceGroupName = $_.ResourceGroupName
            }
        }
    }
    else {
        Write-Warning 'Did not find any hostpools'
    }
}
function splitid ([string[]]$ResourceId, [hashtable]$Mapping) {
    $ResourceId | Foreach-Object {
        $SplitId = $ResourceID.Split('/')
        $TypeLocation = $SplitId.IndexOf('providers')
        [string]$Type = $SplitId[($TypeLocation + 1)] + "/" + $SplitId[($TypeLocation + 2)]
        $AllParamOut = @()
        switch ($Type) {

            'Microsoft.DesktopVirtualization/hostpools' {
                if ($SplitId[-2] -eq 'usersessions') {
                    $Param = @{
                        Id                = $SplitId[-1]
                        SessionHostName   = $SplitId[-3]
                        HostPoolName      = $SplitId[-5]
                        ResourceGroupName = $SplitId[4]
                    }
                }
                elseif (($SplitId[-2] -eq 'sessionhosts')) {
                    $Param = @{
                        Name              = $SplitId[-1]
                        HostPoolName      = $SplitId[-3]
                        ResourceGroupName = $SplitId[4]
                    }
                }
                else {
                    $Param = @{
                        Name              = $SplitId[-1]
                        ResourceGroupName = $SplitId[4]
                    }
                }
            }
            Default {
                $Param = @{
                    Name              = $SplitId[-1]
                    ResourceGroupName = $SplitId[4]
                }
            }
        }
        if ($Mapping) {
            $ParamOut = @{}
            $Param.Keys | ForEach-Object {
                if ($Mapping.Keys -contains $_) {
                    $Value = $Param[$_]
                    $ParamOut.Add(($Mapping[$_]), $Value)
                }
                else {
                    $ParamOut.Add($_, $Param[$_])
                }
            }
            $AllParamOut += $ParamOut
        }
        else { $AllParamOut += $Param }
    }
    $AllParamOut
}
$HostPoolNameArgumentCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    if (!(Test-Path variable:HostPoolAdmin)) {
        $script:HostPoolAdmin = getAllHostPool
    }
    $HostPoolAdmin.HostPoolName | Where-Object { $_ -like "$wordToComplete*" } |
    Foreach-Object {
        $HostPoolName = $_
        [System.Management.Automation.CompletionResult]::new($HostPoolName, $HostPoolName, "ParameterValue", "$($HostPoolAdmin.HostPoolName.Count) HostPools available")
    }
}
$ResourceGroupNameArgumentCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    if (!(Test-Path variable:HostPoolAdmin)) {
        $script:HostPoolAdmin = getAllHostPool
    }
    if ($fakeBoundParameters.ContainsKey('HostPoolName')) {
        $HP = $fakeBoundParameters['HostPoolName']
        $ResourceGroup = $HostPoolAdmin | Where-Object { $_.HostPoolName -eq $HP }
        [System.Management.Automation.CompletionResult]::new($ResourceGroup.ResourceGroupName, $ResourceGroup.ResourceGroupName, "ParameterValue", "One associated Resource Group")
    }
    else {
        $HostPoolAdmin.ResourceGroupName | Where-Object { $_ -like "$wordToComplete*" } |
        Foreach-Object {
            $ResourceGroup = $_
            [System.Management.Automation.CompletionResult]::new($ResourceGroup, $ResourceGroup, "ParameterValue", "$($HostPoolAdmin.ResourceGroupName.Count) Resource Groups available")
        }
    }
}
'Get-AzVdHost', 'Get-AzVdHostPool', 'Get-AzVdApplicationGroup', 'Get-AzVdSession' | Foreach-Object {
    Register-ArgumentCompleter -CommandName $_ -ScriptBlock $HostPoolNameArgumentCompleter -ParameterName HostPoolName
    Register-ArgumentCompleter -CommandName $_ -ScriptBlock $ResourceGroupNameArgumentCompleter -ParameterName ResourceGroupName
}
