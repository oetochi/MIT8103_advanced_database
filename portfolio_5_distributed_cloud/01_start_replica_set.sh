mkdir -p ~/mongo-rs/node1 ~/mongo-rs/node2 ~/mongo-rs/node3

mongod --replSet topezRS --port 27018 --dbpath ~/mongo-rs/node1 --bind_ip localhost --logpath ~/mongo-rs/node1.log --fork
mongod --replSet topezRS --port 27019 --dbpath ~/mongo-rs/node2 --bind_ip localhost --logpath ~/mongo-rs/node2.log --fork
mongod --replSet topezRS --port 27020 --dbpath ~/mongo-rs/node3 --bind_ip localhost --logpath ~/mongo-rs/node3.log --fork