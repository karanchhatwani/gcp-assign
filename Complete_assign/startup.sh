#!/bin/bash

# Install the necessary software
sudo apt-get update
sudo apt-get install -y apache2 php libapache2-mod-php

# Create a sample PHP file
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/index.php

# Start the Apache server
sudo systemctl start apache2
