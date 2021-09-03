param(
    [parameter(mandatory)]
    [string]$HostPoolName,
    [parameter(mandatory)]
    [string]$HostPoolResourceGroupName,
    [parameter(mandatory)]
    [string]$SessionHostName,
    [parameter(mandatory)]
    [pscredential]$Credential,
    #Use VMName if the name of the Azure VM object differs from the SessionHostName
    [parameter(mandatory = $false)]
    [string]$VMName,
    #Use VMResourceGroupName if the VM rg is different from HostPoolResourceGroupName
    [parameter(mandatory = $false)]
    [string]$VMResourceGroupName
)
$VerbosePreference='continue'
try {
    if (!$VMResourceGroupName) { $VMResourceGroupName = $HostPoolResourceGroupName }
    if (!$VMName) { $VMName = $SessionHostName.split('.')[0] }
    if (Get-AzWvdSessionHost -HostPoolName $HostPoolName -ResourceGroupName $HostPoolResourceGroupName -Name $SessionHostName -ErrorAction Ignore -Verbose) {
        Remove-AzWvdSessionHost -HostPoolName $HostPoolName -ResourceGroupName $HostPoolResourceGroupName -Name $SessionHostName -Force -Confirm:$false -Verbose
    }
    else { Write-Verbose "$SessionHostName already removed from $HostpoolName" }

    $RegInfo = New-AzWvdRegistrationInfo -HostPoolName $HostPoolName -ResourceGroupName $HostPoolResourceGroupName -ExpirationTime (Get-Date).AddDays(1) -Verbose
    $ScriptBlock = {
        param(
            [string]$RegistrationToken
        )
        Function MSIEXEC_ExitCodes($Result) {
            Switch ($Result) {
                0 { return "Successful" }
                13 { return "The data is invalid." }
                87 { return "One of the parameters was invalid." }
                120 { return "This value is returned when a custom action attempts to call a function that cannot be called from custom actions. The function returns the value ERROR_CALL_NOT_IMPLEMENTED. Available beginning with Windows Installer version 3.0." }
                1259 { return "If Windows Installer determines a product may be incompatible with the current operating system, it displays a dialog box informing the user and asking whether to try to install anyway. This error code is returned if the user chooses not to try the installation." }
                1601 { return "The Windows Installer service could not be accessed. Contact your support personnel to verify that the Windows Installer service is properly registered." }
                1602 { return "User cancel installation." }
                1603 { return "Fatal error during installation.(Check the error log a prerequisite might be missing)" }
                1604 { return "Installation suspended, incomplete." }
                1605 { return "This action is only valid for products that are currently installed." }
                1606 { return "Feature ID not registered." }
                1607 { return "Component ID not registered." }
                1608 { return "Unknown property." }
                1609 { return "Handle is in an invalid state." }
                1610 { return "The configuration data for this product is corrupt. Contact your support personnel." }
                1611 { return "Component qualifier not present." }
                1612 { return "The installation source for this product is not available. Verify that the source exists and that you can access it." }
                1613 { return "This installation package cannot be installed by the Windows Installer service. You must install a Windows service pack that contains a newer version of the Windows Installer service." }
                1614 { return "Product is uninstalled." }
                1615 { return "SQL query syntax invalid or unsupported." }
                1616 { return "Record field does not exist." }
                1618 { return "Another installation is already in progress. Complete that installation before proceeding with this install." }
                1619 { return "This installation package could not be opened. Verify that the package exists and that you can access it, or contact the application vendor to verify that this is a valid Windows Installer package." }
                1620 { return "This installation package could not be opened. Contact the application vendor to verify that this is a valid Windows Installer package." }
                1621 { return "There was an error starting the Windows Installer service user interface. Contact your support personnel." }
                1622 { return "Error opening installation log file. Verify that the specified log file location exists and is writable." }
                1623 { return "This language of this installation package is not supported by your system." }
                1624 { return "There was an error applying transforms. Verify that the specified transform paths are valid." }
                1625 { return "This installation is forbidden by system policy. Contact your system administrator." }
                1626 { return "Function could not be executed." }
                1627 { return "Function failed during execution." }
                1628 { return "Invalid or unknown table specified." }
                1629 { return "Data supplied is of wrong type." }
                1630 { return "Data of this type is not supported." }
                1631 { return "The Windows Installer service failed to start. Contact your support personnel." }
                1632 { return "The temp folder is either full or inaccessible. Verify that the temp folder exists and that you can write to it." }
                1633 { return "This installation package is not supported on this platform. Contact your application vendor." }
                1634 { return "Component is not used on this machine." }
                1635 { return "This patch package could not be opened. Verify that the patch package exists and that you can access it, or contact the application vendor to verify that this is a valid Windows Installer patch package." }
                1636 { return "This patch package could not be opened. Contact the application vendor to verify that this is a valid Windows Installer patch package." }
                1637 { return "This patch package cannot be processed by the Windows Installer service. You must install a Windows service pack that contains a newer version of the Windows Installer service." }
                1638 { return "Another version of this product is already installed. Installation of this version cannot continue. To configure or remove the existing version of this product, use Add/Remove Programs on the Control Panel." }
                1639 { return "Invalid command line argument. Consult the Windows Installer SDK for detailed command line help." }
                1640 { return "The current user is not permitted to perform installations from a client session of a server running the Terminal Server role service." }
                1641 { return "The installer has initiated a restart. This message is indicative of a success." }
                1642 { return "The installer cannot install the upgrade patch because the program being upgraded may be missing or the upgrade patch updates a different version of the program. Verify that the program to be upgraded exists on your computer and that you have the correct upgrade patch." }
                1643 { return "The patch package is not permitted by system policy." }
                1644 { return "One or more customizations are not permitted by system policy." }
                1645 { return "Windows Installer does not permit installation from a Remote Desktop Connection." }
                1646 { return "The patch package is not a removable patch package. Available beginning with Windows Installer version 3.0." }
                1647 { return "The patch is not applied to this product. Available beginning with Windows Installer version 3.0." }
                1648 { return "No valid sequence could be found for the set of patches. Available beginning with Windows Installer version 3.0." }
                1649 { return "Patch removal was disallowed by policy. Available beginning with Windows Installer version 3.0." }
                1650 { return "The XML patch data is invalid. Available beginning with Windows Installer version 3.0." }
                1651 { return "Administrative user failed to apply patch for a per-user managed or a per-machine application that is in advertise state. Available beginning with Windows Installer version 3.0." }
                1652 { return "Windows Installer is not accessible when the computer is in Safe Mode. Exit Safe Mode and try again or try using System Restore to return your computer to a previous state. Available beginning with Windows Installer version 4.0." }
                1653 { return "Could not perform a multiple-package transaction because rollback has been disabled. Multiple-Package Installations cannot run if rollback is disabled. Available beginning with Windows Installer version 4.5." }
                3010 { return "A restart is required to complete the install. This message is indicative of a success. This does not include installs where the ForceReboot action is run." }
                default { return "An unexpected return code was given. Unknown error." }
            }
        } 
        function Write-Log {
            [CmdletBinding()]
            param(
                [Parameter()]
                [ValidateNotNullOrEmpty()]
                [string]$Message,

                [Parameter(mandatory = $false)]        
                $Data,

                [Parameter()]
                [ValidateNotNullOrEmpty()]
                [ValidateSet('Information', 'Warning', 'Error')]
                [string]$Severity = 'Information',

                [parameter()]
                [ValidateNotNullOrEmpty()]
                [System.IO.FileInfo]$logsPath = "C:\Temp\WVDLogs\Master.csv"
            )        
            $Log = [pscustomobject]@{
                Time     = (get-date -f yyyMMdd-HHmmss)
                Severity = $Severity
                Message  = $Message    
                Data     = $Data    
            } 
            $Log
            $Log | Export-Csv -Path $logsPath -Append -NoTypeInformation 
        }
        function StandardUninstall {
            [CmdletBinding()]
            param(
                [Parameter()]
                $RegistryUninstallStrings,
                [Parameter()]
                [ValidateNotNullOrEmpty()]
                [string]$Pattern,
                [Parameter()]
                [ValidateNotNullOrEmpty()]
                [string]$Message
            ) 
            if ($pattern) { $RegistryUninstallStrings = $RegistryUninstallStrings | where displayName -Match $Pattern }

            if ($RegistryUninstallStrings.DisplayName.Count -ge 1) {
                Write-Log -Message $Message -Data "Found $($RegistryUninstallStrings.DisplayName.Count) UninstallStrings"
                $RegistryUninstallStrings | foreach {
                    if ($_.UninstallString -match "msiexec") {
                        #Remove msiexec from uninstall string
                        $unString = ($_.UninstallString -Replace "msiexec.exe", '' -Replace "/I", "/X").Trim()        
                        $logName = '{0}{1}_{2}.log' -f 'C:\Temp\WVDLogs\', $_.Version, ($_.DisplayName.Replace(' ', '_'))
                        $UninstallString = '{0} /passive REBOOT=ReallySuppress /LOG "{1}"' -f $unString, $logName                         
                        #Uninstall, #sleep 15, then grab the result from the log
                        try {
                            $uninstallString
                            Write-Log -Message $Message -Data "Starting Uninstall"
                            $Process = Start-Process -ea 0 -FilePath "MSIExec" -ArgumentList $UninstallString -Wait -PassThru
                            $Process.WaitForExit()   
                            $resolveReturnCode = MSIEXEC_ExitCodes $process.ExitCode                         
                            Write-Log -Message "$($Message)_$($_.Version) - Exit Code" -Data "$($Process.ExitCode) : $resolveReturnCode"
                        }
                        catch { Write-Log -Message "$($Message)_$($_.Version)" -Severity Error -Data $_ }
                    }
                    else { Write-Log -Message "$Message Current Uninstall String NOT msiexec" -Data $_.UninstallString }
                }
            }
            else {
                Write-Log -Message $Message -Data "DNF" -Severity Warning 
            }
        }
        $uninstallStrings = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -match "Infrastructure" } | Select-Object -Property DisplayName, UninstallString, InstallDate, Version, PSChildName
        $tmpPath = "C:\Temp\WVDLogs"
        $SuccessCodes = ('0', '3010')
        if (!(test-path $tmpPath)) {
            New-Item -ItemType Directory -Path $tmpPath | Out-Null
            (Write-Log -Message "$tmpPath Create")
        }
        else { (Write-Log -Message "$tmpPath Exists") }

        #Uninstall all versions of Remote Desktop Services Infrastructure Agent
        StandardUninstall -RegistryUninstallStrings $uninstallstrings -Message "Uninstalling RDSInfraAgent" 

        Invoke-WebRequest -uri 'https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv' -OutFile "$tmpPath\rdInfraAgent.msi"
        $agent_deploy_status = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $tmpPath\rdInfraAgent.msi", "/qn", "/norestart", "REGISTRATIONTOKEN=$RegistrationToken", "/l* $tmpPath\rdInfraAgent.log" -Wait -Passthru
        Start-Service RDAgentBootLoader -Verbose
    }

Invoke-Command -ComputerName $VMName -ScriptBlock $ScriptBlock -ArgumentList $RegInfo.Token -Credential $credential
}
catch {
    throw $_
}