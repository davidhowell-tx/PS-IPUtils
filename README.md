# PS-IPUtils
This module was born out of necessity to:
..* Check IP Addresses or Subnets for equality
..* Check for overlapping subnets
..* Check if an IP Address is in a subnet

I also took this as an opportunity to play with PowerShell classes, therefore the majority of the code for this module is within the classes themselves.

# Create an IP Address object
```
PS > Get-IPAddress "192.168.1.50"

Address      DecimalAddress
-------      --------------
192.168.1.50     3232235826
```

# Create a Subnet object
```
PS > Get-IPSubnet "192.168.1.0/24"

CIDRNotation     : 192.168.1.0/24
IPRangeStart     : 192.168.1.1
IPRangeEnd       : 192.168.1.254
SubnetMask       : 255.255.255.0
BroadcastAddress : 192.168.1.255
NumberOfHosts    : 254
```

There are a few ways to create a Subnet object.
```
$Subnet = Get-IPSubnet -Value "192.168.1.1/24"
$Subnet = Get-IPSubnet -Value "192.168.1.1 - 192.168.1.254"
$Subnet = Get-IPSubnet -Value "192.168.1.1" -NetworkBits 24
```

# Check IP Addresses for equality
```
PS > $IP = Get-IPAddress "192.168.1.50"
PS > $IP2 = Get-IPAddress "192.168.1.50"
PS > $IP -eq $IP2
False
PS > $IP.Is($IP2)
True
```

# Check Subnets for equality
```
PS > $Subnet = Get-IPSubnet "192.168.1.50/24"
PS > $Subnet2 = Get-IPSubnet "192.168.1.1 - 192.168.1.254"
PS > $Subnet -eq $Subnet2
False
PS > $Subnet.Is($Subnet2)
True
```

# Check subnets for overlap
```
PS > $Subnet = Get-IPSubnet "192.168.1.50/24"
PS > $Subnet2 = Get-IPSubnet "192.168.0.50/23"
PS > $Subnet.Overlaps($Subnet2)
True
```

# Check if IP Address is within a subnet
```
PS > $IP = Get-IPAddress "192.168.1.50"
PS > $Subnet = Get-IPSubnet "192.168.1.50/24"
PS > $IP.InSubnet($Subnet)
True
```