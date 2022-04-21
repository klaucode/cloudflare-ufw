#!/bin/bash
# Allowed Cloudflare ports (ports as strings separated by space)...
# (...you can modify the ports list, which you would like to open for Cloudflare)
# HTTP Ports supported by Cloudflare
# 80,8080,8880,2052,2082,2086,2095
# HTTPS ports supported by Cloudflare
# 443,2053,2083,2087,2096,8443

# https://developers.cloudflare.com/fundamentals/get-started/reference/network-ports/
declare -a allowCloudflarePorts=("80" "443" "8080" "8880" "2052" "2082" "2086" "2095" "443" "2053" "2083" "2087" "2096" "8443")

curl -s https://www.cloudflare.com/ips-v4 -o /tmp/cf_ips
echo "" >> /tmp/cf_ips
curl -s https://www.cloudflare.com/ips-v6 >> /tmp/cf_ips

# Allow all traffic from Cloudflare IPs (no ports restriction)
for cfip in `cat /tmp/cf_ips`; do (
  for cfport in ${allowCloudflarePorts[@]}; do
    echo "UFW Setting Cloudflare rule for: $cfip:$cfport"
    ufw allow proto tcp from $cfip to any port $cfport comment 'Cloudflare IP'
  done;
); done

ufw reload > /dev/null

# OTHER EXAMPLE RULES
# Retrict to port 80
#for cfip in `cat /tmp/cf_ips`; do ufw allow proto tcp from $cfip to any port 80 comment 'Cloudflare IP'; done

# Restrict to port 443
#for cfip in `cat /tmp/cf_ips`; do ufw allow proto tcp from $cfip to any port 443 comment 'Cloudflare IP'; done

# Restrict to ports 80 & 443
#for cfip in `cat /tmp/cf_ips`; do ufw allow proto tcp from $cfip to any port 80,443 comment 'Cloudflare IP'; done