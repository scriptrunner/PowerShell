﻿#Requires -Version 5.0

<#
    .SYNOPSIS
        Gets low level operations
    
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

    .Parameter StartTime	
        [sr-en] Low level operations with the specified start time
        [sr-de] Low Level Operationen mit der angegebenen Startzeit

    .Parameter EndTime
        [sr-en] Low level operations with the specified end time
        [sr-de] Low Level Operationen mit der angegebenen Endzeit

    .Parameter LogId
        [sr-de] Low level operation with the specified identifier
        [sr-de] ID der Low Level Operation

    .Parameter HighLevelOperationId	
        [sr-en] Low level operations for the low level operation with the specified identifier
        [sr-en] Low Level Operation mit dem angegebenen Low Level Operations Identifier

    .Parameter LogText
        [sr-en] Low level operation with the specified identifier
        [sr-de] ID der Low Level Operation

    .Parameter LogSource
        [sr-en] Low level operations with the specified source
        [sr-de] Source der Low Level Operationen

    .Parameter IsSuccessful
        [sr-en] Successful or unsuccessful Low level operations
        [sr-de] Erfolgreiche oder nicht erfolgreiche Low Level Operationen

    .Parameter User	
        [sr-en] Low level operations logged by the specified user
        [sr-de] Low Level Operationen dieses Benutzers

    .Parameter OperationType	
        [sr-en] Low level operations with the specified operation type
        [sr-en] Low Level Operationen diesen Typs

    .Parameter TargetType	
        [sr-en] Low level operations with the specified target type
        [sr-de] Low Level Operationen dieses Zielsystems

    .Parameter MaxRecordCount	
        [sr-en] Maximum number of records to return	
        [sr-de] Maximale Anzahl der Ergebnisse

    .Parameter Properties
        [sr-en] List of properties to expand. Use * for all properties
        [sr-de] Liste der zu anzuzeigenden Eigenschaften. Verwenden Sie * für alle Eigenschaften
#>

param( 
    [string]$ControllerServer,
    [datetime]$StartTime,
    [datetime]$EndTime,
    [string]$LogId,
    [string]$HighLevelOperationId,
    [string]$LogSource,
    [string]$LogText,
    [bool]$IsSuccessful,
    [string]$User,
    [ValidateSet('AdminActivity','ConfigurationChange ')]
    [string]$OperationType,
    [int]$MaxRecordCount = 250,
    [ValidateSet('*','Text','StartTime','EndTime','IsSuccessful','User','Source','OperationType','Id','HighLevelOperationId','AdminMachineIP','TargetTypes','SourceSdk','Parameters','Details')]
    [string[]]$Properties = @('Text','StartTime','EndTime','IsSuccessful','User','OperationType','Source','Id')
)                                                            

try{ 
    StartCitrixSessionAdv -ServerName ([ref]$ControllerServer)
    if($Properties -contains '*'){
        $Properties = @('*')
    }
        
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'AdminAddress' = $ControllerServer
                            'MaxRecordCount' = $MaxRecordCount
                            'SortBy' = '-StartTime'
                            }
    
    if($PSBoundParameters.ContainsKey('StartTime') -eq $true){
        $cmdArgs.Add('StartTime',$StartTime)
    }       
    if($PSBoundParameters.ContainsKey('EndTime') -eq $true){
        $cmdArgs.Add('EndTime',$EndTime)
    }
    if($PSBoundParameters.ContainsKey('LogId') -eq $true){
        $cmdArgs.Add('ID',$LogId)
    }   
    if($PSBoundParameters.ContainsKey('HighLevelOperationId') -eq $true){
        $cmdArgs.Add('HighLevelOperationId',$HighLevelOperationId)
    }       
    if($PSBoundParameters.ContainsKey('LogText') -eq $true){
        $cmdArgs.Add('Text',$LogText)
    }    
    if($PSBoundParameters.ContainsKey('LogSource') -eq $true){
        $cmdArgs.Add('Source',$LogSource)
    }    
    if($PSBoundParameters.ContainsKey('IsSuccessful') -eq $true){
        $cmdArgs.Add('IsSuccessful',$IsSuccessful)
    }  
    if($PSBoundParameters.ContainsKey('User') -eq $true){
        $cmdArgs.Add('User',$User)
    }
    if($PSBoundParameters.ContainsKey('OperationType') -eq $true){
        $cmdArgs.Add('OperationType',$OperationType)
    }

    $ret = Get-LogLowLevelOperation @cmdArgs | Select-Object $Properties
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