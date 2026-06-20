# Diaspora to Home — Property Listings Backlog

Stable IDs (`DTH-NN`) for the property listings / seller-vetting solution.

_Last updated: 2026-06-20 (end of day) — full supply loop live: submit → pay → vet → approve → public site. DTH-03/04/05/07/08/13 done._

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

## QA blockers (from QA-REVIEW.md) — progress
- **B4 purge test data — DONE.** Database emptied; public site shows no listings.
- **B5 consent/privacy — DONE.** Required consent checkbox on the form (privacy-link slot ready).
- **B1 payment reconciliation — PART DONE.** Workspace now shows Paid/Unpaid, team can mark paid,
  and approving an unpaid listing requires confirmation. Auto-reconciliation needs a GHL
  "payment received" webhook (to mark paid automatically) — pending.
- **B2 lead alert — BUILT & DORMANT.** DB pings GHL on each submission; needs the GHL inbound
  webhook URL to switch on.
- **B3 seller confirmation — PART DONE.** On-screen "what happens next" is in place; the
  confirmation *email* is sent by the same GHL workflow (needs the webhook URL).

**One unlock for B2 + B3 (+ a path for B1-auto): create the GHL inbound webhook and send the URL.**

| ID | Item | Type | Pri | Status (2026-06-20) | Depends on |
|---|---|---|---|---|---|
| DTH-01 | Wire live CSV URL into the site | Build | — | **Superseded** by the Supabase data layer | — |
| DTH-02 | Enter real listings | Content | P1 | **Blocked — needs real property data from Lorraine** | Lorraine |
| DTH-03 | Real property images | Content/Build | P1 | **DONE** — sellers upload photos on the form; shown in vetting; published to listing | — |
| DTH-04 | Seller self-listing intake form | Build | P1 | **DONE & VERIFIED** — live at /submit/, writes to Supabase | — |
| DTH-05 | $99 listing payment flow | Build (GHL) | P1 | **DONE** — $99 GHL payment link live on the form's success screen | — |
| DTH-06 | AI listing triage + drafting | Build (AI) | P1 | Pending — will consume vetting-rubric.json | DTH-16, DTH-13 |
| DTH-07 | Approval workspace (back-office) | Build | P1 | **DONE** — login + live submissions from Supabase at /vetting/ | DTH-13, DTH-16 |
| DTH-08 | Approve → auto-publish to listings | Build | P1 | **DONE & VERIFIED** — approval upserts one listing per submission | DTH-07 |
| DTH-09 | Internal lead-alert via GHL | Build (GHL) | P1 | **Built & dormant.** DB->GHL ping trigger is live; activate by setting the GHL inbound webhook URL. Covers B2 alert + B3 seller email via the GHL workflow | GHL webhook URL |
| DTH-10 | Wire "Schedule a Tour" to booking calendar | Build | P2 | Pending | — |
| DTH-11 | AI buyer first-reply on enquiry | Build (AI) | P2 | Pending | DTH-13 |
| DTH-12 | On-site AI assistant / search | Build (AI) | P3 | Later | — |
| DTH-13 | Login + PII / consent / compliance | Build / Gov | P1 | **DONE (login live & tested)** — housekeeping below | — |
| DTH-14 | Unified data / ops dashboard | Build | P2 | Pending | — |
| DTH-15 | Retire legacy third-party embed + Sheets/CSV | Migration | P2 | Public listings page now reads Supabase; legacy embed/Sheets still to retire | DTH-02, DTH-07 |
| DTH-16 | Documented vetting criteria | Governance | P1 | **Delivered (v1.0-rc)** — awaiting Lorraine sign-off | — |
| DTH-17 | Ops owner role (BAU + lead SLA) | Org / People | P2 | Pending | — |
| DTH-18 | Metrics & management cadence | Governance | P2 | Pending | — |

## DTH-13 — done
Allowlist + RLS gating; shared login created & tested; password changed from default;
consent checkbox added to the public form (B5). Audit attribution (per-person logins) is
a should-fix in the QA review, not a blocker.

## Done so far (the whole supply engine)
Seller form (DTH-04) → $99 payment (DTH-05) → secured database + login (DTH-13) →
vetting workspace (DTH-07) → approve-to-publish (DTH-08) → photos (DTH-03) →
public listings page reading Supabase. All live and verified end-to-end.

## Immediate next step
The build side is essentially complete. Remaining items wait on external inputs (below).
The only thing buildable without an input is DTH-10 (Schedule-a-Tour → booking calendar),
and even that needs the booking link to actually go live.

## Waiting on inputs
- **From GHL (Bolaji):** inbound webhook URL for lead alerts (DTH-09); booking-calendar
  link if we wire "Schedule a Tour" (DTH-10).
- **From Lorraine:** her real property listings + photos (DTH-02); sign-off on the
  vetting criteria (DTH-16).

## Housekeeping / open risks
- ~~admin/admin temporary~~ DONE — password changed from the default.
- Confirm the GitHub deploy token (PAT) is revoked.
- Retire the Google Sheets/CSV path (now redundant).

## Priority key
- P1 — core value gap (supply / approval side)
- P2 — next
- P3 — later / optional
