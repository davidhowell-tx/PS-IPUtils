function Test-IPSubnetMask {
    [CmdletBinding()]Param(
        [Parameter(Mandatory=$True)]
        [ValidatePattern("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$")]
        $InputObject
    )
    $BinaryNetMask = ConvertTo-IPBinary $InputObject
    if ($BinaryNetMask -match "^1{0,32}0{0,32}$" -and $BinaryNetMask -match "(1|0){0,32}") {
        return $True
    }
    return $False
}