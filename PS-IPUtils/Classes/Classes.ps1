class IPv4Address {
    # Properties
    [String]$Address
    [UInt32]$DecimalAddress

    # Hidden Properties
    hidden [String]$BinaryAddress

    # Constructors
    # PS > New-Object IPv4Address ("192.168.1.1")
    IPv4Address([String]$IPAddress) {
        if ($IPAddress -notmatch "^((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))$") {
            Write-Error -ErrorAction Stop -Message "Unable to identify value as an IP Address, i.e. 192.168.0.1"
        }
        $this.Address = $matches[1]
    
        $BinaryIPArray = @()
        $matches[1].split(".") | ForEach-Object {
            $BinaryIPArray += $([Convert]::toString($_,2).padleft(8,"0"))
        }
        $BinaryIP = $BinaryIPArray -join ""
        $this.BinaryAddress = $BinaryIP
        $this.DecimalAddress = [Convert]::ToUInt32($BinaryIP,2)
    }

    # PS > New-Object IPv4Address (3232235777)
    IPv4Address([Int64]$DecimalAddress){
        #Validate Input
        if ($DecimalAddress -lt 0 -or $DecimalAddress -gt 4294967295) {
            Write-Error -ErrorAction Stop -Message "Unable to identify value as an IP Address."
        }
        $BinaryIPAddress = [Convert]::ToString([UInt32]$DecimalAddress,2)
        $this.DecimalAddress = $DecimalAddress
        $this.BinaryAddress = $BinaryIPAddress
        
        # Convert Binary Address to Dotted Decimal
        $IPAddress = @()
        for ($i = 0; $i -lt 4; $i++) {
            $IPAddress += [Convert]::ToInt32($BinaryIPAddress.Substring($i*8,8),2)
        }

        $this.Address = $IPAddress -join "."
    }

    # Methods
    [String] ToString() {
        return $this.Address
    }

    [Boolean] InSubnet($Subnet) {
        Write-Verbose "Determining if $this is located within $Subnet"
        if ($this.DecimalAddress -ge $Subnet.DecimalRangeStart -and $this.DecimalAddress -le $Subnet.DecimalRangeEnd) {
            return $True
        }
        return $False
    }

    [Boolean] Is([IPv4Address]$IPAddress) {
        Write-Verbose "Determining if IP address $this and $IPAddress are the same"
        if ($this.Address -eq $IPAddress.Address) {
            return $True
        }
        return $False
    }

    [Boolean] Is([String]$IPAddress) {
        # Valid Input
        if ($IPAddress -notmatch "^((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))$") {
            Write-Error -ErrorAction Stop -Message "Unable to identify value as an IP Address, i.e. 192.168.0.1"
        }

        [IPv4Address]$IP = $IPAddress

        Write-Verbose "Determining if IP address $this and $IP are the same"
        if ($this.Address -eq $IP.Address) {
            return $True
        }
        return $False
    }
}

class Subnet {
    # Properties
    [String]$CIDRNotation
    [IPv4Address]$IPRangeStart
    [IPv4Address]$IPRangeEnd
    [IPv4Address]$SubnetMask
    [IPv4Address]$BroadcastAddress
    [Uint32]$NumberOfHosts

    # Hidden Properties
    hidden [UInt32]$DecimalRangeStart
    hidden [UInt32]$DecimalRangeEnd
    hidden [String]$BinaryRangeStart
    hidden [String]$BinaryRangeEnd
    hidden [UInt16]$NetworkBits
    
    # Constructors
    # PS > New-Object Subnet ("192.168.1.1", "192.168.1.254")
    Subnet([String]$StartIPAddress,[String]$EndIPAddress) {
        # Validate the input IP Addresses before proceeding
        if ($StartIPAddress -notmatch "^((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))?$" `
         -or $EndIPAddress -notmatch "^((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))?$") {
            Write-Error -ErrorAction Stop -Message "Unable to identify input values as IP Addresses"
        }
        [IPv4Address]$StartIP = $StartIPAddress
        [IPv4Address]$EndIP = $EndIPAddress

        $RangeDifference = $EndIP.DecimalAddress - $StartIP.DecimalAddress + 1
        Write-Verbose -Message "Supplied IPv4 Range contains $RangeDifference hosts."

        # Make a guess on the CIDR Suffix
        $GuessHostBits = [Math]::Round([Math]::Log($RangeDifference,2))
        $CIDR = 32 - $GuessHostBits
        Write-Verbose -Message "Guessing a subnet with $RangeDifference hosts has a CIDR Suffix of $CIDR"

        # Convert IP to Binary Addresses using CIDR mask
        $BinaryPrefix = $StartIP.BinaryAddress.Substring(0,$CIDR).padright(32,"0")
        $BinaryIPRangeStart = $StartIP.BinaryAddress.Substring(0,$CIDR).padright(31,"0") + "1"
        $BinaryIPRangeEnd = $StartIP.BinaryAddress.Substring(0,$CIDR).padright(31,"1") + "0"
        $BinarySubnetMask = "".PadLeft($CIDR,"1") + "".PadRight(32-$CIDR,"0")
        $BinaryBroadcastAddress = $StartIP.BinaryAddress.Substring(0,$CIDR).padright(32,"1")

        # Verify the provided range starts with one of the first 2 addresses and ends on one of the last 2 address
        # Sometimes the same range is shown as 192.168.1.0 - 192.168.1.255, or 192.168.1.1 - 192.168.1.254
        $DecimalStart = [Convert]::ToUInt32($BinaryIPRangeStart,2)
        $DecimalEnd = [Convert]::ToUInt32($BinaryIPRangeEnd,2)

        if ( ($StartIP.DecimalAddress -ne $DecimalStart -and $StartIP.DecimalAddress -ne ($DecimalStart - 1)) `
        -or ($EndIP.DecimalAddress -ne $DecimalEnd -and $EndIP.DecimalAddress -ne ($DecimalEnd + 1)) ) {
            Write-Error -ErrorAction Stop -Message "The guessed subnet host range does not align with the supplied address. This must be just a range of IPs and not a subnet's range"
        }

        # Convert Binary IPs to Dotted Decimal IPs
        $PrefixArray = @()
        $RangeStartArray = @()
        $RangeEndArray = @()
        $SubnetMaskArray = @()
        $BroadcastArray = @()
        for ($i = 0; $i -lt 4; $i++) {
            $PrefixArray += [Convert]::ToInt32($BinaryPrefix.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $RangeStartArray += [Convert]::ToInt32($BinaryIPRangeStart.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $RangeEndArray += [Convert]::ToInt32($BinaryIPRangeEnd.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $SubnetMaskArray += [Convert]::ToInt32($BinarySubnetMask.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $BroadcastArray += [Convert]::ToInt32($BinaryBroadcastAddress.Substring($i*8,8),2)
        }
        $this.IPRangeStart = $RangeStartArray -join "."
        $this.IPRangeEnd = $RangeEndArray -join "."
        $this.SubnetMask = $SubnetMaskArray -join "."
        $this.BroadcastAddress = $BroadcastArray -join "."
        $this.NumberOfHosts = [Math]::Pow(2,32-$CIDR) - 2
        $this.CIDRNotation = ($PrefixArray -join ".") + "/$CIDR"
        $this.DecimalRangeStart = $DecimalStart
        $this.DecimalRangeEnd = $DecimalEnd
        $this.BinaryRangeStart = $BinaryIPRangeStart
        $this.BinaryRangeEnd = $BinaryIPRangeEnd
        $this.NetworkBits = $CIDR
    }

    # PS > $Start = New-Object IPv4Address ("192.168.1.1")
    # PS > $End = New-Object IPv4Address ("192.168.1.254")
    # PS > New-Object Subnet ($Start, $End)
    Subnet([IPv4Address]$StartIPAddress,[IPv4Address]$EndIPAddress) {
        $RangeDifference = $EndIPAddress.DecimalAddress - $StartIPAddress.DecimalAddress + 1
        Write-Verbose -Message "Supplied IPv4 Range contains $RangeDifference hosts."

        # Make a guess on the CIDR Suffix
        $GuessHostBits = [Math]::Round([Math]::Log($RangeDifference,2))
        $CIDR = 32 - $GuessHostBits
        Write-Verbose -Message "Guessing a subnet with $RangeDifference hosts has a CIDR Suffix of $CIDR"

        # Convert IP to Binary Addresses using CIDR mask
        $BinaryPrefix = $StartIPAddress.BinaryAddress.Substring(0,$CIDR).padright(32,"0")
        $BinaryIPRangeStart = $StartIPAddress.BinaryAddress.Substring(0,$CIDR).padright(31,"0") + "1"
        $BinaryIPRangeEnd = $StartIPAddress.BinaryAddress.Substring(0,$CIDR).padright(31,"1") + "0"
        $BinarySubnetMask = "".PadLeft($CIDR,"1") + "".PadRight(32-$CIDR,"0")
        $BinaryBroadcastAddress = $StartIPAddress.BinaryAddress.Substring(0,$CIDR).padright(32,"1")

        # Verify the provided range starts with one of the first 2 addresses and ends on one of the last 2 address
        # Sometimes the same range is shown as 192.168.1.0 - 192.168.1.255, or 192.168.1.1 - 192.168.1.254
        $DecimalStart = [Convert]::ToUInt32($BinaryIPRangeStart,2)
        $DecimalEnd = [Convert]::ToUInt32($BinaryIPRangeEnd,2)

        if ( ($StartIPAddress.DecimalAddress -ne $DecimalStart -and $StartIPAddress.DecimalAddress -ne ($DecimalStart - 1)) `
        -or ($EndIPAddress.DecimalAddress -ne $DecimalEnd -and $EndIPAddress.DecimalAddress -ne ($DecimalEnd + 1)) ) {
            Write-Error -ErrorAction Stop -Message "The guessed subnet host range does not align with the supplied address. This must be just a range of IPs and not a subnet's range"
        }

        # Convert Binary IPs to Dotted Decimal IPs
        $PrefixArray = @()
        $RangeStartArray = @()
        $RangeEndArray = @()
        $SubnetMaskArray = @()
        $BroadcastArray = @()
        for ($i = 0; $i -lt 4; $i++) {
            $PrefixArray += [Convert]::ToInt32($BinaryPrefix.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $RangeStartArray += [Convert]::ToInt32($BinaryIPRangeStart.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $RangeEndArray += [Convert]::ToInt32($BinaryIPRangeEnd.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $SubnetMaskArray += [Convert]::ToInt32($BinarySubnetMask.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $BroadcastArray += [Convert]::ToInt32($BinaryBroadcastAddress.Substring($i*8,8),2)
        }
        $this.IPRangeStart = $RangeStartArray -join "."
        $this.IPRangeEnd = $RangeEndArray -join "."
        $this.SubnetMask = $SubnetMaskArray -join "."
        $this.BroadcastAddress = $BroadcastArray -join "."
        $this.NumberOfHosts = [Math]::Pow(2,32-$CIDR) - 2
        $this.CIDRNotation = ($PrefixArray -join ".") + "/$CIDR"
        $this.DecimalRangeStart = $DecimalStart
        $this.DecimalRangeEnd = $DecimalEnd
        $this.BinaryRangeStart = $BinaryIPRangeStart
        $this.BinaryRangeEnd = $BinaryIPRangeEnd
        $this.NetworkBits = $CIDR
    }

    # PS > New-Object Subnet ("192.168.1.0/24")
    Subnet([String]$CIDRNotation) {
        # Use regex to validate CIDR notation and parse IP from CIDR Prefix
        if ($CIDRNotation -notmatch "^((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))([\\/]([0-9]|[1-2][0-9]|3[0-2]))$") {
            Write-Error -Message "Unable to identify value as CIDR Notation IP, i.e. 192.168.0.0/24" -ErrorAction Stop
        }
        [IPv4Address]$IP = $matches[1]
        $CIDR = $matches[6]
        
        # Convert IP to Binary Addresses using CIDR mask
        $BinaryPrefix = $IP.BinaryAddress.Substring(0,$CIDR).padright(32,"0")
        $BinaryIPRangeStart = $IP.BinaryAddress.Substring(0,$CIDR).padright(31,"0") + "1"
        $BinaryIPRangeEnd = $IP.BinaryAddress.Substring(0,$CIDR).padright(31,"1") + "0"
        $BinarySubnetMask = "".PadLeft($CIDR,"1") + "".PadRight(32-$CIDR,"0")
        $BinaryBroadcastAddress = $IP.BinaryAddress.Substring(0,$CIDR).padright(32,"1")

        # Convert Binary IPs to Dotted Decimal IPs
        $PrefixArray = @()
        $RangeStartArray = @()
        $RangeEndArray = @()
        $SubnetMaskArray = @()
        $BroadcastArray = @()
        for ($i = 0; $i -lt 4; $i++) {
            $PrefixArray += [Convert]::ToInt32($BinaryPrefix.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $RangeStartArray += [Convert]::ToInt32($BinaryIPRangeStart.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $RangeEndArray += [Convert]::ToInt32($BinaryIPRangeEnd.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $SubnetMaskArray += [Convert]::ToInt32($BinarySubnetMask.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $BroadcastArray += [Convert]::ToInt32($BinaryBroadcastAddress.Substring($i*8,8),2)
        }
        $this.IPRangeStart = $RangeStartArray -join "."
        $this.IPRangeEnd = $RangeEndArray -join "."
        $this.SubnetMask = $SubnetMaskArray -join "."
        $this.BroadcastAddress = $BroadcastArray -join "."
        $this.NumberOfHosts = [Math]::Pow(2,32-$CIDR) - 2
        $this.CIDRNotation = ($PrefixArray -join ".") + "/$CIDR"
        $this.DecimalRangeStart = [Convert]::ToUInt32($BinaryIPRangeStart,2)
        $this.DecimalRangeEnd = [Convert]::ToUInt32($BinaryIPRangeEnd,2)
        $this.BinaryRangeStart = $BinaryIPRangeStart
        $this.BinaryRangeEnd = $BinaryIPRangeEnd
        $this.NetworkBits = $CIDR
    }

    # PS > New-Object Subnet ("192.168.1.0", 24)
    Subnet([String]$IPAddress, [Int32]$NetworkBits) {
        # Validate the input IP Addresses before proceeding
        if ($IPAddress -notmatch "^((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))?$") {
            Write-Error -ErrorAction Stop -Message "Unable to identify input value as an IP Address"
        }
        [IPv4Address]$IP = $IPAddress

        # Validate Inputs
        if ($NetworkBits -lt 0 -or $NetworkBits -gt 32) {
            Write-Error -Message "NetworkBits value must be between 0 and 32." -ErrorAction Stop
        }
        $CIDR = $NetworkBits
        
        # Convert IP to Binary Addresses using CIDR mask
        $BinaryPrefix = $IP.BinaryAddress.Substring(0,$CIDR).padright(32,"0")
        $BinaryIPRangeStart = $IP.BinaryAddress.Substring(0,$CIDR).padright(31,"0") + "1"
        $BinaryIPRangeEnd = $IP.BinaryAddress.Substring(0,$CIDR).padright(31,"1") + "0"
        $BinarySubnetMask = "".PadLeft($CIDR,"1") + "".PadRight(32-$CIDR,"0")
        $BinaryBroadcastAddress = $IP.BinaryAddress.Substring(0,$CIDR).padright(32,"1")

        # Convert Binary IPs to Dotted Decimal IPs
        $PrefixArray = @()
        $RangeStartArray = @()
        $RangeEndArray = @()
        $SubnetMaskArray = @()
        $BroadcastArray = @()
        for ($i = 0; $i -lt 4; $i++) {
            $PrefixArray += [Convert]::ToInt32($BinaryPrefix.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $RangeStartArray += [Convert]::ToInt32($BinaryIPRangeStart.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $RangeEndArray += [Convert]::ToInt32($BinaryIPRangeEnd.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $SubnetMaskArray += [Convert]::ToInt32($BinarySubnetMask.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $BroadcastArray += [Convert]::ToInt32($BinaryBroadcastAddress.Substring($i*8,8),2)
        }
        $this.IPRangeStart = $RangeStartArray -join "."
        $this.IPRangeEnd = $RangeEndArray -join "."
        $this.SubnetMask = $SubnetMaskArray -join "."
        $this.BroadcastAddress = $BroadcastArray -join "."
        $this.NumberOfHosts = [Math]::Pow(2,32-$CIDR) - 2
        $this.CIDRNotation = ($PrefixArray -join ".") + "/$CIDR"
        $this.DecimalRangeStart = [Convert]::ToUInt32($BinaryIPRangeStart,2)
        $this.DecimalRangeEnd = [Convert]::ToUInt32($BinaryIPRangeEnd,2)
        $this.BinaryRangeStart = $BinaryIPRangeStart
        $this.BinaryRangeEnd = $BinaryIPRangeEnd
        $this.NetworkBits = $CIDR
    }

    # PS > $IP = New-Object IPv4Address ("192.168.1.0")
    # PS > New-Object Subnet ($IP, 24)
    Subnet([IPv4Address]$IPAddress, [Int32]$NetworkBits) {
        # Validate Input
        if ($NetworkBits -lt 0 -or $NetworkBits -gt 32) {
            Write-Error -Message "NetworkBits value must be between 0 and 32." -ErrorAction Stop
        }
        
        # Convert IP to Binary Addresses using CIDR mask
        $BinaryPrefix = $IPAddress.BinaryAddress.Substring(0,$NetworkBits).padright(32,"0")
        $BinaryIPRangeStart = $IPAddress.BinaryAddress.Substring(0,$NetworkBits).padright(31,"0") + "1"
        $BinaryIPRangeEnd = $IPAddress.BinaryAddress.Substring(0,$NetworkBits).padright(31,"1") + "0"
        $BinarySubnetMask = "".PadLeft($NetworkBits,"1") + "".PadRight(32-$NetworkBits,"0")
        $BinaryBroadcastAddress = $IPAddress.BinaryAddress.Substring(0,$NetworkBits).padright(32,"1")

        # Convert Binary IPs to Dotted Decimal IPs
        $PrefixArray = @()
        $RangeStartArray = @()
        $RangeEndArray = @()
        $SubnetMaskArray = @()
        $BroadcastArray = @()
        for ($i = 0; $i -lt 4; $i++) {
            $PrefixArray += [Convert]::ToInt32($BinaryPrefix.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $RangeStartArray += [Convert]::ToInt32($BinaryIPRangeStart.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $RangeEndArray += [Convert]::ToInt32($BinaryIPRangeEnd.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $SubnetMaskArray += [Convert]::ToInt32($BinarySubnetMask.Substring($i*8,8),2)
        }
        for ($i = 0; $i -lt 4; $i++) {
            $BroadcastArray += [Convert]::ToInt32($BinaryBroadcastAddress.Substring($i*8,8),2)
        }
        $this.IPRangeStart = $RangeStartArray -join "."
        $this.IPRangeEnd = $RangeEndArray -join "."
        $this.SubnetMask = $SubnetMaskArray -join "."
        $this.BroadcastAddress = $BroadcastArray -join "."
        $this.NumberOfHosts = [Math]::Pow(2,32-$NetworkBits) - 2
        $this.CIDRNotation = ($PrefixArray -join ".") + "/$NetworkBits"
        $this.DecimalRangeStart = [Convert]::ToUInt32($BinaryIPRangeStart,2)
        $this.DecimalRangeEnd = [Convert]::ToUInt32($BinaryIPRangeEnd,2)
        $this.BinaryRangeStart = $BinaryIPRangeStart
        $this.BinaryRangeEnd = $BinaryIPRangeEnd
        $this.NetworkBits = $NetworkBits
    }

    # Methods
    # PS > $Subnet.ToString()
    #   192.168.1.0/24
    [String] ToString() {
        return $this.CIDRNotation
    }

    # Determine if two subnet objects define the same subnet
    # PS > $Subnet1.Is($Subnet2)
    #   True
    [Boolean] Is([Subnet]$Subnet) {
        Write-Verbose "Determining if subnets $this and $Subnet are the same"
        if ($this.DecimalRangeStart -eq $Subnet.DecimalRangeStart -and $this.DecimalRangeEnd -eq $Subnet.DecimalRangeEnd) {
            return $True
        }
        return $False
    }

    # Determine if $this subnet contains the supplied IP address
    # PS > $Subnet = New-Object Subnet ("192.168.1.1/24")
    # PS > $IP = New-Object IPv4Address ("192.168.1.50")
    # PS > $Subnet.Contains($IP)
    #   True
    [Boolean] Contains([IPv4Address]$IPAddress) {
        Write-Verbose "Determining if $IPAddress is located within $this"
        if ($IPAddress.DecimalAddress -ge $this.DecimalRangeStart -and $IPAddress.DecimalAddress -le $this.DecimalRangeEnd) {
            return $True
        }
        return $False
    }
    # PS > $Subnet = New-Object Subnet ("192.168.1.1/24")
    # PS > $Subnet.Contains("192.168.1.50")
    #   True
    [Boolean] Contains([String]$IPAddress) {
        # Validate the input IP Address before proceeding
        if ($IPAddress -notmatch "^((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))?$") {
            Write-Error -ErrorAction Stop -Message "Unable to identify input value as an IP Address"
        }
        [IPv4Address]$IP = $IPAddress

        Write-Verbose "Determining if $IP is located within $this"
        if ($IP.DecimalAddress -ge $this.DecimalRangeStart -and $IP.DecimalAddress -le $this.DecimalRangeEnd) {
            return $True
        }
        return $False
    }

    # Determine if two subnets overlap
    [Boolean] Overlaps([Subnet]$Subnet) {
        Write-Verbose "Determining if subnets $this and $Subnet overlap"
        $Overlaps = $False
        # Check if the Range Start or Stop for the supplied subnet falls within the range of $this
        if ($this.DecimalRangeStart -le $Subnet.DecimalRangeStart -and $Subnet.DecimalRangeStart -le $this.DecimalRangeEnd) {
            $Overlaps = $True
        }
        if ($this.DecimalRangeStart -le $Subnet.DecimalRangeEnd -and $Subnet.DecimalRangeEnd -le $this.DecimalRangeEnd) {
            $Overlaps = $True
        }
        
        # Check if the Range Start or Stop for $this falls within the range of the supplied subnet
        if ($Subnet.DecimalRangeStart -le $this.DecimalRangeStart -and $this.DecimalRangeStart -le $Subnet.DecimalRangeEnd) {
            $Overlaps = $True
        }
        if ($Subnet.DecimalRangeStart -le $this.DecimalRangeEnd -and $this.DecimalRangeEnd -le $Subnet.DecimalRangeEnd) {
            $Overlaps = $True
        }

        return $Overlaps
    }
}