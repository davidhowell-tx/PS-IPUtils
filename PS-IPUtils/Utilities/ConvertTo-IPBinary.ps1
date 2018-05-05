function ConvertTo-IPBinary {
    <#
        .SYNOPSIS
            Converts a value to a binary decimal IP address, such as "11111111111111110000000000000000"
        
        .EXAMPLE
            ConvertTo-IPBinary 255.255.0.0
            11111111111111110000000000000000
        
        .EXAMPLE
            ConvertTo-IPBinary 24
            11111111111111111111111100000000
    #>
    [CmdletBinding()]Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [String]
        $InputObject
    )
    $Type = Get-IPValueType -InputObject $InputObject

    $BinaryIP = @()
    
    switch ($Type) {
        "dotted decimal ip" {
            $InputObject.split(".") | ForEach-Object {
                $BinaryIP += $([convert]::toString($_,2).padleft(8,"0"))
            }
            return $BinaryIP -join ""
        }

        "cidr" {
            for ($i = 0; $i -lt $InputObject; $i++) {
                $BinaryIP += "1"
            }

            for ($i = $InputObject; $i -lt 32; $i++) {
                $BinaryIP += "0"
            }
            return $BinaryIP -join ""
        }
        
        default {
            Write-Error -Message "Unable to determine source type" -ErrorAction Stop
        }
    }
}