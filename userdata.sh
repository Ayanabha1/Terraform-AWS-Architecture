#!/bin/bash

# Updata packages
apt update -y

# Install nodejs and npm
apt install -y nodejs npm

# Create Project Folder
mkdir /home/ubuntu/project
cd /home/ubuntu/project
mkdir public

# index.html
echo "<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Public IP Address</title>
  <script src="script.js"></script>
</head>
<body>
        <h1>Instance public ip: <span id="public-ip">Loading...</span> </h1>
</body>
</html>" >public/index.html

# get_public_ip.sh
echo "#!/bin/bash
# get_public_ip.sh
# Obtain the public IP address
public_ip=\$(ip addr show eth0 | awk '/inet / {print \$2}' | cut -d'/' -f1)
# Print the public IP address
echo \$public_ip" > get_public_ip.sh

chmod +x get_public_ip.sh

# script.js
echo "document.addEventListener('DOMContentLoaded', function() {
  // Fetch the public IP address using the Bash script
  fetch('/get_public_ip')
    .then(response => response.text())
    .then(publicIp => {
      // Update the content of the "public-ip" paragraph
      document.getElementById('public-ip').innerText = publicIp;
    })
    .catch(error => {
      console.error('Error fetching public IP:', error);
      document.getElementById('public-ip').innerText = 'Error fetching public IP';
    });
});" > public/script.js

# Install express
npm i express

# index.js (node)
echo "const express = require('express');
const { exec } = require('child_process');
const app = express();
const port = 3000;
// Serve static files (including the HTML and JavaScript files)
app.use(express.static('public'));
// Endpoint to get the public IP address
app.get('/get_public_ip', (req, res) => {
  // Execute the Bash script
  exec('./get_public_ip.sh', (error, stdout, stderr) => {
    if (error) {
      console.error(`Error executing script: ${stderr}`);
      res.status(500).send('Internal Server Error');
    } else {
      // Send the public IP address as the response
      res.send(stdout.trim());
    }
  });
});
// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});" > index.js

# Start node app
node index.js
