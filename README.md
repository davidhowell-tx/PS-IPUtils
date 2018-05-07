# PS-IPUtils
PowerShell Module for Working with IPv4 Addresses and Subnets

README IS IN PROGRESS

The majority of the code for this module is within the classes themselves.

# IP Addresses
Create an IP Address object 
 ```
$IP = Get-IPAddress -Value "192.168.1.50"
```

# Subnets
There are a few ways to create a Subnet object.
```
$Subnet = Get-IPSubnet -Value "192.168.1.1/24"
$Subnet = Get-IPSubnet -Value "192.168.1.1 - 192.168.1.254"
$Subnet = Get-IPSubnet -Value "192.168.1.1" -NetworkBits 24
```

# Check for equality
```
$Subnet1.Is($Subnet2)
$IP1.Is($IP2)
```

# Check for overlapping subnets
```
$Subnet1.Overlaps($Subnet2)
$False
```
