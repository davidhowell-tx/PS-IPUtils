function Get-IPRange {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName="SingleValue")]
        [String]
        $Value,

        [Parameter(Mandatory=$True,ParameterSetName="DoubleValue")]
        [String]
        $StartIP,

        [Parameter(Mandatory=$True,ParameterSetName="DoubleValue")]
        [String]
        $EndIP
    )
    switch ($PSCmdlet.ParameterSetName) {
        "SingleValue" {
            if ($Value -match "^((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))\s*-\s*((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))$") {
                $FirstIP = $matches[1]
                $SecondIP = $matches[5]
                $IPv4Range = New-Object IPv4Range($FirstIP, $SecondIP)
                return $IPv4Range
            }
        }
        "DoubleValue" {
            $IPv4Range = New-Object IPv4Range($StartIP, $EndIP)
            return $IPv4Range
        }
    }
    
}