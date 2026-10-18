# Shopify cart bridge installation

1. Deploy this Worker and copy its URL, e.g. `https://stoich-provisions-orders.YOUR-SUBDOMAIN.workers.dev`.
2. In Shopify Admin → Online Store → Themes, duplicate the live theme first.
3. In Edit code, create a snippet named `cart-bridge` and paste `cart-bridge.liquid`.
4. Render the snippet near the cart checkout buttons, often in `sections/main-cart-footer.liquid`: `{% render 'cart-bridge' %}`. Theme files vary.
5. Replace `YOUR_WORKER_URL` in the snippet with the actual Worker URL.
6. Test with several products and variants, and confirm test requests appear in `/admin.html`.

The snippet reads Shopify's Ajax Cart API and passes a cart snapshot to the custom request form. This starter does not verify submitted prices server-side against Shopify, create a Shopify Admin order, reserve inventory, or collect payment. Keep it in testing until price verification and production protections are implemented.
