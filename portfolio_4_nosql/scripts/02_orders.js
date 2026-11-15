db = db.getSiblingDB("topezfarms_nosql");

db.orders.insertMany([
  {
    order_ref: "ORD-0001",
    customer: { customer_id: 1, name: "Miebi Wonders", type: "HOME" },
    order_type: "STANDARD",
    order_date: new Date("2026-11-11"),
    status: "PENDING",
    shipping: { city: "Port Harcourt", state: "Rivers" },
    items: [
      { sku: "HOME-GARRI-5KG",  name: "Garri (5kg bag)", qty: 2, unit_price: 8000 },
      { sku: "HOME-PALMOIL-5L", name: "Palm Oil (5L)",   qty: 1, unit_price: 8000 }
    ],
    payments: [ { amount: 24000, method: "CARD", status: "SUCCESS" } ],
    deliveries: [ { courier: "Topez Logistics", status: "DELIVERED", items: [ { sku: "HOME-GARRI-5KG", qty: 2 }, { sku: "HOME-PALMOIL-5L", qty: 1 } ] } ]
  },
  {
    order_ref: "ORD-0026",
    customer: { customer_id: 2, name: "Bulk Customer20", type: "INDUSTRY", company: "Bulk Customer20" },
    order_type: "PRE_ORDER",
    order_date: new Date("2025-01-24"),
    expected_delivery_date: new Date("2025-03-25"),
    status: "CANCELLED",
    shipping: { city: "Aba", state: "Abia" },
    items: [ { sku: "IND-CASSAVA-TON", name: "Cassava (ton)", qty: 5, unit_price: 150000 } ],
    payments: [ { amount: 375000, method: "BANK_TRANSFER", status: "SUCCESS" } ],
    deliveries: [ { courier: "Topez Logistics", status: "DELIVERED", items: [ { sku: "IND-CASSAVA-TON", qty: 3 } ] } ]
  }
])

db.orders.find().pretty()