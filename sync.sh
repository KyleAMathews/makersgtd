#rsync /var/www/makersgtd/* -rzhv --stats --delete eduglu:/var/nodejs/SimpleGTD --exclude node_modules --exclude dump --exclude brunch/src -C
ssh -A eduglu 'sh /var/nodejs/makersgtd/deploy'
ssh eduglu 'mongodump --db simpleGTD --out /var/nodejs/SimpleGTD/dump/'
scp eduglu:/var/nodejs/SimpleGTD/dump/simpleGTD/* /var/www/makersgtd/dump/simpleGTD/
mongorestore --drop --db simpleGTD /var/www/makersgtd/dump/simpleGTD/
