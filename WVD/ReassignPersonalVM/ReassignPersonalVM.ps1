
param(
    [string]$ResourceGroupName,
    [string]$HostPoolName,
    [string]$SessionHostName,
    [pscredential]$SessionHostAdminCreds
)


$CommonParams = @{
    ResourceGroupName = $ResourceGroupName 
    HostPoolName = $HostPoolName
}

Remove-AzWvdSessionHost -Name $SessionHostName @CommonParams -Force
$RegInfo = New-AzWvdRegistrationInfo -ExpirationTime (Get-Date).AddDays(1) @CommonParams
Invoke-Command -ComputerName $SessionHostName -Credential $SessionHostAdminCreds -ScriptBlock {
    param($RegistrationToken)
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\RDInfraAgent\ -Name IsRegistered -Value 0 -passthru
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\RDInfraAgent\ -Name RegistrationToken -Value $RegistrationToken -Passthru
    #Not sure if this is required 
    Restart-Service RDAgent
    #This kicked off the registration
    start-service RDAgentBootLoader
} -ArgumentList $RegInfo.token
