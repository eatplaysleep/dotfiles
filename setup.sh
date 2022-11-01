#!/bin/bash

# set -euxo pipefail

echo "Running track setup script"

# -----------------------------------
## We export a dollar sign in order to utilize variables in our NGINX config.
## See https://www.baeldung.com/linux/nginx-config-environment-variables for details.
export DOLLAR="$"
# -----------------------------------

# ------------ VARIABLES ------------
export APP_PATH='/root/.local/share/code-server/app'
export TEMPLATES=$APP_PATH'/.vscode'
CERT_CONTACT='danny.fuhriman@okta.com'
CODE_SERVER_ENV_TEMPLATE=$TEMPLATES'/code-server.env.template'
CODE_SERVER_ENV='/etc/code-server'
# CODE_SERVER_INSTALL_URL='https://code-server.dev/install.sh'
NGINX_CONFIG_FILE='/etc/nginx/sites-available/app-server.conf'
NGINX_CONFIG_LINK='/etc/nginx/sites-enabled/app-server.conf'
NGINX_CONFIG_TEMPLATE=$TEMPLATES'/app-server.conf.template'
NODEJS_SRC_URL='https://deb.nodesource.com/setup_16.x'
export SANDBOX_URL=$HOSTNAME.$_SANDBOX_ID.instruqt.io
START_SCRIPT_TEMPLATE=$TEMPLATES'/code-server.service.template'
START_SCRIPT_FILE='/etc/systemd/system/code-server.service'
export USER_SETTINGS_DIR='/root/.local/share/code-server/.vscode'
USER_SETTINGS=$USER_SETTINGS_DIR'/User'
# -----------------------------------

# ------- Install Code Server -------
# curl -fsSL $CODE_SERVER_INSTALL_URL | sh
# -----------------------------------

# ------ Refresh Package Index ------
apt-get -y update
# -----------------------------------

# --------- Install NodeJS ----------
## See https://github.com/nodesource/distributions/blob/master/README.md
if ![[ -x /usr/local/bin/node ]]; then
    curl -fsSL $NODEJS_SRC_URL | bash -
    apt-get install -y nodejs
fi
# -----------------------------------


# --------- Setup Workspace ---------
## Create directories for user data & code
mkdir -p $APP_PATH
mkdir -p $USER_SETTINGS
mkdir -p $CODE_SERVER_ENV

## Clone the example repository
git clone https://github.com/udplabs/auth-rocks-app-template.git $APP_PATH

## Change directory and install dependencies
cd $APP_PATH
npm ci

## Create VS Code user settings
cp $APP_PATH/.vscode/settings.json $USER_SETTINGS
# -----------------------------------


# ----------- Setup NGINX -----------
## For details on why we are doing this, see https://coder.com/docs/code-server/latest/guide#using-lets-encrypt-with-nginx

## Install nginx (if not present)
if ! [[ -x /usr/local/bin/nginx ]]; then
    apt-get install -y nginx
fi

## Install snapd (if not present)
if ! [[ -x /usr/local/bin/snap ]]; then
    snap install core
fi
## Refresh snapd core
snap refresh core

## Install certbot if not present
if ! [[ -x /usr/local/bin/certbot ]]; then
    snap install --classic certbot
    ln -s /snap/bin/certbot /usr/bin/certbot
fi

## Install & Configure Route53 plugin
snap set certbot trust-plugin-with-root=ok
snap install certbot-dns-route53

## Install envsubst (if not installed)
if ! [[ -x /usr/local/bin/envsubst ]]; then
    apt-get install gettext-base
fi

### Add AWS credentials to service env file
envsubst < $CODE_SERVER_ENV_TEMPLATE > $CODE_SERVER_ENV'/env'

## Generate && set nginx configuration
envsubst < $NGINX_CONFIG_TEMPLATE > $NGINX_CONFIG_FILE

## Enable config and generate cert
ln -s $NGINX_CONFIG_FILE $NGINX_CONFIG_LINK
certbot run --non-interactive --redirect --agree-tos -a dns-route53 -i nginx -d $SANDBOX_URL -d gentle-animal.auth.rocks -m $CERT_CONTACT --allow-subset-of-names
# certbot certonly --cert-name $SANDBOX_URL --dns-route53 -d gentle-animal.auth.rocks

if pgrep -x nginx >/dev/null; then
    echo "The nginx service is running. Restart it!"
    
    ## Reload nginx
#     nginx -s reload
    service nginx reload
fi
# -----------------------------------

# ----- Generate Startup Script -----
envsubst < $START_SCRIPT_TEMPLATE > $START_SCRIPT_FILE
# -----------------------------------


# Start Code Server
# systemctl enable code-server
# systemctl start code-server
