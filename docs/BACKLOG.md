# Diaspora to Home — Property Listings Backlog

Stable IDs (`DTH-NN`) for the not-yet-built pieces of the property listings
solution, reconciled against what's already live in the prototype.

_Last updated: 2026-06-20 — DTH-16 delivered (awaiting sign-off); DTH-07 MVP built & deployed; DTH-04 in progress._

| ID | Item | Epic | Type | Pri | Status / notes | Depends on |
|---|---|---|---|---|---|---|
| DTH-01 | Wire live published-CSV URL into the site | Go-live | Build | P0 | Code ready; just needs the URL | — |
| DTH-02 | Enter real listings into the sheet | Go-live | Content | P0 | Replaces the 6 sample rows | — |
| DTH-03 | Load real property images to GHL media | Go-live | Content | P0 | Replace Unsplash placeholders | — |
| DTH-04 | Seller self-listing intake form | Supply & approval | Build | P1 | **In progress** — workspace now reads a live submissions CSV; build the form + paste the URL (see INTAKE-FORM-GUIDE.md) | — |
| DTH-05 | $99 listing payment flow | Supply & approval | Build (GHL) | P1 | — | DTH-04 |
| DTH-06 | AI listing triage + drafting | Supply & approval | Build (AI) | P1 | Raw facts to polished copy | DTH-16, DTH-13 |
| DTH-07 | Approval workspace | Supply & approval | Build | P1 | **MVP built & deployed** (vetting-workspace.html); demo data — real data via DTH-04 | DTH-16 |
| DTH-08 | Approve to auto-publish linkage | Supply & approval | Build | P1 | — | DTH-07 |
| DTH-09 | Internal team lead-alert email | Demand & conversion | Build (GHL) | P1 | Small; stops lost leads | — |
| DTH-10 | Wire "Schedule a Tour" to booking calendar | Demand & conversion | Build | P2 | Button inert today | — |
| DTH-11 | AI buyer first-reply on enquiry | Demand & conversion | Build (AI) | P2 | — | DTH-13 |
| DTH-12 | On-site AI assistant / search | Demand & conversion | Build (AI) | P3 | Later | — |
| DTH-13 | PII / consent / compliance control | Data & compliance | Build / Gov | P1 | Before AI touches lead data **and before real submissions sit behind the workspace** (login / GHL members area) | — |
| DTH-14 | Unified data / ops dashboard | Data & compliance | Build | P2 | Looker over Sheet + CRM | — |
| DTH-15 | Retire / relegate legacy third-party embed | Data & compliance | Migration | P2 | Cutover risk | — |
| DTH-16 | Documented vetting criteria | Operating model | Governance | P1 | **Delivered** (v1.0-rc) — awaiting Lorraine sign-off (LORRAINE-SIGNOFF.md) | — |
| DTH-17 | Ops owner role (BAU + lead SLA) | Operating model | Org / People | P2 | The "run" capability | — |
| DTH-18 | Metrics & management cadence | Operating model | Governance | P2 | So it can be measured | — |

## How to read it

- **P0 (DTH-01 to 03)** is the critical path to getting *what's already built*
  actually live. Nothing should jump ahead of these.
- **DTH-16** (vetting criteria) looks like soft governance but blocks the AI work:
  no triage or fast approval until "what makes a listing approvable" is written down.
- **DTH-13** (compliance) must land before any lead data flows through an AI call.
- **DTH-17 and DTH-18** are operating-model pieces, not dev tickets, but they're
  real work — the model fails without them.

## Priority key

- **P0** — required to go live with what's built
- **P1** — the core value gap (supply / approval side)
- **P2** — next
- **P3** — later / optional
