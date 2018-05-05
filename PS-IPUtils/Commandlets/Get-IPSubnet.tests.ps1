$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

$parent = Split-Path $here -Parent
. "$parent\Classes\Classes.ps1"

Describe "Get-IPSubnet" {
    Context "CIDR Notation" {
        It "Should not throw an error" {
            Get-IPSubnet -Value "192.168.1.1/24"
        }
        It "Should return the correct subnet" {
            $Subnet = Get-IPSubnet -Value "192.168.1.1/24"
            $Subnet.CIDRNotation | Should -Be "192.168.1.0/24"
        }
    }

    Context "IP Range" {
        It "Should not throw an error" {
            Get-IPSubnet -Value "192.168.1.1 - 192.168.1.254"
        }
        It "Should return the correct subnet" {
            $Subnet = Get-IPSubnet -Value "192.168.1.1 - 192.168.1.254"
            $Subnet.CIDRNotation | Should -Be "192.168.1.0/24"
        }
    }
    
    Context "IP and Network Bits" {
        It "Should not throw an error with a proper IP and Network Bits" {
            Get-IPSubnet -Value "192.168.1.1" -NetworkBits 24
        }
        It "Should return the correct subnet" {
            $Subnet = Get-IPSubnet -Value "192.168.1.1" -NetworkBits 24
            $Subnet.CIDRNotation | Should -Be "192.168.1.0/24"
        }
    }

    Context "Invalid input" {
        It "Should throw an error" {
            { Get-IPSubnet -Value "192.168.1.256" } | Should -Throw "Supplied value does not match an IP range, CIDR Notation, or a valid IP Address"
        }
    }
}