# Diaspora to Home — QA / QC Review

_Reviewer view: QA manager + product manager. Date: 2026-06-20._
_No formal acceptance criteria were set, so this judges usability, functional
feasibility, and the integrity of the handoffs between steps._

## Verdict in one line
The happy path works end-to-end and is genuinely impressive for the time spent —
**but it is not yet launch-ready for real sellers.** The gaps are not in the build;
they're in the *handoffs* (especially payment and notifications), in seller-facing
confirmation, and in basic data hygiene/governance.

## What works (verified)
- Seller form saves a structured record to the database. ✓
- Photos upload, show in vetting, and publish onto the listing. ✓
- Login gates the back-office; only approved emails can read personal data. ✓
- Vetting checklist enforces deal-breakers; verdict resolves correctly. ✓
- Approve publishes exactly one listing per submission (no duplicates). ✓
- Public page shows only published listings. ✓

---

## BLOCKERS — fix before any real seller uses it

**B1. Payment isn't reconciled with the submission.**
The form shows a "Pay $99" button, but nothing tells the system whether the seller
actually paid. A submission looks identical whether paid or not, so the team must
manually cross-check FastPayDirect/GHL before approving. Risk: approving unpaid
listings, or losing paid ones. _The pay→vet handoff is broken._
→ Need: payment status flows back to the submission (GHL/FastPayDirect webhook on
payment success → mark submission "paid"), and the workspace shows a paid/unpaid flag.

**B2. No notifications when a submission lands.**
Submissions sit silently until someone remembers to log in. This is the exact problem
Lorraine described ("lost leads over the weekend"). DTH-09 is parked.
→ Need: the lead-alert (DTH-09) is effectively a blocker, not a nice-to-have.

**B3. No confirmation to the seller.**
The seller only sees an on-screen message. If they close the tab, there's no receipt,
no record, no "what happens next." Combined with B1, a seller could pay and hear nothing.
→ Need: a confirmation email (submission received + payment receipt + next steps),
ideally via GHL.

**B4. Test data is live on the public site.**
Right now the public listings page shows 2 test listings (one with no photo), and there
are 4 test submissions in the system. These are publicly visible.
→ Need: purge test data before launch; agree a "no test data in prod" rule.

**B5. No privacy/consent notice on the form.**
It collects names, emails, phone numbers with no privacy statement or consent — a UK
GDPR exposure. (DTH-13 consent item, still open.)
→ Need: short privacy line + link, and a consent checkbox.

---

## SHOULD-FIX — needed for a trustworthy, operable product

**S1. Shared login = no audit attribution.** Every decision is recorded as
"admin@diasporatohome.com" — you can't tell which team member approved or rejected.
For a vetting/compliance process that's weak. → per-person logins, or at least capture
a reviewer name at decision time.

**S2. No audit history.** Only the *current* status + one timestamp are stored; there's
no log of changes over time (e.g. rejected → later approved). Weak for disputes/compliance.
→ a simple decisions/audit log table.

**S3. No listing management after publish.** No way to edit, unpublish, mark as sold, or
take down a listing from the UI — it requires direct database edits. Real operational need
(sold properties, fraud found later, typo fixes). → add manage/unpublish/mark-sold controls.

**S4. Thin form validation.** Email format isn't truly enforced (the check only tests
"not empty"); price and phone are free text; no max lengths; the same property can be
submitted repeatedly (no dedupe). → tighten validation; consider duplicate detection.

**S5. Decision → seller comms is manual.** "Request documents" and "Reject" only set a
status; nothing is actually sent. → wire these to GHL templates/tags.

**S6. Anonymous submission spam vector.** No captcha or rate limit; anyone can flood the
submissions table (and any future alert emails). → add a basic anti-abuse control.

---

## NICE-TO-HAVE / polish
- **N1.** Listings with no photo show a blank image area — add a placeholder.
- **N2.** Price is free text → odd inputs render oddly; no currency consistency.
- **N3.** Two reviewers on the same submission = last-write-wins, no lock/indicator.
- **N4.** Form errors show raw server text — unpolished, mild info leak.
- **N5.** No "what happens next / timeline" guidance for the seller.
- **N6.** "Schedule a Tour" isn't wired to a calendar yet (DTH-10) — buyers can't book.
- **N7.** Uploaded photos go to a random folder not tied to the submission — orphan risk
  if the insert fails after upload; harder to clean up.
- **N8.** Not yet tested on real mobile devices.

---

## Suggested mapping to the backlog
| Finding | Backlog |
|---|---|
| B1 payment reconciliation | NEW (depends on DTH-05) |
| B2 notifications | DTH-09 (re-prioritise to blocker) |
| B3 seller confirmation email | NEW (GHL) |
| B4 purge test data | NEW (pre-launch checklist) |
| B5 consent/privacy | DTH-13 (the open consent item) |
| S1 audit attribution / S2 audit log | DTH-13 / NEW |
| S3 listing management | NEW |
| S4 form validation | NEW |
| S5 decision comms | DTH-09 family |
| S6 spam control | NEW |
| N6 booking | DTH-10 |

## Recommended order
1. Purge test data (B4) — quick.
2. Lead alert + seller confirmation (B2/B3) — needs the GHL webhook; highest user impact.
3. Payment reconciliation (B1) — needs FastPayDirect/GHL payment webhook.
4. Consent line (B5) — quick.
5. Then audit attribution (S1/S2), listing management (S3), validation (S4).
