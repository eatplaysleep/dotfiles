#!/bin/bash
echo "Running challenge setup script on host container"

# Adjust VSCode settings
mkdir -p /user-data/User
cat > /user-data/User/settings.json <<EOF
{
  "workbench.colorTheme": "Default Dark+",
  "security.workspace.trust.enabled": false
}
EOF

# Install Node.js
# https://github.com/nodesource/distributions/blob/master/README.md
curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs

# Clone the example repository
git clone https://github.com/udplabs/auth-rocks-app-template.git /app

# Change directory to the cloned repository and install its dependencies
cd /app
npm ci
