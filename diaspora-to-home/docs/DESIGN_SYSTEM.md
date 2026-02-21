# Diaspora to Home — Design System

## Brand Colors

| Token | Hex | Usage |
|---|---|---|
| `--navy-dark` | `#231B4F` | Primary brand — hero bg, headers, footer |
| `--navy-medium` | `#3D325F` | Secondary navy — gradient transitions |
| `--purple-accent` | `#7170B4` | CTA buttons, highlights, links, badges |
| `--beige` | `#F5F1ED` | Section backgrounds |
| `--white` | `#FFFFFF` | Clean sections, card backgrounds |
| `--text-dark` | `#1a1a1a` | Primary body text |
| `--text-light` | `#666666` | Secondary/muted text |

### Extended Palette

| Token | Hex | Usage |
|---|---|---|
| `--success-green` | `#22C55E` | Success states, available badges |
| `--danger-red` | `#EF4444` | Favorited hearts, sold badges |
| `--gold-accent` | `#D4AF37` | Premium badges |
| `--beige-light` | `#FAF8F5` | Lighter beige variant |

## Typography

- **Headings:** Playfair Display, serif, weight 700
- **Body:** Montserrat, sans-serif, weight 400/600/700
- **Brand font (Orkney):** Montserrat is the closest Google Font match

### Google Fonts Import

```html
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@300;400;600;700;800&display=swap" rel="stylesheet">
```

## Navigation (Fixed Top — Every Page)

```
+-----------------------------------------------------+
| [Logo SVG]     About  Properties  Services          |
|                Resources  Contact    [Book a Call]   |
+-----------------------------------------------------+
```

- Fixed position, `top: 0`, `z-index: 1000`
- Background: white with subtle shadow on scroll
- Logo: Diaspora to Home SVG from GCS storage
- Logo height: 55-60px
- Nav links: Montserrat, 13px, weight 600, uppercase, letter-spacing 1px
- Hover: purple underline slides in from left
- CTA button "Book a Call": purple background, white text, uppercase
- Mobile: hamburger menu (3 lines), full-screen overlay with centered links
- Mobile menu overlay: navy-dark background, white links, animated entrance

## Footer (Every Page)

```
+-----------------------------------------------------+
| [Logo]              Quick Links    Services    Contact|
| Brief description   About          Discovery   Email |
|                     Properties     Consultation Phone |
|                     Services       Site Visit   Hours |
|                     Resources      Full Package       |
|                     Contact                           |
|                     Book a Call                       |
+---------+-------------------------------------------+
| (c) 2025 Diaspora to Home. All rights reserved.     |
|                               [Social Icons]         |
+-----------------------------------------------------+
```

- Background: `--navy-dark`
- 4-column grid (1-column on mobile)
- Typography: Montserrat, white/light text
- Social icons: Instagram, LinkedIn, Email
- Bottom bar: border-top separator, copyright + socials

## Section Pattern

Pages alternate between white and beige section backgrounds:

- **Section label:** Montserrat, 12-13px, weight 700, uppercase, letter-spacing 3px, `--purple-accent` color
- **Section title:** Playfair Display, `clamp(28px, 4vw, 40px)`, weight 700, `--navy-dark`
- **Section subtitle:** Montserrat, 16px, `--text-light`, max-width 640px, centered
- **Section padding:** 6rem 1.5rem (desktop), 4rem 1.25rem (mobile)

## Button Styles

### Primary CTA

- Background: `--purple-accent`
- Color: white
- Padding: 1rem 2.5rem
- Font: Montserrat, 14px, weight 700, uppercase, letter-spacing 1px
- Border-radius: 4px
- Hover: `--navy-dark` background, `translateY(-2px)`, enhanced shadow

### Secondary CTA

- Background: transparent
- Border: 2px solid `--navy-dark`
- Color: `--navy-dark`
- Same font specs as primary
- Hover: `--navy-dark` background, white text

### Outlined/Ghost (on dark backgrounds)

- Border: 2px solid white
- Color: white
- Hover: white background, `--navy-dark` text

## Spacing

| Property | Desktop | Mobile |
|---|---|---|
| Section padding | 6rem 1.5rem | 4rem 1.25rem |
| Container max-width | 1200px | 100% |
| Card border-radius | 10px | 10px |
| Button border-radius | 4px | 4px |

## Shadows

| Element | Shadow |
|---|---|
| Cards | `0 4px 20px rgba(0, 0, 0, 0.08)` |
| Cards (hover) | `0 8px 28px rgba(0, 0, 0, 0.1)` |
| Buttons | `0 4px 12px rgba(113, 112, 180, 0.3)` |
| Buttons (hover) | `0 6px 20px rgba(113, 112, 180, 0.4)` |

## Transitions

- Default: `all 0.3s ease`
- Cards: `all 0.35s ease`

## Breakpoints

| Name | Max-width |
|---|---|
| Tablet | 968px |
| Mobile | 600px |
| Small mobile | 480px |

## Architecture Rules

1. Each page is a **single self-contained HTML file** with inline CSS (`<style>`) and JS (`<script>`)
2. Every page includes the full navigation and footer
3. CSS variables declared in each page's `:root {}` block
4. Google Fonts import in each page's `<head>`
5. Mobile-first responsive design
6. Placeholder content uses `<!-- TODO: ... -->` comments
