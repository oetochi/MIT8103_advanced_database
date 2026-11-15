//Before indexing
db.orders.find({ "customer.customer_id": 500 }).explain("executionStats")

//After indexing
db.orders.createIndex({ "customer.customer_id": 1 })
db.orders.find({ "customer.customer_id": 500 }).explain("executionStats")