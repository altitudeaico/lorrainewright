# Diaspora to Home — Ghana Real Estate Investment Website

Website for **Lorraine Wright MBE**, a Ghana real estate investment consultant helping diaspora investors (UK/US/Canada-based Ghanaians) navigate property purchases in Ghana.

## Tech Stack

- **HTML / CSS / JS** — each page is a single self-contained file
- **Target platform:** GoHighLevel (GHL) — pages are pasted into GHL custom code blocks
- **Fonts:** Google Fonts (Playfair Display + Montserrat)
- **No build step required** — open any `.html` file directly in a browser

## Project Structure

```
diaspora-to-home/
├── README.md
├── .gitignore
├── pages/
│   ├── index.html              # Homepage (hero with gradient + video bg)
│   ├── about.html              # About Lorraine page
│   ├── services.html           # Service tiers & packages
│   ├── properties.html         # Property listings with filters
│   ├── resources.html          # Free resources hub
│   ├── contact.html            # Contact form & info
│   ├── book-a-call.html        # Calendly booking page
│   └── thank-you.html          # Dynamic confirmation page
├── assets/
│   ├── images/                 # Property/profile images
│   └── video/                  # Hero background video
├── docs/
│   ├── DESIGN_SYSTEM.md        # Design tokens, typography, color reference
│   ├── PAGE_INVENTORY.md       # Status of each page
│   ├── URL_STRUCTURE.md        # URL mapping (dev → production)
│   └── INTEGRATION_NOTES.md    # GHL, Calendly, analytics integration
└── shared/
    └── design-tokens.css       # CSS variables reference (copy-paste into pages)
```

## Local Preview

Open any page directly in your browser:

```bash
open pages/index.html
# or
open pages/about.html
```

No server or build tools required.

## Design System

See [docs/DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md) for the full design system including:

- Brand colors and CSS custom properties
- Typography (Playfair Display headings, Montserrat body)
- Navigation and footer patterns
- Button styles (Primary, Secondary, Ghost)
- Spacing, shadows, and transitions
- Responsive breakpoints (968px, 600px, 480px)

## Deployment

1. Open the target page HTML file
2. Copy the entire file contents
3. Paste into a GHL custom code block on the corresponding page
4. Update any placeholder URLs and TODO items

See [docs/INTEGRATION_NOTES.md](docs/INTEGRATION_NOTES.md) for platform integration details.

## TODO — Client Input Needed

- [ ] Real property images and descriptions
- [ ] Lorraine's professional photos
- [ ] Social media URLs (Instagram, LinkedIn)
- [ ] Calendly booking URL
- [ ] Google Analytics 4 property ID
- [ ] Real testimonial quotes and client names
- [ ] Background video for homepage hero
