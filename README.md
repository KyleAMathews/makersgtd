How to start MongoDB (It doesn't start on boot):
``sudo mongod --fork --logpath /var/log/mongodb/mongodb.log --logappend``

How to start app on production
`NODE_ENV=production forever start -c coffee -a -l /var/log/makersgtd.log -e /var/log/makersgtd.err /opt/makersgtd/server.coffee 80`
