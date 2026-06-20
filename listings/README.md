# Diaspora to Home — Property Listings (Demo)

A standalone, self-contained demo of the property listings module: a catalogue
grid, an in-place detail view, and a "Find out more" enquiry form. Single HTML
file, no build step, no dependencies.

**Live demo (after deploy):** https://altitudeaico.github.io/lorrainewright/

## What's in it

- Property grid with "Off Plan" / "Sale" badges, price, and beds/baths/sqm.
- In-place detail view with image, map, tabs (Overview / Key Features / Mortgage),
  and CTAs.
- Verified vs Seller's-Listing badges.
- "Find out more" enquiry modal with validation.

## Demo-safe by default

This hosted version runs with `DEMO_MODE = true`, so the enquiry form **simulates
success and does not post to Lorraine's live CRM**. Demo submissions go nowhere —
safe to share publicly. (Open the browser console to see the captured payload.)

The listings shown are the six built-in **sample** properties, because
`LISTINGS_CSV_URL` is left as a placeholder.

## Deploy (GitHub Pages)

1. Put `index.html` in the repo root (`altitudeaico/lorrainewright`).
2. Go to **Settings → Pages**.
3. Source: **Deploy from a branch** · Branch: **main** · Folder: **/ (root)** · **Save**.
4. The site goes live at the URL above within ~60 seconds.

The repo must be **Public** for Pages on the free plan.

## Taking it live later

In `index.html`:

- Set `DEMO_MODE = false` to send real enquiries to the GHL webhook.
- Set `LISTINGS_CSV_URL` to your published Google Sheet CSV to show real listings
  instead of the samples.

## Note on production

This GitHub Pages page is a **demo / shareable POC**. The production listings on
Lorraine's actual website live as a custom-code block embedded in GHL, on her own
domain — not here.
