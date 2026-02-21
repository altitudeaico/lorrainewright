# Diaspora to Home — Integration Notes

## GHL (GoHighLevel) — Primary Platform

- Pages are pasted as custom HTML into GHL page builder
- GHL handles: CRM, email automation, form submissions, lead management
- GHL native courses feature available for future online courses

## Calendly — Call Booking

- Embed widget on Book a Call page
- Lorraine needs to set up her Calendly account and provide the URL
- Widget code is commented out in the HTML, ready to activate

## Google Analytics 4 — Tracking

- Add GA4 tracking code to all pages
- Track: page views, form submissions, call bookings, resource downloads, property clicks, filter usage, social clicks
- **TODO:** GA4 property ID needed from client

## Property Listing Management (Future)

- Options evaluated: SpreadSimple ($16/mo, Google Sheets-based) or CommonNinja (GHL widget embed)
- Current approach: static HTML property cards with client-side JS filtering
- Future: connect to external data source for dynamic listings

## Email Service

- GHL native email for form confirmations and nurture sequences
- Newsletter signup forms on Resources and Thank You pages connect to GHL

## External Assets

| Asset | URL |
|---|---|
| Logo SVG | `https://storage.googleapis.com/msgsndr/MUCiWTChkVoaPw8fdKXQ/media/697fcf7d1f68d180d5d05279.svg` |
| Lorraine cutout image | `https://storage.googleapis.com/msgsndr/MUCiWTChkVoaPw8fdKXQ/media/69781d3ba87beb2aa5274e02.png` |

### Logo URLs (All Variants)

```
https://storage.googleapis.com/msgsndr/MUCiWTChkVoaPw8fdKXQ/media/697fcf7d1311f66db773b2e9.png
https://storage.googleapis.com/msgsndr/MUCiWTChkVoaPw8fdKXQ/media/697fcf7d1311f6764a73b2ef.png
https://storage.googleapis.com/msgsndr/MUCiWTChkVoaPw8fdKXQ/media/697fcf7d1311f68fa973b2ec.png
https://storage.googleapis.com/msgsndr/MUCiWTChkVoaPw8fdKXQ/media/697fcf7d1311f6181273b2eb.png
https://storage.googleapis.com/msgsndr/MUCiWTChkVoaPw8fdKXQ/media/697fcf7d1311f63db773b2ea.png
https://storage.googleapis.com/msgsndr/MUCiWTChkVoaPw8fdKXQ/media/697fcf7d1311f67f2a73b2ed.png
https://storage.googleapis.com/msgsndr/MUCiWTChkVoaPw8fdKXQ/media/697fcf7d1f68d11215d05282.png
https://storage.googleapis.com/msgsndr/MUCiWTChkVoaPw8fdKXQ/media/697fcf7d1f68d114aad0527a.png
https://storage.googleapis.com/msgsndr/MUCiWTChkVoaPw8fdKXQ/media/697fcf7d1f68d180d5d05279.svg
https://storage.googleapis.com/msgsndr/MUCiWTChkVoaPw8fdKXQ/media/697fcf7df7a877914efe2506.svg
```
