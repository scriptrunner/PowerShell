﻿#Requires -Version 5.0

<#
    .SYNOPSIS
        Sets the properties of an administrator
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires the library script CitrixLibrary.ps1
        Requires PSSnapIn Citrix*

    .LINK
        https://github.com/scriptrunner/ActionPacks/blob/master/Citrix/Administration
        
    .Parameter SiteServer
        [sr-en] Specifies the address of a XenDesktop controller. 
        This can be provided as a host name or an IP address
        [sr-de] Name oder IP Adresse des XenDesktop Controllers

    .Parameter Name
        [sr-en] Name of the administrator to modify
        [sr-de] Name des Administrators

    .Parameter SID
        [sr-en] SID of the administrator to modify
        [sr-de] SID des Administrators

    .Parameter Enabled
        [sr-en] Specifies the new value
        [sr-de] Administrator wird aktiviert J/N
#>

param(
    [Parameter(Mandatory = $true,ParameterSetName = 'ByName')]
    [string]$Name,    
    [Parameter(Mandatory = $true,ParameterSetName = 'BySID')]
    [string]$SID,
    [Parameter(Mandatory = $true,ParameterSetName = 'ByName')]
    [Parameter(Mandatory = $true,ParameterSetName = 'BySID')]
    [bool]$Enabled,
    [Parameter(ParameterSetName = 'ByName')]
    [Parameter(ParameterSetName = 'BySID')]
    [string]$SiteServer
)                                                            

$LogID = $null
[bool]$success = $false
try{ 
    [string[]]$Properties = @('Name','Enabled','Rights','SID')
    StartCitrixSessionAdv -ServerName ([ref]$SiteServer)
    [string]$tmpName = $Name
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'AdminAddress' = $SiteServer
                            'Enabled' = $Enabled
                            'PassThru' = $null
                            }    

    if($PSCmdlet.ParameterSetName -eq 'BySID'){
        $cmdArgs.Add('Sid',$SID)
        $tmpName = $SID
    }
    else{
        $cmdArgs.Add('Name',$Name)
    }
    StartLogging -ServerAddress $SiteServer -LogText "Set administrator $($tmpName)" -LoggingID ([ref]$LogID)
    $cmdArgs.Add('LoggingID',$LogID)
    
    $ret = Set-AdminAdministrator @cmdArgs | Select-Object $Properties
    $success = $true
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $ret
    }
    else{
        Write-Output $ret
    }
}
catch{
    throw 
}
finally{
    StopLogging -LoggingID $LogID -ServerAddress $SiteServer -IsSuccessful $success
    CloseCitrixSession
}