#!/bin/bash 

set -e 

echo "waiting for cloud init to finish"
sudo cloud-init status --wait

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
sudo apt-get install -y nginx

echo "==> Creating a custom index.html to verify our Golden AMI..."
cat <<EOF | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html>
<head><title>Custom Packer AMI</title></head>
<body><h1>Nginx Baked via Packer by Omkar!</h1></body>
</html>
EOF

echo "==> Enabling Nginx service on boot..."
sudo systemctl enable nginx
sudo systemctl start nginx

echo "==> Cleaning up apt cache to keep AMI size small..."
sudo apt-get clean
