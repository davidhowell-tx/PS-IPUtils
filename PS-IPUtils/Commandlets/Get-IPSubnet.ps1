function Get-IPSubnet {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [String]
        $Value
    )

    DynamicParam {
        if ($Value -match "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$") {
            $AttributeCollection = New-Object 'System.Collections.ObjectModel.Collection[System.Attribute]'
            $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
            $ParameterAttribute.Mandatory = $True
            $AttributeCollection.Add($ParameterAttribute)
            $ValidateAttribute = New-Object System.Management.Automation.ValidateRangeAttribute(0, 32)
            $AttributeCollection.Add($ValidateAttribute)
            $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter("NetworkBits", [Int32], $AttributeCollection)
            $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $RuntimeParameterDictionary.Add("NetworkBits", $RuntimeParameter)
            return $RuntimeParameterDictionary
        }
    }

    Begin {
        $PSBoundParameters.GetEnumerator() | ForEach-Object { New-Variable -Name $_.Key -Value $_.Value -ErrorAction SilentlyContinue }
    }
    Process {
        if ($NetworkBits) {
            $Subnet = New-Object Subnet($Value, $NetworkBits)
            return $Subnet
        }
        if ($Value -match "^((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))\s*-\s*((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))$") {
            # IP Range
            $FirstIP = $matches[1]
            $SecondIP = $matches[5]
            $Subnet = New-Object Subnet($FirstIP, $SecondIP)
            return $Subnet
        } elseif ($Value -match "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])([\\/]([0-9]|[1-2][0-9]|3[2])?)?$") {
            # CIDR Notation
            $Subnet = New-Object Subnet($Value)
            return $Subnet
        } else {
            Write-Error -ErrorAction Stop -Message "Supplied value does not match an IP range, CIDR Notation, or a valid IP Address"
        }
    }
}