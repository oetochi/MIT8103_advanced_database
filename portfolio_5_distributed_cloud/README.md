# Portfolio 5 Distributed Cloud

**Create 3 nodes**

`1. mkdir -p ~/mongo-rs/node1 ~/mongo-rs/node2 ~/mongo-rs/node3` (creates three nodes - node1, node2 & node3)

`2. nohup mongod --replSet topezRS --port 27018 --dbpath ~/mongo-rs/node1 --bind_ip localhost --logpath ~/mongo-rs/node1.log > /dev/null 2>&1 &`

`3. nohup mongod --replSet topezRS --port 27019 --dbpath ~/mongo-rs/node2 --bind_ip localhost --logpath ~/mongo-rs/node2.log > /dev/null 2>&1 &`

`4. nohup mongod --replSet topezRS --port 27020 --dbpath ~/mongo-rs/node3 --bind_ip localhost --logpath ~/mongo-rs/node3.log > /dev/null 2>&1 &`

// member state report 

`rs.status().members.map(m => ({ name: m.name, state: m.stateStr }))`