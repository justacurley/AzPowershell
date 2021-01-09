
$VerbosePreference = 'Continue'
#Create Parameters for Log Object, to be sent to OMS
function New-OMSObject {
    param(
        [parameter(Mandatory, HelpMessage = "Name of the custom log for OMS")]
        [validateSet('SetSchedule', 'ScheduleRun', 'ScheduleAction', 'OverrideSchedule', 'Error')]
        [string]$LogType,
        [parameter(Mandatory, HelpMessage = "OMS Workspace CustomerID and Primary Key in PSCredential Object")]
        [PSCredential]$OMSCreds,
        [parameter(Mandatory, Helpmessage = "Name of the runbook currently being executed")]
        [string]$RunBookName,
        [parameter(Mandatory, HelpMessage = "PSBoundParameters for current runbook, or if ScheduleAction, pscustomobject of parameters given to function inside of current runbook")]
        [PSCustomObject]$Parameters,
        [parameter(HelpMessage = "GUID string created at the top level parent runbook FNF-VMAutomation")]
        [string]$ScheduleRunID
    )
    $OMS = @{
        OMSWorkspaceID    = $OMSCreds.UserName
        PrimaryKey        = $OMSCreds.GetNetworkCredential().Password
        LogType           = $LogType
        UTCTimeStampField = [datetime]::utcNow
        OMSDataObject     = [pscustomobject]@{
            ScheduleRunID = $ScheduleRunID
            RunBookName   = $RunBookName
            RunbookJobID  = $PSPrivateMetadata.JobId.GUID
            Parameters    = ($Parameters | ConvertTo-Json -Depth 99)
            Message       = $null
            Output        = $null
            Exceptions    = $null
            AppCaller     = $null
        }
    }
    #Keep this in here if we need to add special properties to individual log types
    switch ($LogType) {
        'ScheduleRun' { }
        'ScheduleAction' { }
        'SetSchedule' { }
        'OverrideSchedule' { }
    }
    return $OMS
}

#Get necessary credentials, variables, and connect to azure
try {
    $vars = @{
        AutomationAccount = Get-AutomationVariable -Name 'Internal_AutomationAccountName'
        ResourceGroup     = Get-AutomationVariable -Name 'Internal_ResourceGroupName'
        ConnectionName    = Get-AutomationVariable -Name 'Internal_ConnectionName'
        AgentVersions     = Get-AutomationVAriable -Name 'WVD_AgentVersions'
    }    
    $creds = @{
        OMS = Get-AutomationPSCredential -Name 'WVD_OMSWorkspace'
    }
    $servicePrincipalConnection = Get-AutomationConnection -Name $Vars.ConnectionName -ErrorAction Stop
    $newContext = Connect-AzAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint -ErrorAction Stop 
}
catch {
    throw $PSItem
}

#Agent Versions variable
$AllAgentVersions = $vars.AgentVersions | ConvertFrom-Json

#Get all hostpools, hosts, and latest agent version
$AllHostPools = Get-AzWvdHostPool 
$AllHostPools | foreach {
    $HostPoolName = $_.Name
    $HostPoolIDSplit = $_.ID.Split('/')
    $Hosts = Get-AzWvdSessionHost -HostPoolName $HostPoolName -ResourceGroupName $HostpoolIdSplit[4]
    #move on to next iteration if this pool has no registered hosts
    if (!$Hosts) { return }
    $LatestVersion = [version](($Hosts | group agentversion | select name | sort name -Descending)[0].name)
    $VersionRecord = $AllAgentVersions | Where-Object { $_.HostPool -eq $HostPoolName }
    $LastVersion = [version]$VersionRecord.AgentVersion 
    #Change in version, write log to OMS
    if ($LatestVersion -gt $LastVersion) {
        Write-Warning "$HostPoolName - $LatestVersion"
        $VersionRecord.AgentVersion = ($LatestVersion -as [string])
        $UpdatedHosts = ($Hosts | Where-Object { $_.AgentVersion -eq $LatestVersion }).HostName
        $parameters = [pscustomobject]@{HostPool = $HostPoolName; LastVersion = $LastVersion; LatestVersion = $LatestVersion }
        $OMS_SR = New-OMSObject -LogType ScheduleRun -OMSCreds $Creds.OMS -RunBookName 'AgentVersionCheck' -Parameters $parameters
        $OMS_SR.OMSDataObject.Output = $UpdatedHosts
        $OMS_SR.OMSDataObject.Message = "HostPool $HostPoolName WVD Agent Version has been upgraded from $LastVersion to $LatestVersion on $($UpdatedHosts.Count) Session Hosts"
        [void](New-OMSDataInjection @OMS_SR) 
    }
    #Newly deployed hostpool, add record to agent versions automation account var
    elseif (!$VersionRecord) {
        $AllAgentVersions += [PSCustomObject]@{
            HostPool     = $HostPoolName
            AgentVersion = ($LatestVersion -as [string])
        }
    }
    
}
Set-AzAutomationVariable -ResourceGroupName $vars.ResourceGroup -AutomationAccountName $vars.AutomationAccount -Name 'WVD_AgentVersions' -Value (($AllAgentVersions | ConvertTo-Json) -as [string]) -Encrypted $false









