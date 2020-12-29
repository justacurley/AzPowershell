#Prerequisite
# -Automation Account with runAs account service principal which has rights to Start VMs
# -Diagnostic Settings (Error) enabled for WVD HostPool, pointing at a log analytics workspace

$Params = @{
    Subscription                       = ''
    AutomationAccountName              = ''
    AutomationAccountResourceGroupName = ''
    AutomationAccountConnectionName    = ''
    OMSWorkspaceID                     = ''
}
$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'
#Upload runbook, update automation account, create webhook
if ((Get-AzContext).Subscription.Id -ne $Params.Subscription) {
    Select-AzSubscription -Subscription $Params.Subscription
}
try {
    $AA = Get-AzAutomationAccount -ResourceGroupName $Params.AutomationAccountResourceGroupName -Name $Params.AutomationAccountName 
    $RunbookLocal = Get-ChildItem $PSScriptRoot\StartOnConnect.ps1 
    Import-AzAutomationRunbook -Path $RunbookLocal.FullName -Name $RunbookLocal.BaseName -Description "Powers On Stopped/Deallocated VMs after connection failure" -Type PowerShell -Published:$true -ResourceGroupName $Params.AutomationAccountResourceGroupName -AutomationAccountName $Params.AutomationAccountName -Force
    $Webhook = New-AzAutomationWebhook -Name $RunbookLocal.BaseName -RunbookName $RunbookLocal.BaseName -IsEnabled $true -ExpiryTime (Get-Date).AddYears(1) -ResourceGroupName $Params.AutomationAccountResourceGroupName -AutomationAccountName $Params.AutomationAccountName -Force
    $Webhook.WebhookURI
    if (!(Get-AzAutomationVariable -Name 'Internal_ConnectionName' -ResourceGroupName $Params.AutomationAccountResourceGroupName -AutomationAccountName $Params.AutomationAccountResourceGroupName)) {
        New-AzAutomationVariable -Name 'Internal_ConnectionName' -Value $Params.AutomationAccountConnectionName -Encrypted:$false -ResourceGroupName $Params.AutomationAccountResourceGroupName -AutomationAccountName $Params.AutomationAccountName
    }
}
catch {
    throw $_; break
}
#Create alert and action group
$DepParams = @{
    actionGroupName      = 'StartOnConnect'
    actionGroupShortName = 'StartOnCon'
    sourceId             = $Params.OMSWorkspaceID
    Location             = 'EastUS2'
    WebHookURI           = $Webhook.WebhookURI
}
New-AzResourceGroupDeployment -Name 'AlertDeployment' -ResourceGroupName $Params.AutomationAccountResourceGroupName -Mode Incremental `
    -TemplateFile $PSScriptRoot\azuredeploy-alert.json -TemplateParameterObject $DepParams