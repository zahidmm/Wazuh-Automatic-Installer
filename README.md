# Wazuh-Automatic-Installer

This repository contains a Bash script to automate the installation of Wazuh 4.7 on Ubuntu 22.04. The script includes options for managing the admin account password and ensuring services are restarted as needed.

## Features

- **Automatic Installation**: Installs Wazuh 4.7 on Ubuntu 22.04 if not already installed.
- **Password Management**: Allows the user to download a password management tool and change the admin account password.
- **Service Management**: Automatically restarts `filebeat` and `wazuh-dashboard` services after the admin password is updated.
- **Root Access Check**: Ensures the script is run as `root` or with `sudo` privileges.
- **Interactive Options**: Prompts users to confirm actions, such as downloading the password management tool or updating the admin password.

## Requirements

- Ubuntu 22.04
- Root or sudo privileges

## Installation and Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/wazuh-automation.git
   cd wazuh-automation
   ```
2. Make the script executable:
  ```bash
  chmod +x install_wazuh.sh
  ```
3. Run the script:
  ```bash
  sudo ./install_wazuh.sh
  ```
4. Follow the interactive prompts during execution.

## Script Workflow
1. Root Privileges Check:
  Ensures the script is executed with root privileges.
  Exits with an error message if not.

2. Wazuh Installation:
  Checks if Wazuh is already installed by verifying the wazuh-manager service.
  If installed, skips the installation step.
  If not installed, downloads and installs Wazuh 4.7.

4. Password Tool Management:
  Prompts the user to decide whether to download the Wazuh password management tool.
  If downloaded, allows the user to set a new password for the admin account.

6. Service Restart:
  After a successful password update, restarts the filebeat and wazuh-dashboard services to apply changes.

## Contributing
Feel free to fork this repository, make changes, and create pull requests. Suggestions and improvements are always welcome.

