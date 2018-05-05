$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "IPv4Address Class" {
    Describe "IPv4Address([String]`$IPAddress)" {
        Describe "Class Constructor" {
            It "Constructs with a valid IP Address String" {
                New-Object IPv4Address "192.168.1.1"
            }
            It "Does not construct an invalid IP Address String" {
                { New-Object IPv4Address "192.168.1.256" } | Should -Throw "Unable to identify value as an IP Address, i.e. 192.168.0.1"
            }
        }
        
        Describe "Class Methods" {
            Context "ToString()" {
                It "Does not throw an error" {
                    $IP = New-Object IPv4Address "192.168.1.1"
                    $IP.ToString()
                }
                It "Returns appropriate value" {
                    $IP = New-Object IPv4Address "192.168.1.1"
                    $IP.ToString() | Should -Be "192.168.1.1"
                }
            }
        
            Context "InSubnet([Subnet])" {
                It "Does not throw an error" {
                    $IP = New-Object IPv4Address "192.168.1.1"
                    $Subnet = New-Object Subnet "192.168.1.1/24"
                    $IP.InSubnet($Subnet)
                }
                It "Returns True with 192.168.1.1 and 192.168.1.0/24" {
                    $IP = New-Object IPv4Address "192.168.1.1"
                    $Subnet = New-Object Subnet "192.168.1.1/24"
                    $IP.InSubnet($Subnet) | Should -Be $True
                }
                It "Returns False with 192.168.1.1 and 192.168.10.0/24" {
                    $IP = New-Object IPv4Address "192.168.1.1"
                    $Subnet = New-Object Subnet "192.168.10.0/24"
                    $IP.InSubnet($Subnet) | Should -Be $False
                }
            }
        
            Context "Is([IPv4Address])" {
                It "Does not throw an error" {
                    $IP = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.1"
                    $IP.Is($IP2)
                }
                It "Returns True with 192.168.1.1 and 192.168.1.1" {
                    $IP = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.1"
                    $IP.Is($IP2) | Should -Be $True
                }
                It "Returns False with 192.168.1.1 and 192.168.10.1" {
                    $IP = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.10.1"
                    $IP.Is($IP2) | Should -Be $False
                }
            }
        
            Context "Is([String])" {
                It "does not throw an error" {
                    $IP = New-Object IPv4Address "192.168.1.1"
                    $IP.Is("192.168.1.1")
                }
                It "throws an error with an invalid IP Address string" {
                    {
                        $IP = New-Object IPv4Address "192.168.1.1"
                        $IP.Is("192.168.1.256")
                    } | Should -Throw "Unable to identify value as an IP Address, i.e. 192.168.0.1"
                }
                It "Returns True with with the same IP Address" {
                    $IP = New-Object IPv4Address "192.168.1.1"
                    $IP.Is("192.168.1.1") | Should -Be $True
                }
                It "Returns False with with a different IP Address" {
                    $IP = New-Object IPv4Address "192.168.1.1"
                    $IP.Is("192.168.10.1") | Should -Be $False
                }
            }
        }

        Describe "Class Properties" {
            It "Should have the appropriate Address" {
                $IP = New-Object IPv4Address "192.168.1.1"
                $IP.Address | Should -Be "192.168.1.1"
            }
            It "Should have the appropriate Decimal Address" {
                $IP = New-Object IPv4Address "192.168.1.1"
                $IP.DecimalAddress | Should -Be 3232235777
            }
            It "Should have the appropriate Binary Address" {
                $IP = New-Object IPv4Address "192.168.1.1"
                $IP.BinaryAddress | Should -Be "11000000101010000000000100000001"
            }
        }
    }

    Describe "IPv4Address([Int64]`$DecimalAddress)" {
        Describe "Class Constructor" {
            It "Constructs with a valid Int64" {
                [Int64]$Decimal = 3232235777
                New-Object IPv4Address $Decimal
            }
            It "Does not construct an invalid Int64" {
                {
                    [Int64]$Decimal = 4294967296
                    New-Object IPv4Address $Decimal
                } | Should -Throw "Unable to identify value as an IP Address."
            }
        }

        Describe "Class Methods" {
            Context "ToString()" {
                It "Does not throw an error" {
                    [Int64]$Decimal = 3232235777
                    $IP = New-Object IPv4Address $Decimal
                    $IP.ToString()
                }
                It "Returns appropriate value" {
                    [Int64]$Decimal = 3232235777
                    $IP = New-Object IPv4Address $Decimal
                    $IP.ToString() | Should -Be "192.168.1.1"
                }
            }
        
            Context "InSubnet([Subnet])" {
                It "Does not throw an error" {
                    [Int64]$Decimal = 3232235777
                    $IP = New-Object IPv4Address $Decimal
                    $Subnet = New-Object Subnet "192.168.1.1/24"
                    $IP.InSubnet($Subnet)
                }
                It "Returns True with 192.168.1.1 and 192.168.1.0/24" {
                    [Int64]$Decimal = 3232235777
                    $IP = New-Object IPv4Address $Decimal
                    $Subnet = New-Object Subnet "192.168.1.1/24"
                    $IP.InSubnet($Subnet) | Should -Be $True
                }
                It "Returns False with 192.168.1.1 and 192.168.10.0/24" {
                    [Int64]$Decimal = 3232235777
                    $IP = New-Object IPv4Address $Decimal
                    $Subnet = New-Object Subnet "192.168.10.0/24"
                    $IP.InSubnet($Subnet) | Should -Be $False
                }
            }
        
            Context "Is([IPv4Address])" {
                It "Does not throw an error" {
                    [Int64]$Decimal = 3232235777
                    $IP = New-Object IPv4Address $Decimal
                    $IP2 = New-Object IPv4Address $Decimal
                    $IP.Is($IP2)
                }
                It "Returns True with 192.168.1.1 and 192.168.1.1" {
                    [Int64]$Decimal = 3232235777
                    $IP = New-Object IPv4Address $Decimal
                    $IP2 = New-Object IPv4Address $Decimal
                    $IP.Is($IP2) | Should -Be $True
                }
                It "Returns False with 192.168.1.1 and 192.168.10.1" {
                    [Int64]$Decimal = 3232235777
                    [Int64]$Decimal2 = 3232238081
                    $IP = New-Object IPv4Address $Decimal
                    $IP2 = New-Object IPv4Address $Decimal2
                    $IP.Is($IP2) | Should -Be $False
                }
            }
        
            Context "Is([String])" {
                It "does not throw an error" {
                    [Int64]$Decimal = 3232235777
                    $IP = New-Object IPv4Address $Decimal
                    $IP.Is("192.168.1.1")
                }
                It "throws an error with an invalid IP Address string" {
                    {
                        [Int64]$Decimal = 3232235777
                        $IP = New-Object IPv4Address $Decimal
                        $IP.Is("192.168.1.256")
                    } | Should -Throw "Unable to identify value as an IP Address, i.e. 192.168.0.1"
                }
                It "Returns True with with the same IP Address" {
                    [Int64]$Decimal = 3232235777
                    $IP = New-Object IPv4Address $Decimal
                    $IP.Is("192.168.1.1") | Should -Be $True
                }
                It "Returns False with a different IP Address" {
                    [Int64]$Decimal = 3232235777
                    $IP = New-Object IPv4Address $Decimal
                    $IP.Is("192.168.10.1") | Should -Be $False
                }
            }
        }

        Describe "Class Properties" {
            It "Should have the appropriate Address" {
                [Int64]$Decimal = 3232235777
                $IP = New-Object IPv4Address $Decimal
                $IP.Address | Should -Be "192.168.1.1"
            }
            It "Should have the appropriate Decimal Address" {
                [Int64]$Decimal = 3232235777
                $IP = New-Object IPv4Address $Decimal
                $IP.DecimalAddress | Should -Be 3232235777
            }
            It "Should have the appropriate Binary Address" {
                [Int64]$Decimal = 3232235777
                $IP = New-Object IPv4Address $Decimal
                $IP.BinaryAddress | Should -Be "11000000101010000000000100000001"
            }
        }
    }
}

Describe "Subnet Class" {
    Describe "Subnet([String]`$StartIPAddress,[String]`$EndIPAddress)" {
        Describe "Class Constructor" {
            It "Constructs with 192.168.1.1 and 192.168.1.254" {
                New-Object Subnet "192.168.1.1", "192.168.1.254"
            }
            It "Constructs with 192.168.1.1 and 192.168.1.255" {
                New-Object Subnet "192.168.1.1", "192.168.1.255"
            }
            It "Constructs with 192.168.1.0 and 192.168.1.255" {
                New-Object Subnet "192.168.1.0", "192.168.1.255"
            }
            It "Constructs with 192.168.1.0 and 192.168.1.254" {
                New-Object Subnet "192.168.1.0", "192.168.1.254"
            }
            It "Does not construct with an invalid IP Address" {
                {
                    New-Object Subnet "192.168.1.1", "192.168.1.256"
                } | Should -Throw "Unable to identify input values as IP Addresses"
            }
            It "Does not construct with 192.168.1.3 and 192.168.1.254" {
                {
                    New-Object Subnet "192.168.1.3", "192.168.1.254"
                } | Should -Throw "The guessed subnet host range does not align with the supplied address. This must be just a range of IPs and not a subnet's range"
            }
        }

        Describe "Class Methods" {
            Context "[String] ToString()" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet.ToString()
                }
                It "Returns appropriate value" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet.ToString() | Should -Be "192.168.1.0/24"
                }
            }

            Context "[Boolean] Is([Subnet]`$Subnet)" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet2 = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet.Is($Subnet2)
                }
                It "Returns true with the same subnet" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet2 = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet.Is($Subnet2) | Should -Be $True
                }
                It "Returns false with different subnets" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet2 = New-Object Subnet "192.168.2.1", "192.168.2.254"
                    $Subnet.Is($Subnet2) | Should -Be $False
                }
            }

            Context "[Boolean] Contains([IPv4Address]`$IPAddress)" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $IP = New-Object IPv4Address "192.168.1.50"
                    $Subnet.Contains($IP)
                }
                It "Returns true with an IP in the subnet" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $IP = New-Object IPv4Address "192.168.1.50"
                    $Subnet.Contains($IP) | Should -Be $True
                }
                It "Returns false with an IP not in the subnet" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $IP = New-Object IPv4Address "192.168.2.50"
                    $Subnet.Contains($IP) | Should -Be $False
                }
            }

            Context "[Boolean] Contains([String]`$IPAddress)" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet.Contains("192.168.1.50")
                }
                It "Throws an error with an invalid IP Address String" {
                    {
                        $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                        $Subnet.Contains("192.168.1.256")
                    } | Should -Throw "Unable to identify input value as an IP Address"
                }
                It "Returns true with an IP in the subnet" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet.Contains("192.168.1.50") | Should -Be $True
                }
                It "Returns false with an IP not in the subnet" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet.Contains("192.168.2.50") | Should -Be $False
                }
            }

            Context "[Boolean] Overlaps([Subnet]`$Subnet)" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet2 = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet.Overlaps($Subnet2)
                }
                It "Returns true with the same subnet" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet2 = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet.Overlaps($Subnet2) | Should -Be True
                }
                It "Returns true with a smaller subnet" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet2 = New-Object Subnet "192.168.1.1", "192.168.1.126"
                    $Subnet.Overlaps($Subnet2) | Should -Be $True
                }
                It "Returns true with a larger subnet" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet2 = New-Object Subnet "192.168.0.1", "192.168.1.254"
                    $Subnet.Overlaps($Subnet2) | Should -Be $True
                }
                It "Returns false with a different subnet" {
                    $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                    $Subnet2 = New-Object Subnet "192.168.2.1", "192.168.2.254"
                    $Subnet.Overlaps($Subnet2) | Should -Be $False
                }
            }
        }

        Describe "Class Properties" {
            It "Should have the appropriate CIDR Notation" {
                $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                $Subnet.CIDRNotation | Should -Be "192.168.1.0/24"
            }
            It "Should have the appropriate IPRangeStart" {
                $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                $Subnet.IPRangeStart | Should -Be "192.168.1.1"
            }
            It "Should have the appropriate IPRangeEnd" {
                $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                $Subnet.IPRangeEnd | Should -Be "192.168.1.254"
            }
            It "Should have the appropriate SubnetMask" {
                $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                $Subnet.SubnetMask | Should -Be "255.255.255.0"
            }
            It "Should have the appropriate BroadcastAddress" {
                $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                $Subnet.BroadcastAddress | Should -Be "192.168.1.255"
            }
            It "Should have the appropriate NumberOfHosts" {
                $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                $Subnet.NumberOfHosts | Should -Be 254
            }
            It "Should have the appropriate DecimalRangeStart" {
                $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                $Subnet.DecimalRangeStart | Should -Be 3232235777
            }
            It "Should have the appropriate DecimalRangeEnd" {
                $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                $Subnet.DecimalRangeEnd | Should -Be 3232236030
            }
            It "Should have the appropriate BinaryRangeStart" {
                $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                $Subnet.BinaryRangeStart | Should -Be "11000000101010000000000100000001"
            }
            It "Should have the appropriate BinaryRangeEnd" {
                $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                $Subnet.BinaryRangeEnd | Should -Be "11000000101010000000000111111110"
            }
            It "Should have the appropriate NetworkBits" {
                $Subnet = New-Object Subnet "192.168.1.1", "192.168.1.254"
                $Subnet.NetworkBits | Should -Be 24
            }
        }
    }

    Describe "Subnet([IPv4Address]`$StartIPAddress,[IPv4Address]`$EndIPAddress)" {
        Describe "Class Constructor" {
            It "Constructs with 192.168.1.1 and 192.168.1.254" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                New-Object Subnet $IP1, $IP2
            }
            It "Constructs with 192.168.1.1 and 192.168.1.255" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.255"
                New-Object Subnet $IP1, $IP2
            }
            It "Constructs with 192.168.1.0 and 192.168.1.255" {
                $IP1 = New-Object IPv4Address "192.168.1.0"
                $IP2 = New-Object IPv4Address "192.168.1.255"
                New-Object Subnet $IP1, $IP2
            }
            It "Constructs with 192.168.1.0 and 192.168.1.254" {
                $IP1 = New-Object IPv4Address "192.168.1.0"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                New-Object Subnet $IP1, $IP2
            }
            It "Does not construct with 192.168.1.3 and 192.168.1.254" {
                {
                    $IP1 = New-Object IPv4Address "192.168.1.3"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    New-Object Subnet $IP1, $IP2
                } | Should -Throw "The guessed subnet host range does not align with the supplied address. This must be just a range of IPs and not a subnet's range"
            }
        }

        Describe "Class Methods" {
            Context "[String] ToString()" {
                It "Does not throw an error" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $Subnet.ToString()
                }
                It "Returns appropriate value" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $Subnet.ToString() | Should -Be "192.168.1.0/24"
                }
            }

            Context "[Boolean] Is([Subnet]`$Subnet)" {
                It "Does not throw an error" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $Subnet2 = New-Object Subnet $IP1, $IP2
                    $Subnet.Is($Subnet2)
                }
                It "Returns true with the same subnet" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $Subnet2 = New-Object Subnet $IP1, $IP2
                    $Subnet.Is($Subnet2) | Should -Be $True
                }
                It "Returns false with different subnets" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $IP3 = New-Object IPv4Address "192.168.2.1"
                    $IP4 = New-Object IPv4Address "192.168.2.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $Subnet2 = New-Object Subnet $IP3, $IP4
                    $Subnet.Is($Subnet2) | Should -Be $False
                }
            }

            Context "[Boolean] Contains([IPv4Address]`$IPAddress)" {
                It "Does not throw an error" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $IP = New-Object IPv4Address "192.168.1.50"
                    $Subnet.Contains($IP)
                }
                It "Returns true with an IP in the subnet" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $IP = New-Object IPv4Address "192.168.1.50"
                    $Subnet.Contains($IP) | Should -Be $True
                }
                It "Returns false with an IP not in the subnet" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $IP = New-Object IPv4Address "192.168.2.50"
                    $Subnet.Contains($IP) | Should -Be $False
                }
            }

            Context "[Boolean] Contains([String]`$IPAddress)" {
                It "Does not throw an error" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $Subnet.Contains("192.168.1.50")
                }
                It "Throws an error with an invalid IP Address String" {
                    {
                        $IP1 = New-Object IPv4Address "192.168.1.1"
                        $IP2 = New-Object IPv4Address "192.168.1.254"
                        $Subnet = New-Object Subnet $IP1, $IP2
                        $Subnet.Contains("192.168.1.256")
                    } | Should -Throw "Unable to identify input value as an IP Address"
                }
                It "Returns true with an IP in the subnet" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $Subnet.Contains("192.168.1.50") | Should -Be $True
                }
                It "Returns false with an IP not in the subnet" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $Subnet.Contains("192.168.2.50") | Should -Be $False
                }
            }

            Context "[Boolean] Overlaps([Subnet]`$Subnet)" {
                It "Does not throw an error" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $IP3 = New-Object IPv4Address "192.168.1.1"
                    $IP4 = New-Object IPv4Address "192.168.1.254"
                    $Subnet2 = New-Object Subnet $IP3, $IP4
                    $Subnet.Overlaps($Subnet2)
                }
                It "Returns true with the same subnet" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $IP3 = New-Object IPv4Address "192.168.1.1"
                    $IP4 = New-Object IPv4Address "192.168.1.254"
                    $Subnet2 = New-Object Subnet $IP3, $IP4
                    $Subnet.Overlaps($Subnet2) | Should -Be True
                }
                It "Returns true with a smaller subnet" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $IP3 = New-Object IPv4Address "192.168.1.1"
                    $IP4 = New-Object IPv4Address "192.168.1.126"
                    $Subnet2 = New-Object Subnet $IP3, $IP4
                    $Subnet.Overlaps($Subnet2) | Should -Be $True
                }
                It "Returns true with a larger subnet" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $IP3 = New-Object IPv4Address "192.168.0.1"
                    $IP4 = New-Object IPv4Address "192.168.1.254"
                    $Subnet2 = New-Object Subnet $IP3, $IP4
                    $Subnet.Overlaps($Subnet2) | Should -Be $True
                }
                It "Returns false with a different subnet" {
                    $IP1 = New-Object IPv4Address "192.168.1.1"
                    $IP2 = New-Object IPv4Address "192.168.1.254"
                    $Subnet = New-Object Subnet $IP1, $IP2
                    $IP3 = New-Object IPv4Address "192.168.2.1"
                    $IP4 = New-Object IPv4Address "192.168.2.254"
                    $Subnet2 = New-Object Subnet $IP3, $IP4
                    $Subnet.Overlaps($Subnet2) | Should -Be $False
                }
            }
        }

        Describe "Class Properties" {
            It "Should have the appropriate CIDR Notation" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                $Subnet = New-Object Subnet $IP1, $IP2
                $Subnet.CIDRNotation | Should -Be "192.168.1.0/24"
            }
            It "Should have the appropriate IPRangeStart" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                $Subnet = New-Object Subnet $IP1, $IP2
                $Subnet.IPRangeStart | Should -Be "192.168.1.1"
            }
            It "Should have the appropriate IPRangeEnd" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                $Subnet = New-Object Subnet $IP1, $IP2
                $Subnet.IPRangeEnd | Should -Be "192.168.1.254"
            }
            It "Should have the appropriate SubnetMask" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                $Subnet = New-Object Subnet $IP1, $IP2
                $Subnet.SubnetMask | Should -Be "255.255.255.0"
            }
            It "Should have the appropriate BroadcastAddress" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                $Subnet = New-Object Subnet $IP1, $IP2
                $Subnet.BroadcastAddress | Should -Be "192.168.1.255"
            }
            It "Should have the appropriate NumberOfHosts" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                $Subnet = New-Object Subnet $IP1, $IP2
                $Subnet.NumberOfHosts | Should -Be 254
            }
            It "Should have the appropriate DecimalRangeStart" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                $Subnet = New-Object Subnet $IP1, $IP2
                $Subnet.DecimalRangeStart | Should -Be 3232235777
            }
            It "Should have the appropriate DecimalRangeEnd" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                $Subnet = New-Object Subnet $IP1, $IP2
                $Subnet.DecimalRangeEnd | Should -Be 3232236030
            }
            It "Should have the appropriate BinaryRangeStart" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                $Subnet = New-Object Subnet $IP1, $IP2
                $Subnet.BinaryRangeStart | Should -Be "11000000101010000000000100000001"
            }
            It "Should have the appropriate BinaryRangeEnd" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                $Subnet = New-Object Subnet $IP1, $IP2
                $Subnet.BinaryRangeEnd | Should -Be "11000000101010000000000111111110"
            }
            It "Should have the appropriate NetworkBits" {
                $IP1 = New-Object IPv4Address "192.168.1.1"
                $IP2 = New-Object IPv4Address "192.168.1.254"
                $Subnet = New-Object Subnet $IP1, $IP2
                $Subnet.NetworkBits | Should -Be 24
            }
        }
    }

    Describe "Subnet([String]`$CIDRNotation)" {
        Describe "Class Constructor" {
            It "Constructs with 192.168.1.0/24" {
                New-Object Subnet "192.168.1.0/24"
            }
            It "Does not construct with 192.168.256.0/24" {
                { New-Object Subnet "192.168.256.0/24" } | Should -Throw "Unable to identify value as CIDR Notation IP, i.e. 192.168.0.0/24"
            }
            It "Does not construct with 192.168.1.0/33" {
                { New-Object Subnet "192.168.1.0/33" } | Should -Throw "Unable to identify value as CIDR Notation IP, i.e. 192.168.0.0/24"
            }
        }

        Describe "Class Methods" {
            Context "[String] ToString()" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet.ToString()
                }
                It "Returns appropriate value" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet.ToString() | Should -Be "192.168.1.0/24"
                }
            }

            Context "[Boolean] Is([Subnet]`$Subnet)" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet2 = New-Object Subnet "192.168.1.0/24"
                    $Subnet.Is($Subnet2)
                }
                It "Returns true with the same subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet2 = New-Object Subnet "192.168.1.0/24"
                    $Subnet.Is($Subnet2) | Should -Be $True
                }
                It "Returns false with different subnets" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet2 = New-Object Subnet "192.168.2.0/24"
                    $Subnet.Is($Subnet2) | Should -Be $False
                }
            }

            Context "[Boolean] Contains([IPv4Address]`$IPAddress)" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $IP = New-Object IPv4Address "192.168.1.50"
                    $Subnet.Contains($IP)
                }
                It "Returns true with an IP in the subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $IP = New-Object IPv4Address "192.168.1.50"
                    $Subnet.Contains($IP) | Should -Be $True
                }
                It "Returns false with an IP not in the subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $IP = New-Object IPv4Address "192.168.2.50"
                    $Subnet.Contains($IP) | Should -Be $False
                }
            }

            Context "[Boolean] Contains([String]`$IPAddress)" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet.Contains("192.168.1.50")
                }
                It "Throws an error with an invalid IP Address String" {
                    {
                        $Subnet = New-Object Subnet "192.168.1.0/24"
                        $Subnet.Contains("192.168.1.256")
                    } | Should -Throw "Unable to identify input value as an IP Address"
                }
                It "Returns true with an IP in the subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet.Contains("192.168.1.50") | Should -Be $True
                }
                It "Returns false with an IP not in the subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet.Contains("192.168.2.50") | Should -Be $False
                }
            }

            Context "[Boolean] Overlaps([Subnet]`$Subnet)" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet2 = New-Object Subnet "192.168.1.0/24"
                    $Subnet.Overlaps($Subnet2)
                }
                It "Returns true with the same subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet2 = New-Object Subnet "192.168.1.0/24"
                    $Subnet.Overlaps($Subnet2) | Should -Be True
                }
                It "Returns true with a smaller subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet2 = New-Object Subnet "192.168.1.0/25"
                    $Subnet.Overlaps($Subnet2) | Should -Be $True
                }
                It "Returns true with a larger subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet2 = New-Object Subnet "192.168.0.0/23"
                    $Subnet.Overlaps($Subnet2) | Should -Be $True
                }
                It "Returns false with a different subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0/24"
                    $Subnet2 = New-Object Subnet "192.168.2.0/24"
                    $Subnet.Overlaps($Subnet2) | Should -Be $False
                }
            }
        }

        Describe "Class Properties" {
            It "Should have the appropriate CIDR Notation" {
                $Subnet = New-Object Subnet "192.168.1.0/24"
                $Subnet.CIDRNotation | Should -Be "192.168.1.0/24"
            }
            It "Should have the appropriate IPRangeStart" {
                $Subnet = New-Object Subnet "192.168.1.0/24"
                $Subnet.IPRangeStart | Should -Be "192.168.1.1"
            }
            It "Should have the appropriate IPRangeEnd" {
                $Subnet = New-Object Subnet "192.168.1.0/24"
                $Subnet.IPRangeEnd | Should -Be "192.168.1.254"
            }
            It "Should have the appropriate SubnetMask" {
                $Subnet = New-Object Subnet "192.168.1.0/24"
                $Subnet.SubnetMask | Should -Be "255.255.255.0"
            }
            It "Should have the appropriate BroadcastAddress" {
                $Subnet = New-Object Subnet "192.168.1.0/24"
                $Subnet.BroadcastAddress | Should -Be "192.168.1.255"
            }
            It "Should have the appropriate NumberOfHosts" {
                $Subnet = New-Object Subnet "192.168.1.0/24"
                $Subnet.NumberOfHosts | Should -Be 254
            }
            It "Should have the appropriate DecimalRangeStart" {
                $Subnet = New-Object Subnet "192.168.1.0/24"
                $Subnet.DecimalRangeStart | Should -Be 3232235777
            }
            It "Should have the appropriate DecimalRangeEnd" {
                $Subnet = New-Object Subnet "192.168.1.0/24"
                $Subnet.DecimalRangeEnd | Should -Be 3232236030
            }
            It "Should have the appropriate BinaryRangeStart" {
                $Subnet = New-Object Subnet "192.168.1.0/24"
                $Subnet.BinaryRangeStart | Should -Be "11000000101010000000000100000001"
            }
            It "Should have the appropriate BinaryRangeEnd" {
                $Subnet = New-Object Subnet "192.168.1.0/24"
                $Subnet.BinaryRangeEnd | Should -Be "11000000101010000000000111111110"
            }
            It "Should have the appropriate NetworkBits" {
                $Subnet = New-Object Subnet "192.168.1.0/24"
                $Subnet.NetworkBits | Should -Be 24
            }
        }
    }

    Describe "Subnet([String]`$IPAddress, [Int32]`$NetworkBits)" {
        Describe "Class Constructor" {
            It "Constructs with 192.168.1.0, 24" {
                New-Object Subnet "192.168.1.0", 24
            }
            It "Does not construct with 192.168.256.0, 24" {
                { New-Object Subnet "192.168.256.0", 24 } | Should -Throw "Unable to identify input value as an IP Address"
            }
            It "Does not construct with 192.168.1.0, 33" {
                { New-Object Subnet "192.168.1.0", 33 } | Should -Throw "NetworkBits value must be between 0 and 32."
            }
        }

        Describe "Class Methods" {
            Context "[String] ToString()" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet.ToString()
                }
                It "Returns appropriate value" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet.ToString() | Should -Be "192.168.1.0/24"
                }
            }

            Context "[Boolean] Is([Subnet]`$Subnet)" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet2 = New-Object Subnet "192.168.1.0", 24
                    $Subnet.Is($Subnet2)
                }
                It "Returns true with the same subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet2 = New-Object Subnet "192.168.1.0", 24
                    $Subnet.Is($Subnet2) | Should -Be $True
                }
                It "Returns false with different subnets" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet2 = New-Object Subnet "192.168.2.0", 24
                    $Subnet.Is($Subnet2) | Should -Be $False
                }
            }

            Context "[Boolean] Contains([IPv4Address]`$IPAddress)" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $IP = New-Object IPv4Address "192.168.1.50"
                    $Subnet.Contains($IP)
                }
                It "Returns true with an IP in the subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $IP = New-Object IPv4Address "192.168.1.50"
                    $Subnet.Contains($IP) | Should -Be $True
                }
                It "Returns false with an IP not in the subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $IP = New-Object IPv4Address "192.168.2.50"
                    $Subnet.Contains($IP) | Should -Be $False
                }
            }

            Context "[Boolean] Contains([String]`$IPAddress)" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet.Contains("192.168.1.50")
                }
                It "Throws an error with an invalid IP Address String" {
                    {
                        $Subnet = New-Object Subnet "192.168.1.0", 24
                        $Subnet.Contains("192.168.1.256")
                    } | Should -Throw "Unable to identify input value as an IP Address"
                }
                It "Returns true with an IP in the subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet.Contains("192.168.1.50") | Should -Be $True
                }
                It "Returns false with an IP not in the subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet.Contains("192.168.2.50") | Should -Be $False
                }
            }

            Context "[Boolean] Overlaps([Subnet]`$Subnet)" {
                It "Does not throw an error" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet2 = New-Object Subnet "192.168.1.0", 24
                    $Subnet.Overlaps($Subnet2)
                }
                It "Returns true with the same subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet2 = New-Object Subnet "192.168.1.0", 24
                    $Subnet.Overlaps($Subnet2) | Should -Be True
                }
                It "Returns true with a smaller subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet2 = New-Object Subnet "192.168.1.0", 25
                    $Subnet.Overlaps($Subnet2) | Should -Be $True
                }
                It "Returns true with a larger subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet2 = New-Object Subnet "192.168.0.0", 23
                    $Subnet.Overlaps($Subnet2) | Should -Be $True
                }
                It "Returns false with a different subnet" {
                    $Subnet = New-Object Subnet "192.168.1.0", 24
                    $Subnet2 = New-Object Subnet "192.168.2.0", 24
                    $Subnet.Overlaps($Subnet2) | Should -Be $False
                }
            }
        }

        Describe "Class Properties" {
            It "Should have the appropriate CIDR Notation" {
                $Subnet = New-Object Subnet "192.168.1.0", 24
                $Subnet.CIDRNotation | Should -Be "192.168.1.0/24"
            }
            It "Should have the appropriate IPRangeStart" {
                $Subnet = New-Object Subnet "192.168.1.0", 24
                $Subnet.IPRangeStart | Should -Be "192.168.1.1"
            }
            It "Should have the appropriate IPRangeEnd" {
                $Subnet = New-Object Subnet "192.168.1.0", 24
                $Subnet.IPRangeEnd | Should -Be "192.168.1.254"
            }
            It "Should have the appropriate SubnetMask" {
                $Subnet = New-Object Subnet "192.168.1.0", 24
                $Subnet.SubnetMask | Should -Be "255.255.255.0"
            }
            It "Should have the appropriate BroadcastAddress" {
                $Subnet = New-Object Subnet "192.168.1.0", 24
                $Subnet.BroadcastAddress | Should -Be "192.168.1.255"
            }
            It "Should have the appropriate NumberOfHosts" {
                $Subnet = New-Object Subnet "192.168.1.0", 24
                $Subnet.NumberOfHosts | Should -Be 254
            }
            It "Should have the appropriate DecimalRangeStart" {
                $Subnet = New-Object Subnet "192.168.1.0", 24
                $Subnet.DecimalRangeStart | Should -Be 3232235777
            }
            It "Should have the appropriate DecimalRangeEnd" {
                $Subnet = New-Object Subnet "192.168.1.0", 24
                $Subnet.DecimalRangeEnd | Should -Be 3232236030
            }
            It "Should have the appropriate BinaryRangeStart" {
                $Subnet = New-Object Subnet "192.168.1.0", 24
                $Subnet.BinaryRangeStart | Should -Be "11000000101010000000000100000001"
            }
            It "Should have the appropriate BinaryRangeEnd" {
                $Subnet = New-Object Subnet "192.168.1.0", 24
                $Subnet.BinaryRangeEnd | Should -Be "11000000101010000000000111111110"
            }
            It "Should have the appropriate NetworkBits" {
                $Subnet = New-Object Subnet "192.168.1.0", 24
                $Subnet.NetworkBits | Should -Be 24
            }
        }
    }

    Describe "Subnet([IPv4Address]`$IPAddress, [Int32]`$NetworkBits)" {
        Describe "Class Constructor" {
            It "Constructs with 192.168.1.0, 24" {
                [IPv4Address]$IP = "192.168.1.0"
                New-Object Subnet ($IP, 24)
            }
            It "Does not construct with 192.168.256.0, 24" {
                {
                    [IPv4Address]$IP = "192.168.256.0"
                    New-Object Subnet ($IP, 24)
                } | Should -Throw "Unable to identify value as an IP Address, i.e. 192.168.0.1"
            }
            It "Does not construct with 192.168.1.0, 33" {
                {
                    [IPv4Address]$IP = "192.168.1.0"
                    New-Object Subnet ($IP, 33)
                } | Should -Throw "NetworkBits value must be between 0 and 32."
            }
        }

        Describe "Class Methods" {
            Context "[String] ToString()" {
                It "Does not throw an error" {
                    [IPv4Address]$IP = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP, 24
                    $Subnet.ToString()
                }
                It "Returns appropriate value" {
                    [IPv4Address]$IP = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP, 24
                    $Subnet.ToString() | Should -Be "192.168.1.0/24"
                }
            }

            Context "[Boolean] Is([Subnet]`$Subnet)" {
                It "Does not throw an error" {
                    [IPv4Address]$IP = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP, 24
                    $Subnet2 = New-Object Subnet $IP, 24
                    $Subnet.Is($Subnet2)
                }
                It "Returns true with the same subnet" {
                    [IPv4Address]$IP = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP, 24
                    $Subnet2 = New-Object Subnet $IP, 24
                    $Subnet.Is($Subnet2) | Should -Be $True
                }
                It "Returns false with different subnets" {
                    [IPv4Address]$IP = "192.168.1.0"
                    [IPv4Address]$IP2 = "192.168.2.0"
                    $Subnet = New-Object Subnet $IP, 24
                    $Subnet2 = New-Object Subnet $IP2, 24
                    $Subnet.Is($Subnet2) | Should -Be $False
                }
            }

            Context "[Boolean] Contains([IPv4Address]`$IPAddress)" {
                It "Does not throw an error" {
                    [IPv4Address]$IP1 = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP1, 24
                    $IP = New-Object IPv4Address "192.168.1.50"
                    $Subnet.Contains($IP)
                }
                It "Returns true with an IP in the subnet" {
                    [IPv4Address]$IP1 = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP1, 24
                    $IP = New-Object IPv4Address "192.168.1.50"
                    $Subnet.Contains($IP) | Should -Be $True
                }
                It "Returns false with an IP not in the subnet" {
                    [IPv4Address]$IP1 = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP1, 24
                    $IP = New-Object IPv4Address "192.168.2.50"
                    $Subnet.Contains($IP) | Should -Be $False
                }
            }

            Context "[Boolean] Contains([String]`$IPAddress)" {
                It "Does not throw an error" {
                    [IPv4Address]$IP = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP, 24
                    $Subnet.Contains("192.168.1.50")
                }
                It "Throws an error with an invalid IP Address String" {
                    {
                        [IPv4Address]$IP = "192.168.1.0"
                        $Subnet = New-Object Subnet $IP, 24
                        $Subnet.Contains("192.168.1.256")
                    } | Should -Throw "Unable to identify input value as an IP Address"
                }
                It "Returns true with an IP in the subnet" {
                    [IPv4Address]$IP = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP, 24
                    $Subnet.Contains("192.168.1.50") | Should -Be $True
                }
                It "Returns false with an IP not in the subnet" {
                    [IPv4Address]$IP = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP, 24
                    $Subnet.Contains("192.168.2.50") | Should -Be $False
                }
            }

            Context "[Boolean] Overlaps([Subnet]`$Subnet)" {
                It "Does not throw an error" {
                    [IPv4Address]$IP1 = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP1, 24
                    [IPv4Address]$IP2 = "192.168.1.0"
                    $Subnet2 = New-Object Subnet $IP2, 24
                    $Subnet.Overlaps($Subnet2)
                }
                It "Returns true with the same subnet" {
                    [IPv4Address]$IP1 = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP1, 24
                    [IPv4Address]$IP2 = "192.168.1.0"
                    $Subnet2 = New-Object Subnet $IP2, 24
                    $Subnet.Overlaps($Subnet2) | Should -Be True
                }
                It "Returns true with a smaller subnet" {
                    [IPv4Address]$IP1 = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP1, 24
                    [IPv4Address]$IP2 = "192.168.1.0"
                    $Subnet2 = New-Object Subnet $IP2, 25
                    $Subnet.Overlaps($Subnet2) | Should -Be $True
                }
                It "Returns true with a larger subnet" {
                    [IPv4Address]$IP1 = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP1, 24
                    [IPv4Address]$IP2 = "192.168.0.0"
                    $Subnet2 = New-Object Subnet $IP2, 23
                    $Subnet.Overlaps($Subnet2) | Should -Be $True
                }
                It "Returns false with a different subnet" {
                    [IPv4Address]$IP1 = "192.168.1.0"
                    $Subnet = New-Object Subnet $IP1, 24
                    [IPv4Address]$IP2 = "192.168.2.0"
                    $Subnet2 = New-Object Subnet $IP2, 24
                    $Subnet.Overlaps($Subnet2) | Should -Be $False
                }
            }
        }

        Describe "Class Properties" {
            It "Should have the appropriate CIDR Notation" {
                [IPv4Address]$IP = "192.168.1.0"
                $Subnet = New-Object Subnet $IP, 24
                $Subnet.CIDRNotation | Should -Be "192.168.1.0/24"
            }
            It "Should have the appropriate IPRangeStart" {
                [IPv4Address]$IP = "192.168.1.0"
                $Subnet = New-Object Subnet $IP, 24
                $Subnet.IPRangeStart | Should -Be "192.168.1.1"
            }
            It "Should have the appropriate IPRangeEnd" {
                [IPv4Address]$IP = "192.168.1.0"
                $Subnet = New-Object Subnet $IP, 24
                $Subnet.IPRangeEnd | Should -Be "192.168.1.254"
            }
            It "Should have the appropriate SubnetMask" {
                [IPv4Address]$IP = "192.168.1.0"
                $Subnet = New-Object Subnet $IP, 24
                $Subnet.SubnetMask | Should -Be "255.255.255.0"
            }
            It "Should have the appropriate BroadcastAddress" {
                [IPv4Address]$IP = "192.168.1.0"
                $Subnet = New-Object Subnet $IP, 24
                $Subnet.BroadcastAddress | Should -Be "192.168.1.255"
            }
            It "Should have the appropriate NumberOfHosts" {
                [IPv4Address]$IP = "192.168.1.0"
                $Subnet = New-Object Subnet $IP, 24
                $Subnet.NumberOfHosts | Should -Be 254
            }
            It "Should have the appropriate DecimalRangeStart" {
                [IPv4Address]$IP = "192.168.1.0"
                $Subnet = New-Object Subnet $IP, 24
                $Subnet.DecimalRangeStart | Should -Be 3232235777
            }
            It "Should have the appropriate DecimalRangeEnd" {
                [IPv4Address]$IP = "192.168.1.0"
                $Subnet = New-Object Subnet $IP, 24
                $Subnet.DecimalRangeEnd | Should -Be 3232236030
            }
            It "Should have the appropriate BinaryRangeStart" {
                [IPv4Address]$IP = "192.168.1.0"
                $Subnet = New-Object Subnet $IP, 24
                $Subnet.BinaryRangeStart | Should -Be "11000000101010000000000100000001"
            }
            It "Should have the appropriate BinaryRangeEnd" {
                [IPv4Address]$IP = "192.168.1.0"
                $Subnet = New-Object Subnet $IP, 24
                $Subnet.BinaryRangeEnd | Should -Be "11000000101010000000000111111110"
            }
            It "Should have the appropriate NetworkBits" {
                [IPv4Address]$IP = "192.168.1.0"
                $Subnet = New-Object Subnet $IP, 24
                $Subnet.NetworkBits | Should -Be 24
            }
        }
    }
}