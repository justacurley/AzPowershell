#Use Azure Monitor Rules to find potential startonconnect VMs, use Azure Monitor Action group to execute runbook
#VM is Stopped or Deallocated
#User tries to connect through WVD
#User receives error code 0x3000046
#Hostpool error stream log written to log analytics, error code -2146233088
#Azure Monitor catches that log and sends it to this runbook. 
param(
    [object]$WebHookData
)
$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'

$WebHookData = [PSCustomObject]@{
    RequestBody = ($WebHookData.RequestBody | ConvertFrom-Json)
} 
#Grab Table Columns
$Headers = $WebHookData.RequestBody.SearchResults.Tables.Columns.Name
#If there is only one searchResult, the Rows property is an array of strings, if it's more than one the Rows property is an array of arrays so we can't assume what we're looping over.
#Rebuild table with search results rows
$AllRows = $WebHookData.RequestBody.SearchResults.Tables.Rows
$SearchResults = @()
if ($WebHookData.RequestBody.SearchResults.Statistics.Query.datasetStatistics.tableRowCount -eq 1) {
    $RowResult = [PSCustomObject]@{}
    for ($y = 0; $y -lt $AllRows.Count; $y++) {
        #For some reason, the string array values in $AllRows are arrays themselves
        $RowResult | Add-Member NoteProperty ($Headers[$y]) ($AllRows[$y] -as [string])
    }
    $SearchResults += $RowResult
}
else {
    $AllRows | foreach {
        $row = $_
        $RowResult = [PSCustomObject]@{}
        for ($i = 0; $i -lt $row.Count; $i++) {
            $RowResult | Add-Member NoteProperty ($Headers[$i]) ($row[$i] -as [string])
        }
        $SearchResults += $RowResult
    }
}
$SearchResults = $SearchResults | Select-Object UserName, _ResourceId -Unique

#Connect to Azure
try {
    $vars = @{
        ConnectionName = (Get-AutomationVariable -Name 'Internal_ConnectionName')
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


$SearchResults | foreach {
    try {
        $UserName = $_.UserName
        $HostPoolID = $_."_ResourceId"
    
        #Get all session hosts in pool, filter down to WVD VM assigned to $UserName
        $HPSplit = $HostPoolID.Split('/')
        $SessionHosts = Get-AzWvdSessionHost -HostPoolName $HPSplit[-1] -ResourceGroupName $HPSplit[4]
        $AssignedHost = $SessionHosts | Where-Object { $_.AssignedUser -ieq $Username } 
        
        #If the VM is running, do nothing, otherwise start it
        $AzVM = Get-AzVM -Name $AssignedHost.ResourceId.Split('/')[-1] -ResourceGroupName $AssignedHost.ResourceId.Split('/')[4] -Status 
        $AzVMStatus = (($AzVM).statuses | Where-Object { $_.Code -Match "PowerState" }).Code 
        Write-Output $AzVMStatus
        if ($AzVMStatus -match "running|start|updat") {
            Write-Output "$($vm.Name) is already online"    
        }
        else {
            Write-Output "Starting $($AZVM.Name)"
            $AzVM | Start-AzVM 
        }        
    }
    catch {
        Write-Warning $PSItem.Message
    }
}