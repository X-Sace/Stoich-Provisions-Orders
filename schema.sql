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
  payment_method TEXT NOT NULL DEFAULT '',
  address TEXT DEFAULT '',
  customer_notes TEXT DEFAULT '',
  internal_notes TEXT DEFAULT '',
  currency TEXT NOT NULL DEFAULT 'USD',
  subtotal_cents INTEGER NOT NULL DEFAULT 0,
  items_json TEXT NOT NULL,
  shopify_cart_id TEXT DEFAULT '',
  gross_cents INTEGER NOT NULL DEFAULT 0,
  discount_cents INTEGER NOT NULL DEFAULT 0,
  discount_json TEXT NOT NULL DEFAULT '[]',
  merchant_id TEXT NOT NULL DEFAULT '',
  merchant_company TEXT NOT NULL DEFAULT ''
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
CREATE TABLE IF NOT EXISTS payment_links (
  id TEXT PRIMARY KEY,
  order_id TEXT NOT NULL,
  url TEXT NOT NULL,
  amount_cents INTEGER NOT NULL DEFAULT 0,
  note TEXT NOT NULL DEFAULT '',
  sent_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_payment_links_order ON payment_links(order_id, sent_at DESC);
CREATE TABLE IF NOT EXISTS discount_rules (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  scope TEXT NOT NULL DEFAULT 'all',
  match_value TEXT NOT NULL DEFAULT '',
  percent REAL NOT NULL DEFAULT 0,
  active INTEGER NOT NULL DEFAULT 1,
  starts_at TEXT NOT NULL DEFAULT '',
  ends_at TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS merchants (
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  company TEXT NOT NULL DEFAULT '',
  contact_name TEXT NOT NULL DEFAULT '',
  email TEXT NOT NULL DEFAULT '',
  phone TEXT NOT NULL DEFAULT '',
  password_hash TEXT NOT NULL DEFAULT '',
  password_salt TEXT NOT NULL DEFAULT '',
  password_iterations INTEGER NOT NULL DEFAULT 120000,
  discount_percent REAL NOT NULL DEFAULT 0,
  active INTEGER NOT NULL DEFAULT 1,
  notes TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL,
  last_login_at TEXT NOT NULL DEFAULT ''
);
CREATE TABLE IF NOT EXISTS merchant_sessions (
  token_hash TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL,
  created_at TEXT NOT NULL,
  expires_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_merchant_sessions_m ON merchant_sessions(merchant_id);
