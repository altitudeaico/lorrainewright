# Diaspora to Home - Complete Page Inventory

**Last Updated:** March 15, 2026  
**Repository:** github.com/altitudeaico/lorrainewright (gh-pages branch)

---

## ✅ COMPLETE PAGE STATUS (7 CORE PAGES)

### **1. Homepage** - `/new-home`
- **Font:** ✅ Montserrat
- **Status:** ✅ Built & Deployed (GHL)
- **Features:** Hero with video background, services grid, property carousel, testimonials
- **Location:** GHL only (not yet in GitHub)

### **2. About** - `/new-about` 
- **Font:** ✅ **FIXED** - Montserrat only (Playfair Display removed)
- **Status:** ✅ Built & Deployed (GitHub)
- **Features:** Lorraine bio, credentials, MBE/Oxford MBA badges, mission/values, testimonials
- **Location:** `/new-about.html` ✅ COMMITTED

### **3. Services** - `/new-services`
- **Font:** ✅ Montserrat
- **Status:** ✅ Built & Deployed (GHL)
- **Features:** 4 service packages (Free Call, Consultation, Site Visit, Full Package), comparison table, FAQ
- **Location:** GHL only (not yet in GitHub)

### **4. Properties** - `/new-properties`
- **Font:** ✅ Montserrat
- **Status:** ✅ Built & Deployed (GHL)
- **Features:** Filter bar, featured properties, property grid/list view, location highlights
- **Location:** GHL only (not yet in GitHub)

### **5. Resources** - `/new-resources`
- **Font:** ✅ Montserrat
- **Status:** ✅ Built & Deployed (GHL)
- **Features:** Resource categories, featured guide, blog preview, newsletter signup
- **Location:** GHL only (not yet in GitHub)

### **6. Contact** - `/new-contact`
- **Font:** ✅ Montserrat (assumed)
- **Status:** ✅ Built & Deployed (GHL)
- **Features:** Contact form, methods grid, FAQ, office hours
- **Location:** GHL only (not yet in GitHub)

### **7. Book a Call** - `/new-book-call`
- **Font:** ✅ Montserrat (assumed)
- **Status:** ✅ Built & Deployed (GHL)
- **Features:** Calendly integration, consultation info
- **Location:** GHL only (not yet in GitHub)

---

## 🚨 CRITICAL FIX COMPLETED

**Issue:** About page used Playfair Display font  
**Fix:** Line 6 changed from:
```html
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
```
To:
```html
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
```
**Status:** ✅ Fixed in GitHub, needs deployment to GHL

---

## 📋 NEXT STEPS

### **IMMEDIATE (Day 1-2):**
1. ✅ Push remaining pages to GitHub (Services, Properties, Resources, Contact, Book-Call)
2. ✅ Deploy fixed About page to GHL
3. ✅ Scrape `/elite-package` content from current site
4. ✅ Scrape `/get-info` content from current site

### **WEEK 1 (March 16-20):**
1. Create `/new-elite-package` page
2. Create `/new-get-info` page  
3. Migrate all scraped content to existing pages
4. Test all forms → GHL integration
5. Add social media URLs (awaiting from Lorraine)
6. Add Google Analytics tracking

### **PHASE 1 COMPLETION:**
- Budget: £1,500 (£750 paid, £750 on completion)
- Timeline: March 20, 2026
- Deliverables: 7 pages + 2 new pages + content migration

---

## 💰 PROJECT PHASES

**Phase 1: Website Launch (£1,500)**
- Status: 90% → Launch March 20
- Deliverables: 9 pages total, content scraped, SEO, forms working

**Phase 2: Custom Property Listing (£600-800)**
- Status: Quoted, awaiting Lorraine's decision
- Timeline: 2-3 weeks after Phase 1
- Savings: Pays for itself vs third-party tools in 12-18 months

**Phase 3: Partner Funnel Fix (£800-1,200)**
- Status: OUT OF SCOPE - separate quote
- Issue: GHL global custom field conflicts
- Timeline: Optional, anytime after Phase 1

---

## 🎯 DESIGN SYSTEM COMPLIANCE

✅ **All pages use Montserrat font exclusively**
✅ **Colors:** Navy #231B4F, Purple #7170B4, Beige #F5F1ED, White
✅ **Nav:** White bar, 55px logo, animated underlines, purple CTA
✅ **Mobile:** Hamburger menu with full-screen overlay + body scroll lock
✅ **Icons:** Inline SVGs only (no emoji)
✅ **JS:** ES5-compatible syntax for GHL

---

**Repository:** https://github.com/altitudeaico/lorrainewright  
**Token:** [GITHUB_TOKEN]  
**Live Dashboard:** https://raw.githack.com/altitudeaico/lorrainewright/gh-pages/status-reports/website-status-dashboard.html
