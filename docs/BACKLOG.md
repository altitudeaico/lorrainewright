# Diaspora to Home — Property Listings Backlog

Stable IDs (`DTH-NN`) for the property listings / seller-vetting solution.

_Last updated: 2026-06-20 (late) — back-office now live & verified end-to-end (login → vet → publish). DTH-04/07/08/13 done._

## Architecture note

Supabase is the single source of truth — `submissions` (private, has personal data)
and `listings` (public, vetted, no personal data), each protected by row-level security.
Each published listing is now linked to its submission (one submission = one listing).
GoHighLevel stays for CRM / nurture / the $99 payment. Google Sheets/CSV is being retired.

## Where we are right now

The seller form is live and writes to the database. The back-office is now **real**:
team logs in at /vetting/, sees live submissions, works the checklist, and an approval
publishes the property to the public listings table — verified working end to end.
The public listings page now reads from Supabase too, so an approval appears on the live site automatically. The core loop is closed.

| ID | Item | Type | Pri | Status (2026-06-20) | Depends on |
|---|---|---|---|---|---|
| DTH-01 | Wire live CSV URL into the site | Build | — | **Superseded** by the Supabase data layer | — |
| DTH-02 | Enter real listings | Content | P1 | Pending — into the Supabase `listings` table | — |
| DTH-03 | Real property images | Content/Build | P1 | **DONE** — sellers upload photos on the form; shown in vetting; published to listing | — |
| DTH-04 | Seller self-listing intake form | Build | P1 | **DONE & VERIFIED** — live at /submit/, writes to Supabase | — |
| DTH-05 | $99 listing payment flow | Build (GHL) | P1 | Pending | DTH-04 |
| DTH-06 | AI listing triage + drafting | Build (AI) | P1 | Pending — will consume vetting-rubric.json | DTH-16, DTH-13 |
| DTH-07 | Approval workspace (back-office) | Build | P1 | **DONE** — login + live submissions from Supabase at /vetting/ | DTH-13, DTH-16 |
| DTH-08 | Approve → auto-publish to listings | Build | P1 | **DONE & VERIFIED** — approval upserts one listing per submission | DTH-07 |
| DTH-09 | Internal team lead-alert email | Build (GHL) | P1 | Pending | — |
| DTH-10 | Wire "Schedule a Tour" to booking calendar | Build | P2 | Pending | — |
| DTH-11 | AI buyer first-reply on enquiry | Build (AI) | P2 | Pending | DTH-13 |
| DTH-12 | On-site AI assistant / search | Build (AI) | P3 | Later | — |
| DTH-13 | Login + PII / consent / compliance | Build / Gov | P1 | **DONE (login live & tested)** — housekeeping below | — |
| DTH-14 | Unified data / ops dashboard | Build | P2 | Pending | — |
| DTH-15 | Retire legacy third-party embed + Sheets/CSV | Migration | P2 | Public listings page now reads Supabase; legacy embed/Sheets still to retire | DTH-02, DTH-07 |
| DTH-16 | Documented vetting criteria | Governance | P1 | **Delivered (v1.0-rc)** — awaiting Lorraine sign-off | — |
| DTH-17 | Ops owner role (BAU + lead SLA) | Org / People | P2 | Pending | — |
| DTH-18 | Metrics & management cadence | Governance | P2 | Pending | — |

## DTH-13 — done, with housekeeping left
Done & verified: approved-team allowlist + RLS gating; shared login (admin/admin) created
in Supabase's secure user store; login confirmed working end-to-end (an approval wrote to
the database as the logged-in user).
Housekeeping still to do:
- ~~Change admin/admin~~ DONE — password changed from the default.
- Privacy / consent wording on the public form.

## Immediate next step
Core loop is live end-to-end (form -> vet -> approve -> public site). Next: add real
listings and photos (DTH-02/03), and change admin/admin before real seller data goes in.

## Housekeeping / open risks
- ~~admin/admin temporary~~ DONE — password changed from the default.
- Confirm the GitHub deploy token (PAT) is revoked.
- Retire the Google Sheets/CSV path (now redundant).

## Priority key
- P1 — core value gap (supply / approval side)
- P2 — next
- P3 — later / optional
