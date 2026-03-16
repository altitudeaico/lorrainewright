# 🚀 CUSTOM PARTNER FUNNEL SOLUTION - ARCHITECTURE

**Date:** March 16, 2026  
**Project:** Multi-Partner Funnel System  
**Client:** Lorraine Wright MBE  
**Approach:** Custom App (Supabase + Admin Interface) + GHL Integration

---

## 🎯 THE VISION:

Build a **standalone partner funnel management system** that:
1. Lives OUTSIDE GHL (no constraints)
2. Has admin interface for Lorraine to manage partners
3. Integrates WITH GHL for tagging and automation triggers
4. Handles social media triggers
5. Scales to unlimited partners/properties

**NO GHL LIMITATIONS. FULL CONTROL. UNLIMITED SCALE.**

---

## 🏗️ SYSTEM ARCHITECTURE:

### **Stack:**
- **Database:** Supabase (PostgreSQL)
- **Backend:** Supabase Edge Functions (Deno/TypeScript)
- **Frontend Admin:** React/Next.js (hosted on Vercel)
- **Public Forms:** Embedded HTML widgets (works anywhere)
- **Integration:** GHL API for contact tagging and automation triggers
- **Social Media:** ManyChat or custom webhook integration

### **Components:**

```
┌─────────────────────────────────────────────────────────────┐
│                    LORRAINE'S ADMIN PANEL                    │
│  (React App - lorraine-admin.diasporatohome.com)           │
│                                                              │
│  • Add/Edit Partners                                        │
│  • Create Property Listings per Partner                     │
│  • Design Custom Forms (visual tile selector)               │
│  • Configure Automation Flows                               │
│  • View Analytics/Submissions                               │
│  • Test Forms Before Publishing                             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                      SUPABASE DATABASE                       │
│                                                              │
│  Tables:                                                     │
│  • partners (partner info, branding)                        │
│  • properties (property details, images)                    │
│  • forms (generated forms config)                           │
│  • submissions (all form submissions)                       │
│  • automation_rules (what happens per property)             │
│  • social_triggers (keyword → form mapping)                 │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    PUBLIC-FACING FORMS                       │
│  (Embeddable widgets - go anywhere)                         │
│                                                              │
│  • Partner-specific landing pages                           │
│  • Visual property tile selection                           │
│  • Smart form capture                                       │
│  • Real-time validation                                     │
│  • Mobile-optimized                                         │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                   INTEGRATION LAYER                          │
│  (Supabase Edge Functions + Webhooks)                       │
│                                                              │
│  When form submitted:                                       │
│  1. Save to Supabase                                        │
│  2. Send to GHL API (create/update contact)                 │
│  3. Apply GHL tags based on property selection              │
│  4. Trigger specific GHL automation via tag                 │
│  5. Log everything for analytics                            │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    GOhighlevel (GHL)                         │
│                                                              │
│  • Receives tagged contacts                                 │
│  • Automation triggered by tag                              │
│  • Sends property-specific email sequence                   │
│  • All existing GHL workflows work                          │
│  • Lorraine manages follow-up in GHL                        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                  SOCIAL MEDIA INTEGRATION                    │
│                                                              │
│  • ManyChat/Instagram DM automation                         │
│  • User comments keyword → auto-reply with link             │
│  • Link goes to partner-specific form                       │
│  • Tracks source (Instagram, Facebook, TikTok)              │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 DATABASE SCHEMA (Supabase):

### **Table: partners**
```sql
CREATE TABLE partners (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL, -- e.g., 'balaji-villas'
  contact_email TEXT,
  contact_phone TEXT,
  logo_url TEXT,
  brand_color TEXT DEFAULT '#231B4F',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### **Table: properties**
```sql
CREATE TABLE properties (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  partner_id UUID REFERENCES partners(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  slug TEXT NOT NULL, -- e.g., 'prestige-villas-accra'
  description TEXT,
  location TEXT,
  price_range TEXT,
  image_url TEXT NOT NULL, -- For tile display
  gallery_urls TEXT[], -- Additional images
  ghl_tag TEXT NOT NULL, -- Tag to apply in GHL (e.g., 'property_prestige_villas')
  ghl_automation_id TEXT, -- Optional: specific automation to trigger
  is_active BOOLEAN DEFAULT true,
  display_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(partner_id, slug)
);
```

### **Table: forms**
```sql
CREATE TABLE forms (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  partner_id UUID REFERENCES partners(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL, -- URL: /forms/{slug}
  title TEXT NOT NULL,
  subtitle TEXT,
  form_type TEXT DEFAULT 'multi_property', -- 'multi_property' or 'single_property'
  property_ids UUID[], -- Which properties to show
  fields JSONB DEFAULT '[]'::jsonb, -- Custom form fields
  thank_you_message TEXT,
  redirect_url TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### **Table: submissions**
```sql
CREATE TABLE submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  form_id UUID REFERENCES forms(id) ON DELETE SET NULL,
  property_id UUID REFERENCES properties(id) ON DELETE SET NULL,
  partner_id UUID REFERENCES partners(id) ON DELETE SET NULL,
  
  -- Contact Info
  first_name TEXT,
  last_name TEXT,
  email TEXT NOT NULL,
  phone TEXT,
  
  -- Additional Data
  form_data JSONB DEFAULT '{}'::jsonb,
  
  -- Source Tracking
  source TEXT, -- 'instagram', 'facebook', 'tiktok', 'direct', etc.
  utm_source TEXT,
  utm_medium TEXT,
  utm_campaign TEXT,
  
  -- GHL Integration
  ghl_contact_id TEXT, -- ID in GHL
  ghl_tags_applied TEXT[],
  ghl_automation_triggered TEXT,
  ghl_sync_status TEXT DEFAULT 'pending', -- 'pending', 'synced', 'failed'
  ghl_sync_error TEXT,
  
  -- Metadata
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### **Table: automation_rules**
```sql
CREATE TABLE automation_rules (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID REFERENCES properties(id) ON DELETE CASCADE,
  rule_name TEXT NOT NULL,
  
  -- When this property is selected...
  ghl_tags_to_apply TEXT[] NOT NULL, -- Tags to add in GHL
  ghl_automation_to_trigger TEXT, -- Automation webhook or ID
  
  -- Email customization (optional)
  email_template_id TEXT,
  custom_message TEXT,
  
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### **Table: social_triggers**
```sql
CREATE TABLE social_triggers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  keyword TEXT NOT NULL UNIQUE, -- 'PRESTIGE', 'VILLAS', 'INFO'
  form_id UUID REFERENCES forms(id) ON DELETE CASCADE,
  platform TEXT NOT NULL, -- 'instagram', 'facebook', 'tiktok'
  auto_reply_message TEXT,
  is_active BOOLEAN DEFAULT true,
  usage_count INT DEFAULT 0,
  last_used_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## 🎨 ADMIN INTERFACE FEATURES:

### **Dashboard Home:**
- Total partners, properties, submissions today/this week/all-time
- Recent submissions (live feed)
- Top performing properties
- Conversion rates by partner
- Quick actions: "Add Partner", "Create Form", "View Analytics"

### **Partners Management:**
```
┌─────────────────────────────────────────────────────┐
│ PARTNERS                                     [+ Add] │
├─────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────┐ │
│ │ 🏢 Balaji Villas                         [Edit] │ │
│ │ Contact: partner@balaji.com                     │ │
│ │ Properties: 3 | Active Forms: 2                 │ │
│ │ Total Submissions: 127                          │ │
│ └─────────────────────────────────────────────────┘ │
│                                                      │
│ ┌─────────────────────────────────────────────────┐ │
│ │ 🏢 Prestige Operations                   [Edit] │ │
│ │ Contact: info@prestige.com                      │ │
│ │ Properties: 2 | Active Forms: 1                 │ │
│ │ Total Submissions: 89                           │ │
│ └─────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

### **Add/Edit Partner:**
- Partner name
- Contact info
- Upload logo
- Set brand color
- Enable/disable partner

### **Properties Management (Per Partner):**
```
Partner: Balaji Villas > Properties

┌──────────────────────────────────────────────────────┐
│ PROPERTIES                                    [+ Add] │
├──────────────────────────────────────────────────────┤
│ [Drag to reorder]                                     │
│                                                       │
│ 🏠 [Image] Balaji Estate - Accra                     │
│    Location: East Legon, Accra                       │
│    GHL Tag: property_balaji_accra                    │
│    Submissions: 45                          [Edit]   │
│                                                       │
│ 🏠 [Image] Balaji Gardens - Kumasi                   │
│    Location: Ahodwo, Kumasi                          │
│    GHL Tag: property_balaji_kumasi                   │
│    Submissions: 23                          [Edit]   │
└──────────────────────────────────────────────────────┘
```

### **Form Builder:**
Visual form creator with:
- Drag-and-drop property tiles
- Select which properties to show
- Customize form fields
- Set thank you message
- Generate embeddable code
- Preview before publishing
- Get shareable link

**Example Output:**
```
Form URL: https://forms.diasporatohome.com/balaji-interest
Embed Code: <iframe src="..." width="100%" height="600px"></iframe>
QR Code: [Download PNG]
Social Media Link: https://forms.diasporatohome.com/balaji
```

### **Automation Rules:**
For each property, set:
- Which GHL tags to apply
- Which GHL automation to trigger
- Custom intro message template
- Email notifications

### **Social Media Triggers:**
```
┌────────────────────────────────────────────────────┐
│ SOCIAL TRIGGERS                            [+ Add]  │
├────────────────────────────────────────────────────┤
│ Keyword: PRESTIGE                                   │
│ Platform: Instagram                                 │
│ → Links to: Prestige Villas Form                   │
│ Auto-reply: "Thanks for your interest! 🏡..."      │
│ Used: 234 times                           [Edit]   │
│                                                     │
│ Keyword: BALAJI                                     │
│ Platform: Instagram                                 │
│ → Links to: Balaji Form                            │
│ Auto-reply: "Explore Balaji properties! 🌟..."     │
│ Used: 156 times                           [Edit]   │
└────────────────────────────────────────────────────┘
```

### **Analytics Dashboard:**
- Submissions over time (chart)
- Conversion by property
- Top traffic sources
- Partner performance comparison
- Export to CSV

---

## 🔗 GHL INTEGRATION:

### **How It Works:**

1. **When form submitted:**
```javascript
// Supabase Edge Function
async function handleFormSubmission(data) {
  // 1. Save to Supabase
  const submission = await supabase
    .from('submissions')
    .insert(data)
    .select()
    .single();

  // 2. Get property automation rules
  const rules = await supabase
    .from('automation_rules')
    .select('*')
    .eq('property_id', data.property_id)
    .eq('is_active', true);

  // 3. Send to GHL API
  const ghlContact = await createOrUpdateGHLContact({
    email: data.email,
    firstName: data.first_name,
    lastName: data.last_name,
    phone: data.phone,
    tags: rules.ghl_tags_to_apply, // e.g., ['property_prestige_villas', 'lead_2026_03']
    customFields: {
      property_interest: data.property_name,
      submission_source: data.source
    }
  });

  // 4. Trigger GHL automation via tag
  // The tag automatically triggers the automation in GHL
  // No need for additional API call

  // 5. Update submission with GHL sync status
  await supabase
    .from('submissions')
    .update({
      ghl_contact_id: ghlContact.id,
      ghl_tags_applied: rules.ghl_tags_to_apply,
      ghl_sync_status: 'synced'
    })
    .eq('id', submission.id);

  return { success: true };
}
```

### **GHL API Integration Points:**

**Create/Update Contact:**
```javascript
POST https://services.leadconnectorhq.com/contacts/
Headers: {
  Authorization: Bearer {API_KEY}
  Version: 2021-07-28
}
Body: {
  email: "user@example.com",
  firstName: "John",
  lastName: "Doe",
  tags: ["property_prestige_villas", "lead_instagram_2026_03"]
}
```

**Tag-Based Automation Trigger:**
- In GHL, create automation with trigger: "Contact Tagged"
- Tag: `property_prestige_villas`
- When our system applies this tag → automation fires automatically
- Each property gets unique tag → unique automation

---

## 📱 SOCIAL MEDIA INTEGRATION:

### **Option 1: ManyChat (Recommended)**

**How it works:**
1. User comments keyword on Instagram post
2. ManyChat detects keyword
3. ManyChat sends auto-DM with link to form
4. Link includes tracking params: `?source=instagram&keyword=PRESTIGE`
5. User fills form → submits → saved with source tracking

**Setup in Admin:**
```
Keyword: PRESTIGE
Platform: Instagram
Form: Prestige Villas Form
Generated Link: https://forms.diasporatohome.com/prestige?source=ig&k=PRESTIGE
ManyChat Template: "Hi! Thanks for commenting PRESTIGE. Check out our villas: {link}"
```

**ManyChat Configuration:**
- Lorraine connects her Instagram account to ManyChat
- In admin panel, she sets up keywords
- System generates tracking links
- She copies ManyChat template and link
- Sets up in ManyChat (one-time setup per keyword)

### **Option 2: Custom Webhook (Advanced)**

For platforms without ManyChat support:
- Webhook receives comment events
- Checks keyword against database
- Auto-replies via platform API
- More complex but fully automated

---

## 🎨 PUBLIC FORM EXPERIENCE:

### **Visual Property Selector:**

```html
┌──────────────────────────────────────────────────────┐
│         Which Property Are You Interested In?         │
├──────────────────────────────────────────────────────┤
│                                                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │
│  │ [Property 1]│  │ [Property 2]│  │ [Property 3]│ │
│  │    Photo    │  │    Photo    │  │    Photo    │ │
│  │             │  │             │  │             │ │
│  │  Prestige   │  │   Balaji    │  │    Vow      │
│  │   Villas    │  │   Estate    │  │  Gardens    │
│  │             │  │             │  │             │ │
│  │  📍 Accra   │  │ 📍 Kumasi   │  │  📍 Tema    │
│  │  £500k+     │  │  £350k+     │  │  £280k+     │
│  └─────────────┘  └─────────────┘  └─────────────┘ │
│      [Selected]                                      │
│                                                       │
│  ┌─────────────────────────────────────────────────┐│
│  │ First Name: [              ]                    ││
│  │ Last Name:  [              ]                    ││
│  │ Email:      [              ]                    ││
│  │ Phone:      [              ]                    ││
│  │ Message:    [                                  ]││
│  │             [                                  ]││
│  │                                                 ││
│  │            [Submit Interest →]                  ││
│  └─────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────┘
```

**Features:**
- Click on property tile to select
- Visual feedback (border/glow when selected)
- Mobile-friendly grid
- Property details on hover
- Fast, smooth, professional

---

## 🚀 DEPLOYMENT & HOSTING:

### **Costs:**

**Supabase (Database + Backend):**
- Free tier: Up to 500MB database, 2GB bandwidth
- Pro tier: $25/month (unlimited everything)
- **Recommendation:** Start free, upgrade when needed

**Vercel (Admin Panel Hosting):**
- Free tier: Unlimited deployments, 100GB bandwidth
- **Recommendation:** Free tier is fine

**Domain:**
- Admin: `admin.diasporatohome.com` (subdomain, free)
- Forms: `forms.diasporatohome.com` (subdomain, free)

**ManyChat:**
- Free tier: 1,000 contacts
- Pro: $15/month (unlimited)
- **Recommendation:** Start free

**Total Monthly Cost:** $0 (free tier) to $40/month (all pro tiers)

---

## ⚙️ TECHNICAL IMPLEMENTATION:

### **Phase 1: Database & Backend (Week 1)**
- Set up Supabase project
- Create database tables
- Write Edge Functions for form submissions
- Set up GHL API integration
- Test with dummy data

### **Phase 2: Admin Panel (Week 2)**
- Build React admin interface
- Partner management CRUD
- Property management CRUD
- Form builder
- Analytics dashboard

### **Phase 3: Public Forms (Week 3)**
- Build embeddable form widget
- Visual property tile selector
- Form submission handling
- Thank you pages
- Mobile optimization

### **Phase 4: Social Integration (Week 4)**
- ManyChat setup guide
- Keyword management in admin
- Link generation
- Source tracking
- Testing with real Instagram account

### **Phase 5: Testing & Launch (Week 5)**
- End-to-end testing
- GHL integration testing
- Load testing
- Documentation
- Lorraine training
- Go live!

---

## 💰 PRICING:

### **Development Cost:**

**Option A: Full Build**
- **Price:** $2,500
- **Timeline:** 5 weeks
- **Includes:**
  - Complete system as described
  - Admin panel
  - Public forms
  - GHL integration
  - Social media setup
  - Training for Lorraine
  - 1 month post-launch support

**Option B: MVP Build**
- **Price:** $1,500
- **Timeline:** 3 weeks
- **Includes:**
  - Core functionality (partners, properties, forms)
  - Basic admin panel
  - GHL integration
  - Manual social media (no ManyChat)
  - Training
  - 2 weeks post-launch support

### **Ongoing Costs:**
- Hosting: $0-40/month (depending on usage)
- Maintenance: $100/month (optional)
  - Bug fixes
  - Feature updates
  - GHL API changes
  - New partner setups

---

## 🎯 VALUE PROPOSITION TO LORRAINE:

### **Benefits:**

1. **No GHL Constraints**
   - Unlimited partners ✓
   - Unlimited properties ✓
   - No 8-branch limit ✓

2. **Full Control**
   - Add partners herself (no developer needed)
   - Create forms in minutes
   - Change automation rules anytime
   - See real-time analytics

3. **Professional Experience**
   - Visual property selection
   - Mobile-optimized forms
   - Branded to her business
   - Fast and smooth

4. **Better Lead Management**
   - All submissions in one place
   - Track source (Instagram, Facebook, etc.)
   - See which properties perform best
   - Export data anytime

5. **Scalable**
   - Works for 10 partners or 100
   - No performance degradation
   - Easy to add new features
   - Future-proof

6. **Social Media Ready**
   - ManyChat integration
   - Keyword automation
   - Link tracking
   - Source attribution

---

## 📋 COMPARISON: Custom Solution vs. GHL Workarounds

| Feature | GHL Native | Custom Solution |
|---------|-----------|-----------------|
| Partners | Limited by forms | ♾️ Unlimited |
| Properties per partner | 8 max (branch limit) | ♾️ Unlimited |
| Visual property selection | ❌ No | ✅ Yes (tiles) |
| Admin interface | ❌ No | ✅ Full admin panel |
| Analytics | Basic | ✅ Advanced |
| Social media integration | Manual | ✅ Automated |
| Custom branding | Limited | ✅ Full control |
| Scalability | ⚠️ Hits limits | ✅ Infinite scale |
| Developer needed for changes | ✅ Yes | ❌ No (self-service) |
| Cost | Included in GHL | One-time + hosting |

---

## 🎬 DEMO MOCKUP:

We could build a working demo in **3-5 days** showing:
- Admin login
- Add a partner
- Add 2 properties
- Generate a form
- Submit the form
- See it sync to GHL (sandbox)
- View in analytics

**Demo Cost:** $300 (credited toward full build if she proceeds)

---

## 🤔 RISKS & CONSIDERATIONS:

### **Pros:**
- ✅ Solves the problem permanently
- ✅ Scales infinitely
- ✅ Professional solution
- ✅ Lorraine has full control
- ✅ Better UX for users
- ✅ Valuable business asset

### **Cons:**
- ⚠️ Higher upfront cost ($1,500-2,500 vs. $400)
- ⚠️ Requires ongoing hosting ($0-40/month)
- ⚠️ More complex (separate system to manage)
- ⚠️ Longer development time (3-5 weeks vs. 1 week)

### **Mitigation:**
- Start with MVP ($1,500) to prove value
- Free hosting tier initially (no monthly cost)
- Excellent documentation + training
- Make admin panel super easy to use

---

## 📊 RECOMMENDATION:

**Propose BOTH options to Lorraine:**

**Option 1:** GHL Workaround - $400, 1 week
- Quick fix
- Works within GHL
- Lower cost
- Still has constraints

**Option 2:** Custom Solution (MVP) - $1,500, 3 weeks
- Permanent solution
- Unlimited scale
- Professional
- Business asset

**Option 3:** Custom Solution (Full) - $2,500, 5 weeks
- Everything in MVP
- Plus ManyChat automation
- Plus advanced analytics
- Plus priority support

Let her choose based on:
- Budget
- Timeline urgency
- Long-term vision
- How many partners she plans to add

---

## 🎯 NEXT STEPS:

1. **Present this architecture** to Lorraine
2. **Get her feedback** on features/pricing
3. **Build demo** ($300, 3-5 days) to show concept
4. **Get approval** for MVP or Full build
5. **Start development** with clear milestones
6. **Deliver in phases** for early feedback

---

**This is a REAL solution to a REAL problem that will scale with her business!** 🚀

---

**Questions for Lorraine:**
1. How many partners do you plan to have in next 6 months?
2. How often do you add new properties?
3. Would you pay $1,500-2,500 to never worry about this again?
4. Do you want to see a working demo first?

**END OF ARCHITECTURE DOCUMENT**
