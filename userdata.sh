#!/bin/bash

# Updata packages
apt update -y

# Install nodejs and npm
apt install -y nodejs npm

# Create Base Folder
mkdir /home/ubuntu/project
cd /home/ubuntu/project

# Clone repository
git clone https://github.com/Ayanabha1/webpage-for-terraform-project.git

# Go to the project folder 
cd /home/ubuntu/project/webpage-for-terraform-project

# Give permissions to get_public_ip.sh
chmod +x get_public_ip.sh

# Install dependencies
npm i

# Run app
node index.js