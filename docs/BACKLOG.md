# Diaspora to Home — Property Listings Backlog

Stable IDs (`DTH-NN`) for the property listings / seller-vetting solution.

_Last updated: 2026-06-20 (evening) — Supabase is now the backbone. DTH-04 done & verified. DTH-13 part-built. DTH-07 needs rewiring to Supabase._

## Architecture note (what changed today)

We moved off the Google Sheets / published-CSV approach. **Supabase is now the single
source of truth** — a real database with two tables (`submissions` = private seller
entries incl. personal details; `listings` = public, vetted listings, no personal data),
each protected by row-level security. GoHighLevel stays for CRM, nurture and the $99
payment. The Google Sheets/CSV layer is being retired (see DTH-15).

## Where we are right now (one-line)

The public seller form is **live and writing into the database**. The back-office
(vetting workspace) is built but still reads the old spreadsheet and has **no login on it
yet** — that's the immediate next job.

| ID | Item | Type | Pri | Status (2026-06-20) | Depends on |
|---|---|---|---|---|---|
| DTH-01 | Wire live CSV URL into the site | Build | — | **Superseded** by the Supabase data layer | — |
| DTH-02 | Enter real listings | Content | P1 | Pending — now goes into the Supabase `listings` table, not a sheet | — |
| DTH-03 | Real property images | Content | P1 | Pending — hosting TBD (Supabase Storage or GHL CDN) | DTH-02 |
| DTH-04 | Seller self-listing intake form | Build | P1 | **DONE & VERIFIED** — live at /submit/, writes to Supabase, test row confirmed | — |
| DTH-05 | $99 listing payment flow | Build (GHL) | P1 | Pending | DTH-04 |
| DTH-06 | AI listing triage + drafting | Build (AI) | P1 | Pending — will consume vetting-rubric.json | DTH-16, DTH-13 |
| DTH-07 | Approval workspace (back-office) | Build | P1 | **MVP built; NOT finished** — still reads old CSV, no login. Needs rewire to Supabase + login box | DTH-13, DTH-16 |
| DTH-08 | Approve → auto-publish to listings | Build | P1 | Pending | DTH-07 |
| DTH-09 | Internal team lead-alert email | Build (GHL) | P1 | Pending | — |
| DTH-10 | Wire "Schedule a Tour" to booking calendar | Build | P2 | Pending — button inert today | — |
| DTH-11 | AI buyer first-reply on enquiry | Build (AI) | P2 | Pending | DTH-13 |
| DTH-12 | On-site AI assistant / search | Build (AI) | P3 | Later | — |
| DTH-13 | Login + PII / consent / compliance | Build / Gov | P1 | **IN PROGRESS** — see breakdown below | — |
| DTH-14 | Unified data / ops dashboard | Build | P2 | Pending | — |
| DTH-15 | Retire legacy third-party embed + Sheets/CSV layer | Migration | P2 | Pending | DTH-02, DTH-07 |
| DTH-16 | Documented vetting criteria | Governance | P1 | **Delivered (v1.0-rc)** — awaiting Lorraine sign-off (LORRAINE-SIGNOFF.md) | — |
| DTH-17 | Ops owner role (BAU + lead SLA) | Org / People | P2 | Pending | — |
| DTH-18 | Metrics & management cadence | Governance | P2 | Pending | — |

## DTH-13 breakdown (the login / security item)

Done & verified today:
- Database access-lock built: an approved-team list, with every "team read/edit" rule
  gated so it only works for emails on that list. List itself sealed from outside access.
- Security scan clean of real holes (2 remaining notices are correct-by-design).
- One **shared login created** in Supabase's secure user store: username `admin`,
  password `admin` (stored hashed). Verified the account is well-formed.

Still to do:
- Put the **login box on the workspace** and wire it to Supabase (this is also what
  finishes DTH-07). Until this exists, the admin/admin login can't actually be used anywhere.
- Test the login end-to-end once the box is up.
- **Change admin/admin** before any real seller's details go into the system.
- Consent / privacy wording on the public form.

## Immediate next step

Finish DTH-07: build the login box onto the vetting workspace and point it at Supabase,
so admin/admin gets the team into a screen showing the real submissions.

## Housekeeping / open risks
- admin/admin is temporary — must change before real PII.
- Confirm the GitHub access token (PAT) used for deploys has been **revoked**.
- Google Sheets/CSV path now redundant — retire once the workspace reads Supabase.

## Priority key
- P1 — core value gap (supply / approval side)
- P2 — next
- P3 — later / optional
