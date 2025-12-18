<# 

This script sets the subnets for each site so clients will only pull up the IPs of Domain Controllers they have access to.
As each site is isolated, the root record for the domain would still pull up all domain controllers across multiple sites.
This script would be repeated on each domain controller and the script edited to target the subnets they serve.

#>

# Add subnets for Site
Add-DnsServerClientSubnet -Name "Site-Subnet" -IPv4Subnet "172.26.0.0/16"

# Adding DC IPs so the policy does not affact DCs
Add-DnsServerClientSubnet -Name "DC-of-site" -IPv4Subnet "172.26.10.8/32"

# Adds the new scope for the new record to live
Add-DnsServerZoneScope -ZoneName "domain.local" -name "Site-Scope"

# Adds the record we want the query to hit
Add-DnsServerResourceRecord -ZoneName "domain.local" -A -Name "." -IPv4Address "172.26.10.8" -ZoneScope "Site-Scope"

# Adds records of primary DC
Add-DnsServerResourceRecord -ZoneName "domain.local" -A -Name "." -IPv4Address "10.10.10.8" -ZoneScope "Site-Scope"


# Excludes DCs by processing rule first
Add-DnsServerQueryResolutionPolicy -Name "DC-No-DNS-Change" `
  -Action ALLOW `
  -ClientSubnet "eq,DC-of-site" `
  -FQDN "EQ,domain.local" `
  -ZoneScope "domain.local,1" `
  -ZoneName "domain.local" `
  -ProcessingOrder 1

# Adds the policy to the scope
Add-DnsServerQueryResolutionPolicy -Name "Site-domain.local-DNS-Policy" `
  -Action ALLOW `
  -ClientSubnet "eq,Site-Subnet" `
  -FQDN "EQ,domain.local" `
  -ZoneScope "Site-Scope,1" `
  -ZoneName "domain.local"
