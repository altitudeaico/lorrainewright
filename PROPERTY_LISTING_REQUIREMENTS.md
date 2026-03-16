# 🏘️ Property Listing System - Requirements from Meeting

## 📋 **LORRAINE'S REQUIREMENTS (March 11, 2026 Meeting)**

### **Two Types of Property Listings:**

#### **1. Lorraine's Vetted Portfolio (Independent Listings)**
- Properties that Lorraine has personally vetted and verified
- Will have a **"Vetted by Lorraine"** badge/label
- These are her curated, premium listings
- Complete trust and verification

#### **2. Seller Listings (User-Submitted)**
- Property owners can submit their own properties
- Subject to Lorraine's approval process
- Will have a **"Seller's Listing"** badge/label
- Differentiated from Lorraine's vetted portfolio

---

## 🔄 **SELLER SUBMISSION WORKFLOW:**

### **Current Manual Process (Pain Point):**
❌ Sellers fill out form on "sell your property" page
❌ Lorraine manually processes submissions
❌ Lorraine manually creates listings
❌ Time-intensive, not scalable

### **Desired Automated Process:**
✅ Sellers submit property details via form
✅ Sellers upload photos directly
✅ Sellers provide description, location, price
✅ **Payment: $99 listing fee** (upfront)
✅ **Approval workflow** - Lorraine reviews and approves
✅ Once approved → property goes live automatically
✅ Badge: "Seller's Listing" (vs "Vetted by Lorraine")

---

## 💰 **PRICING MODEL:**

**Listing Fee:** $99 (suggested initial price)
- Pay upfront to submit listing
- Subject to approval
- Once approved, listing goes live

**Lorraine's Commission Model:**
- Upfront fee to list + 3% commission on sale
- Budget tiers for marketing campaigns:
  - $500-$1,000 for one-off post
  - $1,000-$4,000 for month campaign
  - $5,000+ for multiple months

---

## 📝 **REQUIRED PROPERTY INFORMATION:**

From the "Sell Your Property" page, submissions need:

1. **Size of Land** - Exact plot dimensions
2. **Property Documentation** - Land title verification
3. **Asking Price** - Final price
4. **Additional Features** - Amenities, unique selling points
5. **Photos** - Multiple images
6. **Description** - Property details
7. **Location** - Exact location in Ghana
8. **Age of Property** - Approximate age
9. **Lease Remaining** - If applicable
10. **Property in seller's name?** - Yes/No verification

---

## 🎨 **THIRD-PARTY EMBEDDED LISTINGS:**

**Current Setup:**
- Third-party site embedded on diasporatohome.com
- Shows listings with:
  - Picture
  - Location
  - Request viewing option
  - Description

**Lorraine's Feedback:**
- ❌ Dissatisfied with third-party layout/design
- ✅ Wants her own branded experience
- ✅ Wants more control over presentation

**Proposed Solution:**
- Build custom property listing system
- Match or exceed third-party functionality
- Brand-aligned design
- Full control over user experience

---

## 🛠️ **TECHNICAL APPROACH OPTIONS:**

### **Option A: Third-Party Tool/Plugin**
**Pros:**
- Faster implementation
- Potentially free or low-cost
- Pre-built features

**Cons:**
- Limited customization
- Ongoing subscription costs
- Lorraine's specific workflow may not fit
- Less control

### **Option B: Custom-Built Application (Recommended)**
**Pros:**
- Perfect fit for Lorraine's exact workflow
- Complete control over features
- No ongoing subscription fees
- Scalable for future growth
- Can integrate payment processing ($99 fee)
- Can build approval workflow
- Custom branding

**Cons:**
- Requires backend hosting
- Not part of GHL (separate system)
- Initial build time
- Needs maintenance

**Decision from Meeting:**
✅ Build custom app - cost comparable or less than third-party
✅ Would involve backend hosting
✅ Acknowledged as main unknown/core feature

---

## 🎯 **KEY FEATURES NEEDED:**

### **1. Dual Listing System:**
- [ ] Lorraine's vetted properties (admin-created)
- [ ] Seller-submitted properties (user-created, approval-required)
- [ ] Clear visual differentiation (badges/labels)

### **2. Seller Submission Portal:**
- [ ] Public-facing form for sellers
- [ ] File upload for photos (multiple images)
- [ ] All required fields (size, price, location, etc.)
- [ ] Payment integration ($99 fee)
- [ ] Submission confirmation

### **3. Approval Workflow:**
- [ ] Admin dashboard for Lorraine
- [ ] View pending submissions
- [ ] Approve/Reject with notes
- [ ] Approved listings go live automatically
- [ ] Rejected submissions - refund handling?

### **4. Property Display:**
- [ ] Grid/card layout (like current design)
- [ ] Property detail pages
- [ ] Image gallery
- [ ] Request viewing CTA
- [ ] Contact Lorraine button
- [ ] Filter by location, price, type
- [ ] Search functionality

### **5. Admin Management:**
- [ ] Add/edit/delete Lorraine's vetted properties
- [ ] Manage seller submissions
- [ ] View analytics (views, inquiries)
- [ ] Export property list

### **6. Payment Processing:**
- [ ] $99 listing fee collection
- [ ] Stripe/PayPal integration
- [ ] Receipt generation
- [ ] Refund capability (if needed)

---

## 📊 **DATA STRUCTURE:**

### **Property Schema:**
```
Property {
  id: unique_id
  type: "vetted" | "seller"
  status: "pending" | "approved" | "rejected" | "live"
  
  // Basic Info
  title: string
  description: text
  price: number
  location: string
  size: string
  
  // Property Details
  bedrooms: number
  bathrooms: number
  property_type: "land" | "villa" | "apartment" | "estate"
  property_age: number
  lease_remaining: number
  amenities: array
  
  // Media
  images: array of image URLs
  featured_image: URL
  
  // Seller Info (if seller listing)
  seller_name: string
  seller_email: string
  seller_phone: string
  
  // Verification
  land_title_verified: boolean
  documentation: array of doc URLs
  
  // Admin
  created_by: "lorraine" | "seller"
  submitted_at: timestamp
  approved_at: timestamp
  approved_by: user_id
  
  // Payment
  listing_fee_paid: boolean
  payment_id: string
  amount_paid: number
}
```

---

## 🚀 **IMPLEMENTATION PHASES:**

### **Phase 1: MVP (Minimum Viable Product)**
1. Display Lorraine's vetted properties (admin-added)
2. Basic property detail pages
3. Seller submission form
4. $99 payment integration
5. Basic approval dashboard for Lorraine

### **Phase 2: Enhanced Features**
6. Advanced filtering/search
7. Email notifications (submission, approval)
8. Property analytics
9. Image optimization
10. Third-party embedded listings integration

### **Phase 3: Advanced**
11. Seller dashboard (view their listings)
12. Automated marketing campaigns
13. CRM integration
14. Lead tracking
15. ROI calculators

---

## 💡 **RECOMMENDATION:**

Build a **custom property listing application** using:

**Frontend:**
- React or Vue.js for dynamic property cards
- Integrates with existing GHL pages
- Hosted on Vercel/Netlify (free tier)

**Backend:**
- Firebase (easy, scalable, generous free tier)
  - Firestore for database
  - Firebase Storage for images
  - Firebase Auth for admin login
  - Firebase Functions for approval workflow
- Or Supabase (open-source alternative)

**Payment:**
- Stripe Checkout for $99 fee
- Simple integration
- Handles refunds

**Cost Estimate:**
- Development: One-time build
- Hosting: Free tier (Firebase/Vercel)
- Payment processing: Stripe fees only (2.9% + $0.30)
- Total monthly cost: ~$0-$10 (just payment fees)

**Timeline:**
- MVP: 2-3 days development
- Full featured: 1 week
- Testing & refinement: 3-5 days

---

## ✅ **NEXT STEPS:**

1. **Decision:** Confirm custom build approach
2. **Design:** Create property listing UI mockup
3. **Setup:** Firebase project + Stripe account
4. **Build:** Start with MVP features
5. **Test:** Lorraine tests approval workflow
6. **Launch:** Go live with vetted properties first
7. **Enable:** Open seller submissions

**Ready to start building?**
