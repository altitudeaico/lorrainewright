# Seller intake form — setup guide

**Backlog item:** DTH-04 (seller intake) → feeds DTH-07 (the vetting workspace)
**Who does this:** you can do all of it yourself — it's clicking, no code.
**Time:** about 30–40 minutes.

The goal: a form sellers fill in → answers land in a Google Sheet → the vetting workspace reads that sheet and shows them as a queue. Right now the workspace shows three fake samples; when you finish this, it shows real submissions.

There is **one important safety rule** at the end (Step 5) — please don't skip it.

---

## Step 1 — Create the form

1. Go to **forms.google.com** and click the **+** to start a blank form.
2. Name it **"List your property — Diaspora to Home."**
3. Add the questions below. For each one: click **Add question**, type the **title exactly as written in bold** (the wording matters — the workspace looks for these names), and set the **type** shown.

| Question title (type this exactly) | Type | Notes |
|---|---|---|
| **Property title** | Short answer | e.g. "3-bed townhouse, East Legon" |
| **Location** | Short answer | Area and city |
| **Price** | Short answer | e.g. $120,000 |
| **Type** | Multiple choice | Two options: `Completed`, `Off-plan` |
| **Seller name** | Short answer | |
| **Seller role** | Multiple choice | Options: `Owner`, `Developer`, `Agent` |
| **Email** | Short answer | |
| **Phone** | Short answer | |
| **Company** | Short answer | Leave optional |
| **Land tenure** | Multiple choice | Options: `Private / leasehold`, `Stool land`, `Family land` |
| **Title or deed** | File upload | Let them upload the document |
| **Search report** | File upload | Lands Commission search, if they have it |
| **Site plan** | File upload | |
| **Photos** | File upload | Allow up to 5 files |
| **Building permit** | File upload | For off-plan only |
| **Payment method** | Paragraph | "How should a buyer pay you?" |
| **Disputes** | Multiple choice | Options: `Yes`, `No` — "Any ongoing dispute over this land?" |

> Tip: file-upload questions ask people to sign in to Google. That's normal and fine.

---

## Step 2 — Connect the form to a sheet

1. In the form, click the **Responses** tab at the top.
2. Click the green **Link to Sheets** icon.
3. Choose **Create a new spreadsheet** and accept. A Google Sheet opens.

From now on, every form submission becomes a new row in that sheet automatically. The column headers will match your question titles — which is exactly why the titles had to be typed precisely.

---

## Step 3 — Check it works

1. Open your form, click **Preview** (the eye icon), and submit one test entry.
2. Go back to the linked sheet — your test row should appear.

If it does, the pipe from form → sheet is working. (You can delete the test row later.)

---

## Step 4 — Publish the sheet as a link the workspace can read

1. In the sheet: **File → Share → Publish to web.**
2. In the dialog, choose the response tab, and in the format dropdown pick **Comma-separated values (.csv)**.
3. Click **Publish**, confirm, and **copy the link** it gives you.
4. Send me that link, or paste it yourself: open `vetting-workspace.html`, find the line near the top that says
   `var SUBMISSIONS_CSV_URL = "";`
   and put the link between the quotes. Save. That's the only edit.

The workspace will now show real submissions instead of the samples. The header strip will say "Live · N submission(s)" so you know it's reading real data.

---

## Step 5 — ⚠️ The safety rule (do this before real sellers use it)

Real submissions contain people's names, phone numbers, and uploaded documents. The workspace is currently a **public web page**. **Do not put real submissions behind a public page.**

Before you share the form with actual sellers, the workspace needs to sit **behind a login** — the cleanest option is to host it inside your GoHighLevel members area so only you and your team can open it. I'll help set that up (it's the compliance item, DTH-13). Until that's done, keep using the demo samples — they're fake, which is why the public demo link is safe.

---

## What this does and doesn't do (so there are no surprises)

- **Does:** sellers submit → you see them in the workspace queue → you review and decide.
- **Doesn't yet:** clicking a decision does not auto-publish to the website. For now you set the **Badge** column in your *listings* sheet by hand (the workspace tells you exactly what to set). Making that automatic is a later item (DTH-08).
- The **Submissions** sheet (this one) and the **Listings** sheet (the one that powers the public property grid) are two different sheets. Sellers go into Submissions; only approved properties get copied into Listings.
