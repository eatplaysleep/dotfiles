#!/bin/bash
echo "Running challenge setup script on host container"

# Adjust VSCode settings
sudo mkdir -p /user-data/User
sudo cat > /user-data/User/settings.json <<EOF
{
  "workbench.colorTheme": "Default Dark+"
}
EOF

# Install Node.js
# https://github.com/nodesource/distributions/blob/master/README.md
sudo curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
sudo apt-get install -y nodejs

# Clone the example repository
sudo git clone https://github.com/instruqt/typescript-example-app.git /app

# Remove return statements to break the tests
sudo ex +g/return/d -cwq /app/src/sum.ts

# Change directory to the cloned repository and install its dependencies
cd /app
npm ci
