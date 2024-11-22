#!/bin/bash

# Ensure the script is run as root
if [[ "$EUID" -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo or log in as root."
    exit 1
fi

# Define Wazuh installation URL
WAZUH_INSTALL_URL="https://packages.wazuh.com/4.7/wazuh-install.sh"
PASSWORD_TOOL_URL="https://packages.wazuh.com/4.7/wazuh-passwords-tool.sh"

# Check if Wazuh is already installed
is_wazuh_installed() {
    systemctl is-active --quiet wazuh-manager && return 0 || return 1
}

# Function to change the admin password
change_admin_password() {
    echo -e "\nChanging the admin account password..."
    echo -n "Enter the new password for the admin account: "
    read -s NEW_PASSWORD
    echo
    
    # Ensure the password is not empty
    if [[ -z "$NEW_PASSWORD" ]]; then
        echo "Password cannot be empty. Exiting..."
        exit 1
    fi
    
    # Change the admin password
    bash wazuh-passwords-tool.sh -u admin -p "$NEW_PASSWORD"
    if [[ $? -eq 0 ]]; then
        echo "Password changed successfully!"
        echo "Restarting filebeat and wazuh-dashboard services..."
        systemctl restart filebeat
        systemctl restart wazuh-dashboard
        echo "Services restarted successfully!"
    else
        echo "Failed to change password. Please check the tool and try again."
    fi
}

# Check if Wazuh is installed
if is_wazuh_installed; then
    echo "Wazuh is already installed. Skipping installation."
else
    # Install Wazuh
    echo "Downloading and installing Wazuh..."
    curl -sO "$WAZUH_INSTALL_URL" && bash ./wazuh-install.sh -a
    if [[ $? -ne 0 ]]; then
        echo "Wazuh installation failed. Exiting..."
        exit 1
    fi
    echo "Wazuh installation completed successfully!"
fi

# Ask the user if they want to download the password changer tool
echo -n "Do you want to download the Wazuh password changer tool? (Y/N): "
read DOWNLOAD_TOOL

if [[ "$DOWNLOAD_TOOL" =~ ^[Yy]$ ]]; then
    # Download the Wazuh passwords tool
    echo "Downloading the Wazuh passwords tool..."
    curl -so wazuh-passwords-tool.sh "$PASSWORD_TOOL_URL"
    chmod +x wazuh-passwords-tool.sh

    # Prompt the user for password change
    echo -n "Do you want to change the admin account password? (Y/N): "
    read CHANGE_PASSWORD

    if [[ "$CHANGE_PASSWORD" =~ ^[Yy]$ ]]; then
        change_admin_password
    else
        echo "Admin password change skipped."
    fi
else
    echo "Password changer tool download skipped."
fi

echo "Script execution completed."
