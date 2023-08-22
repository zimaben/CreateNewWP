#!/bin/bash
echo "port number offset? (Ex: 3 for port 8003 - must use unused port between 1-9)"
read offset
echo "Folder Name? (Ex: Rexs Crawdads)"
read folder
echo "Path to folder? (Ex: ~/Desktop/sites/)"
read fpath

sed -i 's/<!x>/$offset/' docker-compose.yml
docker-compose up -d
docker exec site-cli wp core install --url=localhost:800$offset --title="$folder" --admin_user=admin --admin_password=admin --admin_email=local@admin.com --skip-email
docker exec site-cli wp plugin install slate-admin-theme --activate
docker exec site-cli wp plugin install white-label-cms --activate
docker exec site-cli wp plugin install woocommerce --activate
docker exec site-cli wp theme install storefront
mv Wordpress/* Wordpress/.[^.]* . && rmdir Wordpress/
docker cp site-cli:/var/www/html/wp-content $fpath/$folder/wp-content