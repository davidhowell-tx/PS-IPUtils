function Get-IPValueType {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [String]$InputObject
    )

    switch -Regex ($InputObject) {
        "^(0|1){32}$" {
            return "binary ip"
        }

        "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$" {
            return "dotted decimal ip"
        }

        "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])/([1-9]|[1-2][0-9]|3[0-2])$" {
            return "ip cidr"
        }
        "^([1-2]?[0-9]|3[0-2])$" {
            return "cidr"
        }
        default {
            Write-Error -Message "Unable to determine value type"
        }

    }
}