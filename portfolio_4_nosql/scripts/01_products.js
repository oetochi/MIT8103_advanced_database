//use topezfarms_nosql
db = db.getSiblingDB("topezfarms_nosql")
db.products.insertMany([
  {
    sku: "HOME-PALMOIL-5L",
    name: "Palm Oil (5L)",
    category: "Home",
    unit: "container",
    price: 8000,
    stock_qty: 150,
    sales_mode: "IN_STOCK",
    attributes: { volume_litres: 5, packaging: "plastic jerrycan", nafdac_no: "A1-0000" }
  },
  {
    sku: "HOME-GARRI-5KG",
    name: "Garri (5kg bag)",
    category: "Home",
    unit: "bag",
    price: 8000,
    stock_qty: 300,
    sales_mode: "IN_STOCK",
    attributes: { weight_kg: 5, type: "white", packaging: "polythene bag" }
  },
  {
    sku: "IND-CASSAVA-TON",
    name: "Cassava (ton)",
    category: "Industry",
    unit: "ton",
    price: 150000,
    stock_qty: 1000,
    min_order_qty: 10,
    sales_mode: "PRE_ORDER",
    attributes: { moisture_pct: 62, harvest_window: "2027-02 to 2027-03", source_region: "Abia" }
  }
]);

print("Products inserted successfully! Current count:");
print(db.products.countDocuments());