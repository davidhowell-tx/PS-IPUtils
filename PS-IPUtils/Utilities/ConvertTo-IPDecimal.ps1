function ConvertTo-IPDecimal {
    <#
        .SYNOPSIS
            Converts a value to a dotted decimal IP address, such as "192.168.0.1"
        
        .EXAMPLE
            ConvertTo-IPDecimal 11111111111111110000000000000000
            255.255.0.0
        
        .EXAMPLE
            ConvertTo-IPDecimal 24
            255.255.255.0
    #>
    [CmdletBinding()]Param(
        [Parameter(Mandatory=$True)]
        [String]$InputObject
    )
    $Type = Get-IPValueType $InputObject
    
    $DecimalValues = @()
    
    switch ($Type) {
        "binary ip" {
            for ($i = 0; $i -lt 4; $i++) {
                $DecimalValues += [Convert]::ToInt32($InputObject.Substring($i*8,8),2)
            }
            return $DecimalValues -join "."
        }

        "cidr" {
            # CIDR Prefix can be 0-32
            # This number represents the number of bits assigned to the subnet mask
            # Break this down into 4 values of 0-8, then convert to a decimal number
            
            # Cast to an integer value so we can math
            [int]$CIDR = $InputObject
            for ($i = 0; $i -lt 4; $i++) {
                if ($CIDR -ge 8) {
                    $DecimalValues += 255
                    $CIDR = $CIDR - 8
                } elseif ($CIDR -eq 0) {
                    $DecimalValues += 0
                } else {
                    $TempValue = 0
                    for ($j = 0; $j -lt 8 - $CIDR; $j++) {
                        $TempValue = $TempValue + [Math]::Pow(2, $j)
                    }
                    $DecimalValues += 255 - $TempValue
                    $CIDR = $CIDR - $CIDR
                }
            }
            return $DecimalValues -join "."
        }
        
        default {
            Write-Error -Message "Unable to determine source type" -ErrorAction Stop
        }
    }
}