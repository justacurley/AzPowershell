#Get all WVD hostpools
$global:AzHostPools = @{}
function Refresh-HostPools {
    $global:AzHostPools = @{}
    Get-AzWVDHostPool | foreach {
        $global:AzHostPools.add(($_.Name), ($_.Id.Split('/')[4]))
    }
}
function Get-AzVDHost {
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipeline = $true, Mandatory)] 
        [ArgumentCompleter( { $global:AzHostPools.Keys })]
        [string]$HostPoolName,
        [parameter(Mandatory = $false)]
        [string]$ResourceGroupName,
        [parameter(Mandatory = $false)]
        [SupportsWildcards()]
        [string]$VDName
    )
    
    if (!$ResourceGroupName) {
        $ResourceGroupName = $global:AzHostPools[$HostPoolName]        
    }
    try {
        if ($VDName) {
            Get-AzWVDSessionHost -HostPoolName $HostPoolName -ResourceGroupName $ResourceGroupName -ErrorAction Stop  | Where-Object { $_.Name -like $VDName } | Select *
        }
        else {
            Get-AzWVDSessionHost -HostPoolName $HostPoolName -ResourceGroupName $ResourceGroupName -ErrorAction Stop | Select *
        }
    }
    catch {
        throw $_
    }    
}
function Set-AzVDLogin {
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName)]         
        [string]$Id,
        [parameter(Mandatory)]     
        [bool]$AllowNewSession
    )
    process {
        try {
            $SplitID = $ID.split("/")
            Update-AzWvdSessionHost -HostPoolName $SplitID[-3] -Name $SplitID[-1] -ResourceGroupName $SplitID[4] -AllowNewSession:$AllowNewSession
        }
        catch {
            throw $_
        }
    }
}
function Get-AzVDHostPool { 
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipeline = $true, Mandatory)] 
        [ArgumentCompleter( { $global:AzHostPools.Keys })]
        [string]$HostPoolName,
        [parameter(Mandatory = $false)]
        [string]$ResourceGroupName,
        [switch]$AppGroup
    )        
    if (!$ResourceGroupName) {
        $ResourceGroupName = $global:AzHostPools[$HostPoolName]        
    }
    try {
        $HP = Get-AzWVDHostPool -Name $HostPoolName -ResourceGroupName $ResourceGroupName -EA 0
    }
    catch {
        throw $_
    }
    if ($AppGroup) {
        $HP.ApplicationGroupReference | % {
            [pscustomobject]@{
                AppGroupID = $_       
            }
        }
    }
    else {
        $HP
    }
}
function Get-AzVDAssignments {
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName = $true, Mandatory)]       
        [string]$AppGroupID   
    )    
    process {
        Get-AzRoleAssignment -Scope $AppGroupId -RoleDefinitionName 'Desktop Virtualization User'
    }    
}
function Stop-AzVDHost {
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName)]  
        [string]$Id,     
        [string]$ResourceGroupName,      
        [string]$Name
    )
    begin {
    }
    process {
        try {
            $SplitID = $ID.split("/")
            Stop-AzVM -Name ($SplitId[-1].split('.')[0]) -ResourceGroupName $SplitId[4] -Confirm:$false -NoWait  -Force
        }
        catch {
            throw $_
        }
    }
}
function Restart-AzVDHost {
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName)]  
        [string]$Id,     
        [string]$ResourceGroupName,      
        [string]$Name
    )
    
    process {
        try {
            $SplitID = $ID.split("/")
            Restart-AzVM -Name ($SplitId[-1].split('.')[0]) -ResourceGroupName $SplitId[4] -Confirm:$false -NoWait 
        }
        catch {
            throw $_
        }
    }
}
