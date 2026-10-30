# Shopify cart bridge installation

> `cart-bridge.liquid` below is the older button-on-cart-page approach. See "Current setup" at the end for what the store uses now.

1. Deploy this Worker and copy its URL, e.g. `https://stoich-provisions-orders.YOUR-SUBDOMAIN.workers.dev`.
2. In Shopify Admin → Online Store → Themes, duplicate the live theme first.
3. In Edit code, create a snippet named `cart-bridge` and paste `cart-bridge.liquid`.
4. Render the snippet near the cart checkout buttons, often in `sections/main-cart-footer.liquid`: `{% render 'cart-bridge' %}`. Theme files vary.
5. Replace `YOUR_WORKER_URL` in the snippet with the actual Worker URL.
6. Test with several products and variants, and confirm test requests appear in `/admin.html`.

The snippet reads Shopify's Ajax Cart API and passes a cart snapshot to the custom request form. This starter does not verify submitted prices server-side against Shopify, create a Shopify Admin order, reserve inventory, or collect payment. Keep it in testing until price verification and production protections are implemented.

## Current setup: order page with an embedded form (recommended)

The live store embeds `checkout.html` in an iframe on `/pages/checkout` and uses `checkout-page-bridge.liquid` (paste it into a Custom Liquid section on that page, below the iframe). The bridge:

- sends the Shopify cart to the form (`STOICH_SHOPIFY_CART`) when asked (`STOICH_REQUEST_SHOPIFY_CART`);
- applies quantity changes and removals made inside the form (`STOICH_CART_CHANGE {key, quantity}` → `/cart/change.js`) and sends back the updated cart, or `STOICH_CART_ERROR`;
- resizes the iframe to fit the form (`STOICH_FRAME_HEIGHT`).

Messages are only accepted from the Worker's origin, and the form only accepts messages from `https://aqlx.shop`. `/cart` redirects to `/pages/checkout`, and the theme blocks Shopify's own checkout buttons, so every order goes through this form.
