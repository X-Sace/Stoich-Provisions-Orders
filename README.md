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

## Payment choice and payment links
Customers now pick how they will pay at checkout:
- **Card (invoice link)** — available for every delivery option. Your team sends a payment link after confirming the total.
- **Cash (in store)** — only offered with *Guam store pickup* (the Worker rejects cash with delivery or the pickup box).

In `/admin.html`, each order has a **Payment link** box. Create the invoice/link in your payment app (Square, PayPal, Stripe, etc.), paste it, then:
- **Email link** — emails the customer a branded "Pay $X" button.
- **WhatsApp link / Text link / Copy message** — opens a ready-made message with the link.

Every option saves the link on the order (latest one is shown in the list as `CARD · LINK SENT`) and moves the order to *Awaiting payment*. Record the money under **Payments & receipts** when it arrives, as before.

Existing databases are upgraded automatically on the next request (adds `orders.payment_method` and the `payment_links` table). `schema.sql` includes both for new setups.

## Sale discounts
Discounts live in the **Discounts** drawer in `/admin.html`. Each rule is a percentage off everything that matches one of: a brand (Shopify `vendor`), a product type, a product tag, or a single product handle. Brand and product type match on part of the value, so a rule for `P&S` also covers `P&S Detail Products`, and one for `Polishers` covers `Rupes Polishers`, `Hi-Buff Polishers` and `RBL Polishers`.

**Add Black Friday rules** creates this year's sale in one press: 30% off polishers, 20% off P&S, 10% off Koch-Chemie, 10% off ceramic coatings (matched on `Ceramic`, which covers both `Ceramic & Paint Protection` and `Ceramic Coating`). Start and end dates are optional and run on Guam time, so a sale that ends on the 30th ends as the 30th ends in the store. Rules can be switched off or deleted without touching orders already placed.

Discounts never stack. Each line gets the single biggest rule that matches it, and a line whose price the Worker could not confirm against Shopify is never discounted — it stays at full price and the order is flagged for checking, same as before.

The checkout page asks the Worker for a quote rather than pricing the cart itself, so the saving a customer sees on the page is the one written onto the order. Orders carry `gross_cents`, `discount_cents` and a `discount_json` breakdown, and the order desk shows all three.

To put a one-off discount on a single order, open it in `/admin.html` and use the **Discount** box: a percentage or a dollar amount, plus a reason that goes into the order notes. It replaces any sale discount on that order and the new subtotal is what payment links and balances follow, so set it before sending a payment link.

## Merchant accounts
The **Merchants** drawer in `/admin.html` manages accounts for detailers and resellers: company, username, contact, email, phone, an optional catch-all discount percentage, and internal notes. Create the account there and give the merchant the username and password — they sign in from the **Merchant account** panel on the checkout page.

A signed-in merchant sees their own pricing, and their order records the company so it shows as `MERCHANT · <company>` in the order list. Merchant pricing does not stack with the sale: each line takes whichever is larger, so during Black Friday a 25% merchant account still gets 30% off polishers.

### Rate cards
Every account has its own rate card, set on the account in the Merchants drawer. A rate is a percentage off one brand, product type, tag or single product, so a card might read Koch-Chemie 5%, P&S 20%, Gtechniq 0%, The Rag Company 5%. There is no shared default: each account is set up on its own.

The most specific rate wins — one product beats a tag, which beats a product type, which beats a brand, which beats the account catch-all rate. A rate of **0% is meaningful**: it is how you say an account gets nothing off that brand, and it overrides the catch-all. A brand with no rate and no catch-all pays list price.

**Extra on top** adds a further percentage to every rate on the account, and it compounds rather than adding: 20% with 5% on top is 24% off, because the 5% comes off the already-discounted price. Leave it at 0 for accounts that do not have that arrangement.

### Set discounts
Each account shows the four standard rates as switches — Koch-Chemie (KCX) 5%, P&S 20%, Gtechniq 0%, The Rag Company (TRC) 5%. Click the ones an account gets, or **Give them all four**. Nothing needs typing; the rate card below the switches is for anything outside that set.

Gtechniq sits in the set at 0% on purpose. Switching it on is how you record that an account gets nothing off that brand, which then overrides any catch-all rate on the account.

### An extra percentage on one order
Open a merchant's order and use the **Extra percentage** box. It applies on top of that account's own rates **for that order only**, and it replaces whatever standing extra the account carries — set 3% on an order for an account with a standing 5% and the order gets 3%, not 8%.

It only touches products priced on the merchant's own rate. Anything that took the Black Friday price keeps it, so the sale is never discounted twice. The box tells you how many products on the order it will affect, and it refuses rather than doing nothing if that number is zero.

Where a sale rule and a merchant's own rate come to the same percentage, the line is recorded as the merchant's rate. The price is identical either way, but it means an extra percentage still applies to that line.

### Merchant invoices
The order desk has a **Merchant invoices** tile and filter showing only orders placed on a merchant account, whatever their status.

### Rent credit
Some merchants pay rent and want it set against an invoice. Open the order and use the **Rent credit** box: an amount and a note. It is not a discount — the goods keep their prices and the credit comes off what is owed, so it is recorded and shown on its own line, on the order and in the payment email. The amount due after it is the figure payment links and balances follow. There is no stored balance; you enter the credit per invoice.

Passwords are stored as PBKDF2-SHA256 hashes with a per-account salt and 25,000 rounds, which keeps a sign-in well inside a Worker's CPU budget; each account records the number of rounds its own hash was made with, so accounts created earlier keep working; session tokens are stored only as a hash and expire after 30 days. Changing a password or switching an account off signs that merchant out everywhere. Deleting an account leaves past orders and their company name untouched.
