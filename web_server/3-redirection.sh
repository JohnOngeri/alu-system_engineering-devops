#!/bin/bash

# Install Nginx
sudo apt-get update
sudo apt-get install -y nginx

# Configure Nginx redirection
sudo tee /etc/nginx/sites-available/redirection <<EOF
server {
    listen 80;
    server_name _; # Default server_name to catch all requests

    location /redirect_me/ {
        return 301 http://new_domain.com/new_path;
    }
}
EOF

# Remove default server configuration to avoid conflicts
sudo rm /etc/nginx/sites-enabled/default

# Create a symbolic link to enable the configuration
sudo ln -sf /etc/nginx/sites-available/redirection /etc/nginx/sites-enabled/

# Test Nginx configuration
sudo nginx -t

# Check if Nginx configuration test passed
if [ $? -eq 0 ]; then
    # Reload Nginx to apply changes
    sudo service nginx reload
else
    echo "Nginx configuration test failed. Please check your configuration."
fi

