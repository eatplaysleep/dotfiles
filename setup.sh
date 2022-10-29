#!/bin/bash
echo "Running challenge setup script on host container"
echo "===> Setting custom VSCode settings..."
mkdir -p /home/coder/user-data/User
cat > /home/coder/user-data/User/settings.json <<EOF
{
    "explorer.fileNesting.enabled": true,
    "editor.formatOnSave": true,
    "editor.formatOnPaste": true,
    "files.autoSave": "off",
    "security.workspace.trust.banner": "never",
    "security.workspace.trust.enabled": false,
    "security.workspace.trust.startupPrompt": "never",
    "security.workspace.trust.untrustedFiles": "open",
    "terminal.integrated.defaultProfile.linux": "bash",
    "workbench.colorTheme": "Default Dark+",
    "workbench.editor.highlightModifiedTabs": true,
    "workbench.startupEditor": "readme"
}
EOF

echo "===>Installing NodeJS"
# https://github.com/nodesource/distributions/blob/master/README.md
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs

echo "===>Cloning template repo..."
git clone https://github.com/udplabs/auth-rocks-app-template.git /home/coder/app

echo "===>Changing CWD..."
echo "===>Installing dependencies..."
cd /home/coder/app
npm ci
