# Diaspora to Home — URL Structure

## Development to Production URL Mapping

| Development (GHL) | Production | Page |
|---|---|---|
| `/new-home` | `/` | Homepage |
| `/new-about` | `/about` | About |
| `/new-services` | `/services` | Services |
| `/new-properties` | `/properties` | Properties |
| `/new-resources` | `/resources` | Resources |
| `/new-contact` | `/contact` | Contact |
| `/new-book-call` | `/book-a-call` | Book a Call |
| `/new-thankyou` | `/thank-you` | Thank You |

## Notes

- The `/new-` prefix is used during development to avoid conflicts with existing live pages on GHL
- When ready to go live, pages are migrated to production URLs
- **Navigation links within pages use production URLs** (e.g., `/about`, `/services`) since these will be the final URLs
