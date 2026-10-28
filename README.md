# Stoich Provisions Orders

Starter project for a custom order-request checkout connected to the Stoich Provisions collection on https://aqlx.shop/collections/stoich-provisions.

## Project files
- `src/index.js` — Cloudflare Worker API
- `public/checkout.html` — customer order-request form
- `public/admin.html` — private order dashboard
- `schema.sql` — Cloudflare D1 tables
- `wrangler.jsonc` — Worker configuration
- `shopify/cart-bridge.liquid` — Shopify cart button/snippet
- `shopify/INSTALL.md` — setup instructions

## Setup overview
1. Create a separate Cloudflare D1 database named `stoich-provisions-orders`.
2. Run `schema.sql` against that database.
3. Put the D1 database ID in `wrangler.jsonc`.
4. Install dependencies with `npm install`.
5. Set an admin token: `npx wrangler secret put ADMIN_TOKEN`.
6. Deploy with `npx wrangler deploy`.
7. Follow `shopify/INSTALL.md` to add the cart bridge to a duplicated Shopify theme first.

Initial notification email: `jpcalma09@gmail.com`. Email sending also needs an email provider configured; see README notes below.

**Important limitations:** This starter records order requests only. It does not collect payment, create Shopify Admin orders, reserve inventory, or yet verify cart prices against Shopify server-side. Do not use for live customer orders until those production protections and email-provider configuration are completed and tested. Saipan shipping/delivery costs are confirmed by your team after submission.

## Pickup box (Loxx Boxx)
Customers can choose **Pickup box (24/7)** at checkout. When the order is in the box, open it in `/admin.html`, press **Loaded in pickup box** and type the code you created in the Loxx Boxx app. The customer is emailed the code, the order moves to *Ready for pickup*, and the code is saved on the order. Edit the wording customers see with `PICKUP_BOX_LOCATION` and `PICKUP_BOX_STEPS` in `wrangler.jsonc`. Loxx Boxx has no public API, so codes are still created in their app.
