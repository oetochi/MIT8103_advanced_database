db = db.getSiblingDB("topezfarms_nosql")

const products = db.products.find().toArray()
const states = [["Port Harcourt","Rivers"],["Aba","Abia"],["Enugu","Enugu"],["Lagos","Lagos"]]
const statuses = ["PENDING","CONFIRMED","PARTIALLY_DELIVERED","DELIVERED","CANCELLED"]

let batch = []
for (let i = 1; i <= 20000; i++) {
  const p = products[i % products.length]
  const qty = 1 + (i % 5)
  const loc = states[i % 4]
  batch.push({
    order_ref: "BULK-" + String(i).padStart(6, "0"),
    customer: { customer_id: 1 + (i % 20000), name: "Bulk Customer " + i, type: i % 20 === 0 ? "INDUSTRY" : "HOME" },
    order_type: i % 20 === 0 ? "PRE_ORDER" : "STANDARD",
    order_date: new Date(2025, 0, 1 + (i * 37 % 680)),
    status: statuses[i % 5],
    shipping: { city: loc[0], state: loc[1] },
    items: [ { sku: p.sku, name: p.name, qty: qty, unit_price: p.price } ],
    payments: [ { amount: qty * p.price, method: "CARD", status: "SUCCESS" } ],
    deliveries: []
  })
  if (batch.length === 1000) { db.orders.insertMany(batch); batch = [] }
}
print("orders now: " + db.orders.countDocuments())