db = db.getSiblingDB("topezfarms_nosql")

// Q1: one customer's orders (a very common lookup)
db.orders.find({ "customer.customer_id": 500 })

// Q2: all pre-orders still awaiting full delivery
db.orders.find({ order_type: "PRE_ORDER", status: { $ne: "DELIVERED" } }).limit(5)

// Q3: revenue per product
db.orders.aggregate([
  { $match: { status: { $ne: "CANCELLED" } } },
  { $unwind: "$items" },
  { $group: { _id: "$items.sku", units: { $sum: "$items.qty" },
              revenue: { $sum: { $multiply: ["$items.qty", "$items.unit_price"] } } } },
  { $sort: { revenue: -1 } },
  { $limit: 5 }
])

// Q4: outstanding quantity on pre-orders (ordered minus delivered)
db.orders.aggregate([
  { $match: { order_type: "PRE_ORDER", order_ref: { $in: ["ORD-00026"] } } },
  { $unwind: "$items" },
  { $addFields: { delivered: { $sum: { $map: { input: "$deliveries", as: "d", in: {
      $sum: { $map: { input: { $filter: { input: "$$d.items", as: "di",
        cond: { $eq: ["$$di.sku", "$items.sku"] } } }, as: "x", in: "$$x.qty" } } } } } } } },
  { $project: { _id: 0, order_ref: 1, sku: "$items.sku", ordered: "$items.qty",
                delivered: 1, outstanding: { $subtract: ["$items.qty", "$delivered"] } } }
])