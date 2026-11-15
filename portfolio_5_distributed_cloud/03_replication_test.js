// direct primary replica
// in bash, run this script: mongosh --port 27020 before executing the js below
use topezfarms_nosql
db.orders.insertOne({ order_ref: "RS-TEST-1", status: "PENDING", note: "replication test" })

//direct secondary replica
// in bash, run this script: mongosh --port 27019 before executing the js below
use topezfarms_nosql
db.getMongo().setReadPref("secondary")
db.orders.find({ order_ref: "RS-TEST-1" })