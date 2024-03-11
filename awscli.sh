#!/bin/bash
 
# Function to check if a command is available
command_exists() {
    command -v "$1" &> /dev/null
}
 
# Function to check system architecture
check_architecture() {
    arch=$(uname -m)
    if [ "$arch" == "x86_64" ]; then
        aws_cli_url="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
    elif [ "$arch" == "aarch64" ]; then
        aws_cli_url="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"
    else
        echo "Unsupported architecture: $arch"
        exit 1
    fi
}
 
# Check system architecture
check_architecture
 
# Check if zip and unzip are installed, if not, install them
if ! command_exists zip || ! command_exists unzip; then
    echo "zip and/or unzip are not installed. Installing..."
    sudo apt update
    sudo apt install -y zip unzip
fi
 
# Check if AWS CLI is already installed
if command_exists aws; then
    echo "AWS CLI is already installed."
    exit 0
fi
 
# Download AWS CLI installation package
curl "$aws_cli_url" -o "awscliv2.zip"
 
# Unzip the package
unzip awscliv2.zip
 
# Run the installation script
sudo ./aws/install
 
# Verify the installation
aws --version
 
# Clean up downloaded files
rm -rf aws awscliv2.zip
