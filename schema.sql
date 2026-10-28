CREATE TABLE IF NOT EXISTS orders (
  id TEXT PRIMARY KEY,
  order_number INTEGER NOT NULL UNIQUE,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'new',
  customer_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  contact_preference TEXT NOT NULL,
  fulfillment_method TEXT NOT NULL,
  address TEXT DEFAULT '',
  customer_notes TEXT DEFAULT '',
  internal_notes TEXT DEFAULT '',
  currency TEXT NOT NULL DEFAULT 'USD',
  subtotal_cents INTEGER NOT NULL DEFAULT 0,
  items_json TEXT NOT NULL,
  shopify_cart_id TEXT DEFAULT ''
);
CREATE TABLE IF NOT EXISTS notification_emails (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL UNIQUE,
  enabled INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE TABLE IF NOT EXISTS pickup_box_codes (
  order_id TEXT PRIMARY KEY,
  code TEXT NOT NULL,
  loaded_at TEXT NOT NULL
);
