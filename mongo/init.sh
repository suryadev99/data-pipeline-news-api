#!/bin/sh



#mongo -u ${MONGO_ADMIN} -p ${MONGO_ADMIN} --authenticationDatabase admin localhost:27017/admin <<-EOF
mongo -u rss_news -p rss_news --authenticationDatabase admin mongo:27017/admin <<-EOF
db.auth('admin','admin')

echo "Granting roles to admin user..."

mongo admin --eval 'db.grantRolesToUser("admin", [{ role: "clusterManager", db: "admin" }])'


mongo mongo:27017/${RSS_NEWS_USER} <<-EOF
    rs.initiate({
        _id: "rs0",
        members: [ { _id: 0, host: "mongo:27017" } ]
    });
EOF
echo "Initiated replica set"


echo "Waiting for MongoDB to become primary..."

until mongo --eval 'rs.isMaster().ismaster' | grep 'true'; do
  sleep 1
done

sleep 5

echo "initiate"
mongod --replSet rs0 --bind_ip localhost &
sleep 5
mongo --eval "rs.initiate()"
echo "finished initialisation"

mongo mongo:27017/${MONGO_ADMIN}  <<-EOF
  use admin
  db.auth('rss_news','rss_news')
  db.createUser({
      user: "${MONGO_ADMIN}",
      pwd: "${MONGO_ADMIN}",
      roles: [ { role: "userAdminAnyDatabase", db: "${MONGO_ADMIN}" } ]
  });
db.grantRolesToUser("${MONGO_ADMIN}", ["clusterManager"]);
EOF
mongo -u ${MONGO_ADMIN} -p ${MONGO_ADMIN} --authenticationDatabase admin mongo:27017/admin <<-EOF
    use admin
    db.auth("${MONGO_ADMIN}", "${MONGO_ADMIN}")
    db.runCommand({
        createRole: "listDatabases",
        privileges: [
            { resource: { cluster : true }, actions: ["listDatabases"]}
        ],
        roles: []
    });


    db.updateUser(
        "${RSS_NEWS_USER}",{
        pwd: "${RSS_NEWS_USER}",
        roles: [
            { role: "readWrite", db: "${RSS_NEWS_USER}" },
            { role: "readWrite", db: "test_${RSS_NEWS_USER}" },
            { role: "read", db: "local" },
            { role: "listDatabases", db: "${MONGO_ADMIN}" },
            { role: "read", db: "config" },
            { role: "read", db: "${MONGO_ADMIN}" }
        ]
    });
db.updateUser("rss_news",{ pwd: "rss_news", roles: [ { role: "root", db: "admin" } ]});

EOF