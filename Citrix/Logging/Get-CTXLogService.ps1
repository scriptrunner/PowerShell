﻿#Requires -Version 5.0

<#
    .SYNOPSIS
        Gets the service record entries for the ConfigurationLogging Service
    
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
        https://github.com/scriptrunner/ActionPacks/blob/master/Citrix/Logging
        
    .Parameter ControllerServer
        [sr-en] Address of a XenDesktop controller. 
        This can be provided as a host name or an IP address
        [sr-de] Name oder IP Adresse des XenDesktop Controllers

    .Parameter MaxRecordCount	
        [sr-en] Maximum number of records to return	
        [sr-de] Maximale Anzahl der Ergebnisse

    .Parameter Properties
        [sr-en] List of properties to expand. Use * for all properties
        [sr-de] Liste der zu anzuzeigenden Eigenschaften. Verwenden Sie * für alle Eigenschaften
#>

param( 
    [string]$ControllerServer,
    [int]$MaxRecordCount = 250,
    [ValidateSet('*','MachineName','CurrentState','DNSName','DatabaseUserName','LastActivityTime','LastStartTime','MetadataMap','OSType','OSVersion','SID','ServiceHostId','ServiceVersion','Uid')]
    [string[]]$Properties = @('MachineName','CurrentState','DatabaseUserName','LastActivityTime','LastStartTime')
)   

try{ 
    StartCitrixSessionAdv -ServerName ([ref]$ControllerServer)
    if($Properties -contains '*'){
        $Properties = @('*')
    }
        
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'AdminAddress' = $ControllerServer
                            'MaxRecordCount' = $MaxRecordCount
                            }

    $ret = Get-LogService @cmdArgs | Select-Object $Properties

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
    CloseCitrixSession
}