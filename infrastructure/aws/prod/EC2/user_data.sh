#!/bin/bash
set -e

echo "==> Running EC2 Boot-Time User Data Script..."

# Get dynamic metadata using IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Append runtime info to our Packer-baked index.html
cat <<EOF >> /var/www/html/index.html
<hr>
<h3>Runtime Boot Details (Injected via Terragrunt Local User-Data Script):</h3>
<ul>
    <li><b>Instance ID:</b> ${INSTANCE_ID}</li>
    <li><b>Availability Zone:</b> ${AZ}</li>
    <li><b>Boot Time (UTC):</b> $(date)</li>
</ul>
EOF

systemctl restart nginx
echo "==> User Data Script Executed Successfully!"