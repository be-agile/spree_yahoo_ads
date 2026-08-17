# Yahoo! Ads conversion tracking for Spree Commerce

A Spree extension that lets you enable Yahoo! Ads conversion tracking (JS tag method)
per tenant (Store) from the Spree admin's Integrations screen.

It follows the same "engine + Spree Integrations screen" pattern as
`ba_spree_google_analytics` — enable it by entering your tracking keys (conversion ID
and label) in the admin, nothing else required.

## Tags emitted

- **Site general tag** (`head` on every page)
  Captures the `yclid` parameter into a first-party cookie (`_ycl_yjad`) on visits
  arriving with a yclid, using Yahoo's own tag.
- **Conversion tracking tag** (on order completion)
  Fires with the order amount embedded. Search ads (YSS) and display ads (YDA) are
  configured independently, and **when both are configured, both conversion types fire
  at the same time**.
  - YSS (search ads): `yss_conversion` / `yahoo_conversion_id` / `yahoo_conversion_label`
  - YDA (display ads): `ydn_conversion` / `yahoo_ydn_conv_io` / `yahoo_ydn_conv_label`

## Firing exactly once

The conversion tag relies on Spree's `order_just_completed?`, which only renders
`checkout_complete_partials` on the first paint of the order-complete page, so reloads
and back-navigation don't re-fire it. As a second guard, the client side also tracks
the order number in `localStorage` to prevent duplicate fires.

## Setup

1. Open `/admin/integrations`
2. Add "Yahoo Ads"
3. Enter the conversion ID and label for whichever of search ads (YSS) or display ads
   (YDA) you use, and save
   (you can fill in just one, or both at once to track both conversion types)

## Before going live

Search ads (YSS) and display ads (YDA) use different tag `type` values and parameter
names. This extension supports both through Yahoo! Ads' unified tag (`ytag.js`), but in
production you should still verify that the `type` and parameter names match **the tag
your tenant actually issued**.

## Testing

```bash
bundle exec rspec
```

If you use the factories, add this to your `spec_helper`:

```ruby
require 'spree_yahoo_ads/factories'
```

## Licence

AGPL-3.0-or-later. Copyright (c) 2026 be agile Co., Ltd.
