STOICH PROVISIONS ORDERS — UPDATE PACKAGE

Files:
- src/index.js: expanded order status options and branded HTML/text Gmail emails.
- public/admin.html: matching expanded order status choices.
- public/checkout.html: auto-requests Shopify cart data from its parent page, retries, and blocks empty-cart submissions.
- shopify-checkout-cart-bridge.liquid.txt: required Shopify page iframe + cart bridge snippet.

IMPORTANT CART BRIDGE SETUP
The Worker checkout is on a different origin from aqlx.shop, so it cannot directly read the Shopify customer session/cart. The Shopify page must run the included bridge snippet. In your Shopify admin, edit the custom page/template for /pages/checkout and ensure it contains the iframe and script in shopify-checkout-cart-bridge.liquid.txt. If the page already has an iframe/script, replace that block with the supplied snippet (avoid duplicating iframes). Your Shopify buttons can then link directly to https://aqlx.shop/pages/checkout; customers do not need to open /cart first.

DEPLOY
1. Back up your current GitHub files.
2. Replace src/index.js and public/admin.html with the package versions.
3. Replace public/checkout.html with the package version.
4. Update the Shopify /pages/checkout template using the included bridge snippet.
5. Deploy the Worker and test with a real Shopify cart containing 2+ different products and quantities.

STATUS NOTE
This update keeps a single order status field for compatibility with the existing database. Status choices include confirmed, processing, awaiting payment, partially paid, paid, ready for pickup, out for delivery, shipped, on hold, completed, cancelled, refunded, and payment failed. Payment and fulfillment are represented as workflow choices, not independent database fields yet.

EMAILS
Uses your existing Gmail OAuth secrets. New-order admin notifications and customer receipt emails are HTML branded with a plain-text alternative. Customer email says the request is not yet confirmed or paid.

TEST CHECKLIST
- Visit /pages/checkout directly with products in the Shopify cart (do not open /cart first).
- Confirm all products, variants, quantities, and subtotal display.
- Try an empty cart and confirm submission is blocked.
- Submit one test request and verify admin notification and customer receipt.
- Update status in admin and confirm it saves.

SECURITY / PRICE NOTE
The existing backend accepts product and unit prices supplied by the browser. Verify prices and stock before invoicing or accepting payment; this package does not add server-side Shopify Admin API price validation.
