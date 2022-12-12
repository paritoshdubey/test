#!/bin/sh
endpoint=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/attributes/ENDPOINT -H "Metadata-Flavor: Google")
forwarding_port=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/attributes/FORWARDING_PORT -H "Metadata-Flavor: Google")

sysctl -w net.ipv4.ip_forward=1
firewall-cmd --permanent --add-masquerade
firewall-cmd --permanent --add-forward-port=port=$forwarding_port:proto=tcp:toaddr="$endpoint"
firewall-cmd --add-masquerade
firewall-cmd --add-forward-port=port=$forwarding_port:proto=tcp:toaddr="$endpoint"

exit 0
