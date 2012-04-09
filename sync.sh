#rsync /var/www/makersgtd/* -rzhv --stats --delete eduglu:/var/nodejs/SimpleGTD --exclude node_modules --exclude dump --exclude brunch/src -C
ssh -A makersgtd 'sh /opt/makersgtd/deploy.sh'
ssh makersgtd 'mongodump --db simpleGTD --out /opt/makersgtd/SimpleGTD/dump/'
scp makersgtd:/opt/makersgtd/SimpleGTD/dump/simpleGTD/* /var/www/makersgtd/dump/simpleGTD/
mongorestore --drop --db simpleGTD /var/www/makersgtd/dump/simpleGTD/
