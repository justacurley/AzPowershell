$Params = @{
    #Guid of subscription where automation account and WVD RGs reside
    Subscription                       = ''
    AutomationAccountName              = ''
    AutomationAccountResourceGroupName = ''
    AutomationAccountConnectionName    = ''
    #full resource Id of log analytics workspace
    OMSWorkspaceID                     = ''
}
$CommonParams = @{
    AutomationAccountname = $Params.AutomationAccountName 
    ResourceGroupName     = $Params.AutomationAccountResourceGroupName
}
$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'
#Upload runbook, update automation account, create webhook
if ((Get-AzContext).Subscription.Id -ne $Params.Subscription) {
    Select-AzSubscription -Subscription $Params.Subscription
}
try {
    $AA = Get-AzAutomationAccount @CommonParams 

    #Upload Runbook
    $RunbookLocal = Get-ChildItem $PSScriptRoot\AgentVersionCheck.ps1 
    Write-Verbose "Uploading runbook AgentVersionCheck"
    Import-AzAutomationRunbook -Path $RunbookLocal.FullName -Name $RunbookLocal.BaseName -Description "Checks for WVD Agent Updates. Sends message to log analytics when new version is detected." `
        -Type PowerShell -Published:$true @CommonParams -Force
    
    #Create Automation Account credential for Log Analytics Workspace
    Write-Verbose "Creating OMS credential object"
    $CustomerID = (Get-AzOperationalInsightsWorkspace -ResourceGroupName ($Params.OMSWorkspaceID.Split('/'))[4] -Name ($Params.OMSWorkspaceID.Split('/'))[-1]).CustomerID
    $OMSKey = (Get-AzOperationalInsightsWorkspaceSharedKey -ResourceGroupName ($Params.OMSWorkspaceID.Split('/'))[4] -Name ($Params.OMSWorkspaceID.Split('/'))[-1]).PrimarySharedKey
    [pscredential]$credObject = New-Object System.Management.Automation.PSCredential (($CustomerID, (ConvertTo-SecureString -String $OMSKey -AsPlainText -Force)))
    if (!(Get-AzAutomationCredential -Name 'WVD_OMSWorkspace' @CommonParams -ErrorAction Ignore)) { New-AzAutomationCredential -Name 'WVD_OMSWorkspace' -Description "OMS Workspace shared key for writing custom logs" -Value $credObject @CommonParams }
    else { Set-AzAutomationCredential -Name 'WVD_OMSWorkspace' -Description "OMS Workspace shared key for writing custom logs" -Value $credObject @CommonParams }
    
    #Create variables for and by use of? automation account
    $Vars = @{
        Internal_ConnectionName    = $Params.AutomationAccountConnectionName
        Internal_AutomationAccountName = $Params.AutomationAccountName
        Internal_ResourceGroupName     = $Params.AutomationAccountResourceGroupName
        WVD_AgentVersions          = ( Get-AzWvdHostPool | % {
                [PSCustomObject]@{
                    HostPool     = $_.Name
                    AgentVersion = '0.0.0.0'
                }
            } | ConvertTo-Json )
    }
    $vars.GetEnumerator() | % {
        $name = $_.Key
        $value = $_.Value
        Write-Verbose "Creating $name variable"
        if (!(Get-AzAutomationVariable -Name $name @CommonParams -ErrorAction Ignore)) { New-AzAutomationVariable -Name $name -Value ($value -as [string]) -Encrypted:$false @CommonParams }
        else { Set-AzAutomationVariable -Name $name -Value ($value -as [string]) -Encrypted:$false @CommonParams }
        
    }

    #Upload OMSDataInjection Module from powershell gallery if not exist
    if (!(Get-AzAutomationModule @CommonParams -Name 'OMSDataInjection' -ErrorAction Ignore)) {
        Write-Verbose "Uploading OMSDataInjection Module"
        $Module = (Find-Module -Name OMSDataInjection)
        $sourceLocation = $Module.repositorysourceLocation
        if (!($sourceLocation.EndsWith('/'))) { $sourceLocation += '/' }
        $uri = '{0}package/{1}/{2}' -f $sourceLocation, $Module.Name, ($module.Version -as [string])
        New-AzAutomationModule -Name 'OMSDataInjection' -ContentLinkUri $uri @CommonParams        
    }

    Write-Verbose "Creating hourly schedule"
    #Create an automation schedule for the runbook and register it
    $Schedule = New-AzAutomationSchedule -TimeZone UTC -Name 'WVDAgentVersionCheck' -StartTime (Get-Date).AddHours(1) -HourInterval 1 @CommonParams
    Register-AzAutomationScheduledRunbook -RunbookName $RunbookLocal.BaseName -ScheduleName $schedule.Name @CommonParams

}
catch {
    throw $_; break
}
#Create alert and action group
$DepParams = @{
    actionGroupName      = 'WVDAgentVersion'
    actionGroupShortName = 'WVDAgentVers'
    actionGroupMembers   = @('email.1@netscape.net', 'michael.guntherberg@netscape.net', 'stephen.berens@netscape.net')
    sourceId             = $Params.OMSWorkspaceID
    Location             = 'EastUS2'
}
Write-Verbose "Deploying Action Group and Alert Rule"
New-AzResourceGroupDeployment -Name 'AlertDeployment' -ResourceGroupName $Params.AutomationAccountResourceGroupName -Mode Incremental `
    -TemplateFile $PSScriptRoot\azuredeploy-alert.json -TemplateParameterObject $DepParams 