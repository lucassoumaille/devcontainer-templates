---
description: Payments and in-app purchases
---

- Choose the payment method by what is sold, and confirm the choice with the user before implementing:
  - Digital goods or features used in the app (subscriptions, premium, credits): Google Play Billing and Apple In-App Purchase are mandatory. Use `in_app_purchase` (official) or RevenueCat (`purchases_flutter`) if the project uses it.
  - Physical goods or real-world services (delivery, booking, tickets): use a payment provider (Stripe, Adyen, PayPal…) with its official SDK or a hosted checkout; store billing is not allowed for these.
- Never handle raw card data in the app; use the provider's UI components or hosted pages.
- Never ship a payment secret key in the app. The backend creates payment intents / sessions and holds the secret keys.
- Validate purchases server side (Play Developer API, App Store Server API, or the provider's webhooks) before granting access; the client result is not proof of payment.
- Handle pending, cancelled, refunded and restored purchases; subscriptions need a "Restore purchases" action on iOS.
- Test with Play license testers / internal testing track and the StoreKit sandbox; never test with real charges.
