#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root. Please use sudo or switch to root user." 
   exit 1
fi

# Function to backup existing repo files
backup_repos() {
    echo "Backing up existing repo files..."
    if [ -d /etc/yum.repos.d ]; then
        mkdir -p /etc/yum.repos.d/backup
        cp /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup/
        echo "Backup completed successfully."
    else
        echo "/etc/yum.repos.d directory does not exist. Exiting..."
        exit 1
    fi
}

# Function to download new repo files
update_repos() {
    echo "Downloading new CentOS 7 repo files..."
    curl -o /etc/yum.repos.d/CentOS-Base.repo https://vault.centos.org/centos/7/os/x86_64/CentOS-Base.repo
    if [ $? -eq 0 ]; then
        echo "New repo file downloaded successfully."
    else
        echo "Failed to download new repo file. Exiting..."
        exit 1
    fi
}

# Function to clean yum cache and update
clean_and_update() {
    echo "Cleaning yum cache and updating..."
    yum clean all
    yum makecache fast
    yum update -y
    if [ $? -eq 0 ]; then
        echo "Yum update completed successfully."
    else
        echo "Yum update failed. Please check the error messages above."
        exit 1
    fi
}

# Main script execution
echo "Starting repository update script for CentOS 7..."

backup_repos
update_repos
clean_and_update

echo "Repository update script completed successfully."
