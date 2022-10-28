#!/bin/bash
echo "===========================================================================
      |            Running challenge setup script on host container             |
      ===========================================================================
      "
echo "===========================================================================
      |                     Setting custom VSCode settings                      |
      |-------------------------------------------------------------------------|
      |                                                                         |
      | `mkdir -p ~/user-data/User`                                             |
      |                                                                         |
      | `cat > ~/user-data/User/settings.json <<EOF                             |
      | {                                                                       |
      |     "explorer.fileNesting.enabled": true,                               |
      |     "editor.formatOnSave": true,                                        |
      |     "editor.formatOnPaste": true,                                       |
      |     "files.autoSave": "off",                                            |
      |     "security.workspace.trust.banner": "never",                         |
      |     "security.workspace.trust.enabled": false,                          |
      |     "security.workspace.trust.startupPrompt": "never",                  |
      |     "security.workspace.trust.untrustedFiles": "open",                  |
      |     "terminal.integrated.defaultProfile.linux": "bash",                 |
      |     "workbench.colorTheme": "Default Dark+",                            |
      |     "workbench.editor.highlightModifiedTabs": true,                     |
      |     "workbench.startupEditor": "readme"                                 |
      | }                                                                       |
      | EOF`                                                                    |
      ===========================================================================
      "
mkdir -p ~/user-data/User
cat > ~/user-data/User/settings.json <<EOF
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

echo "===========================================================================
      |                         Installing NodeJS                               |
      |-------------------------------------------------------------------------|
      |                                                                         |
      | `curl -fsSL https://deb.nodesource.com/setup_16.x | bash -1`            |
      |                                                                         |
      | `apt-get install -y nodejs`                                             |
      ===========================================================================
      "
# https://github.com/nodesource/distributions/blob/master/README.md
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs

echo "===========================================================================
      |                       Cloning the template repo                         |
      |-------------------------------------------------------------------------|
      |                                                                         |
      | `git clone https://github.com/udplabs/auth-rocks-app-template.git ~/app`|
      |                                                                         |
      | `apt-get install -y nodejs`                                             |
      ===========================================================================
      "
git clone https://github.com/udplabs/auth-rocks-app-template.git ~/app

echo "===========================================================================
      |                                 Changing CWD                            |
      |-------------------------------------------------------------------------|
      |                                                                         |
      | `cd ~/app`                                                              |
      |                                                                         |
      | `npm ci`                                                                |
      ===========================================================================
      "
cd ~/app
npm ci
