function Get-IPAddress {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [String]
        $Value
    )
    if ($Value -match "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$") {
        $IP = New-Object IPv4Address($Value)
    } elseif ([Int64]$Value -le 4294967295 -and [Int64]$Value -ge 0) {
        $IP = New-Object IPv4Address([Int64]$Value)
    } else {
        Write-Error -ErrorAction Stop -Message "Please provide a valid IP Address in decimal or dotted decimal, ie. 192.168.1.1 or 4294967295"
    }
    return $IP
}