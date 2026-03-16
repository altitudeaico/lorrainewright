# 🏗️ Property Listing System - Supabase Architecture

## 🎯 **UPDATED ARCHITECTURE: Using Supabase**

Perfect choice! Supabase is an excellent open-source alternative to Firebase with some key advantages:

### **Why Supabase is Great:**
- ✅ **PostgreSQL** - More powerful than Firestore (real SQL queries)
- ✅ **Open Source** - No vendor lock-in
- ✅ **Generous Free Tier** - 500MB database, 1GB file storage, 2GB bandwidth
- ✅ **Built-in Auth** - Email/password, magic links, OAuth
- ✅ **Built-in Storage** - S3-compatible file storage
- ✅ **Row Level Security** - Powerful security at database level
- ✅ **Real-time Subscriptions** - Like Firebase real-time listeners
- ✅ **REST API Auto-generated** - Instant API from your schema
- ✅ **Edge Functions** - Serverless functions (like Firebase Functions)

---

## 🔧 **UPDATED TECH STACK**

### **Backend:**
- **Database:** Supabase (PostgreSQL)
- **File Storage:** Supabase Storage
- **Authentication:** Supabase Auth
- **Serverless Functions:** Supabase Edge Functions (Deno)
- **Payment Webhooks:** Supabase Edge Functions

### **Frontend:**
- **Public Pages:** Vanilla ES5 JavaScript on GHL
- **Admin Dashboard:** React (or vanilla JS if you prefer)
- **Supabase Client:** Via CDN for GHL compatibility

### **Payment:**
- **Stripe Checkout** - Same as before

### **Hosting:**
- **GHL Pages:** Public property display, seller submission
- **Admin Dashboard:** Vercel/Netlify (or even Supabase hosting)

---

## 📊 **DATABASE SCHEMA (PostgreSQL)**

### **Table: properties**
```sql
CREATE TABLE properties (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  type TEXT NOT NULL CHECK (type IN ('vetted', 'seller')),
  status TEXT NOT NULL CHECK (status IN ('pending', 'approved', 'rejected', 'live')) DEFAULT 'pending',
  
  -- Basic Info
  title TEXT NOT NULL,
  description TEXT,
  price DECIMAL(12, 2) NOT NULL,
  location TEXT NOT NULL,
  size TEXT,
  
  -- Property Details
  bedrooms INTEGER,
  bathrooms INTEGER,
  property_type TEXT CHECK (property_type IN ('land', 'villa', 'apartment', 'estate')),
  property_age INTEGER,
  lease_remaining INTEGER,
  amenities TEXT[], -- PostgreSQL array
  
  -- Media (stored as JSON array of URLs)
  images JSONB DEFAULT '[]',
  featured_image TEXT,
  
  -- Seller Info (nullable for vetted properties)
  seller_name TEXT,
  seller_email TEXT,
  seller_phone TEXT,
  
  -- Verification
  land_title_verified BOOLEAN DEFAULT false,
  documentation_urls TEXT[],
  
  -- Admin
  created_by TEXT NOT NULL, -- 'lorraine' or 'seller'
  submitted_at TIMESTAMPTZ DEFAULT NOW(),
  approved_at TIMESTAMPTZ,
  approved_by UUID REFERENCES auth.users(id),
  rejection_reason TEXT,
  
  -- Payment
  listing_fee_paid BOOLEAN DEFAULT false,
  payment_id TEXT,
  amount_paid DECIMAL(10, 2),
  
  -- Analytics
  views INTEGER DEFAULT 0,
  inquiries INTEGER DEFAULT 0,
  last_viewed_at TIMESTAMPTZ,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for fast queries
CREATE INDEX idx_properties_status ON properties(status);
CREATE INDEX idx_properties_type ON properties(type);
CREATE INDEX idx_properties_location ON properties(location);
CREATE INDEX idx_properties_price ON properties(price);

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_properties_updated_at BEFORE UPDATE
ON properties FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### **Table: inquiries**
```sql
CREATE TABLE inquiries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_inquiries_property_id ON inquiries(property_id);
```

### **Table: admin_users** (Optional - or use Supabase Auth)
```sql
-- If you want custom admin roles beyond Supabase Auth
CREATE TABLE admin_users (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'admin',
  name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 🔐 **ROW LEVEL SECURITY (RLS)**

Supabase's killer feature - database-level security!

### **Properties Table RLS:**
```sql
-- Enable RLS
ALTER TABLE properties ENABLE ROW LEVEL SECURITY;

-- Policy 1: Public can view approved/live properties
CREATE POLICY "Public can view approved properties"
ON properties FOR SELECT
USING (status IN ('approved', 'live'));

-- Policy 2: Authenticated admins can view all properties
CREATE POLICY "Admins can view all properties"
ON properties FOR SELECT
TO authenticated
USING (
  auth.uid() IN (SELECT id FROM admin_users)
);

-- Policy 3: Admins can insert/update/delete properties
CREATE POLICY "Admins can manage properties"
ON properties FOR ALL
TO authenticated
USING (
  auth.uid() IN (SELECT id FROM admin_users)
)
WITH CHECK (
  auth.uid() IN (SELECT id FROM admin_users)
);

-- Policy 4: Sellers can insert their own properties (pending approval)
CREATE POLICY "Sellers can submit properties"
ON properties FOR INSERT
WITH CHECK (
  type = 'seller' AND 
  status = 'pending' AND
  listing_fee_paid = true
);
```

### **Inquiries Table RLS:**
```sql
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- Anyone can insert inquiries
CREATE POLICY "Anyone can submit inquiries"
ON inquiries FOR INSERT
WITH CHECK (true);

-- Only admins can view inquiries
CREATE POLICY "Admins can view inquiries"
ON inquiries FOR SELECT
TO authenticated
USING (
  auth.uid() IN (SELECT id FROM admin_users)
);
```

---

## 📦 **SUPABASE STORAGE BUCKETS**

### **Create Storage Bucket for Property Images:**
```javascript
// In Supabase Dashboard or via client
const { data, error } = await supabase
  .storage
  .createBucket('property-images', {
    public: true, // Images are publicly accessible
    fileSizeLimit: 5242880, // 5MB per file
    allowedMimeTypes: ['image/png', 'image/jpeg', 'image/jpg', 'image/webp']
  });
```

### **Storage Structure:**
```
property-images/
  /{property-id}/
    /image-1.jpg
    /image-2.jpg
    /image-3.jpg
```

### **Storage Policies:**
```sql
-- Allow public to read images
CREATE POLICY "Public can view property images"
ON storage.objects FOR SELECT
USING (bucket_id = 'property-images');

-- Allow authenticated uploads (for seller submissions)
CREATE POLICY "Anyone can upload property images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'property-images');

-- Only admins can delete images
CREATE POLICY "Admins can delete property images"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'property-images' AND
  auth.uid() IN (SELECT id FROM admin_users)
);
```

---

## 🌐 **SUPABASE CLIENT SETUP**

### **For GHL Pages (Vanilla ES5 JavaScript):**

```html
<!DOCTYPE html>
<html>
<head>
    <title>Properties - Diaspora to Home</title>
    
    <!-- Supabase Client via CDN (ES5 compatible) -->
    <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
</head>
<body>
    <script>
        // Initialize Supabase client (ES5 style)
        var SUPABASE_URL = 'https://your-project.supabase.co';
        var SUPABASE_ANON_KEY = 'your-anon-key-here';
        
        var supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
        
        // Fetch approved properties (ES5 style)
        function fetchProperties() {
            supabase
                .from('properties')
                .select('*')
                .in('status', ['approved', 'live'])
                .order('created_at', { ascending: false })
                .then(function(response) {
                    if (response.error) {
                        console.error('Error fetching properties:', response.error);
                        return;
                    }
                    
                    var properties = response.data;
                    displayProperties(properties);
                })
                .catch(function(error) {
                    console.error('Error:', error);
                });
        }
        
        // Display properties
        function displayProperties(properties) {
            var container = document.getElementById('properties-container');
            container.innerHTML = '';
            
            properties.forEach(function(property) {
                var propertyCard = createPropertyCard(property);
                container.appendChild(propertyCard);
            });
        }
        
        // Create property card
        function createPropertyCard(property) {
            var card = document.createElement('div');
            card.className = 'property-card';
            
            var badge = property.type === 'vetted' 
                ? '<span class="badge-vetted">Vetted by Lorraine</span>'
                : '<span class="badge-seller">Seller\'s Listing</span>';
            
            card.innerHTML = 
                '<img src="' + property.featured_image + '" alt="' + property.title + '">' +
                badge +
                '<h3>' + property.title + '</h3>' +
                '<p class="location">' + property.location + '</p>' +
                '<p class="price">$' + property.price.toLocaleString() + '</p>' +
                '<a href="property-detail.html?id=' + property.id + '">View Details</a>';
            
            return card;
        }
        
        // Load properties when page loads
        window.addEventListener('load', function() {
            fetchProperties();
        });
    </script>
</body>
</html>
```

---

## 💳 **PAYMENT FLOW WITH SUPABASE**

### **Seller Submission Flow:**

1. **User fills form** → Validates data
2. **Upload images to Supabase Storage**
3. **Create "unpaid" property record** in Supabase
4. **Redirect to Stripe Checkout** with property ID in metadata
5. **User pays $99**
6. **Stripe webhook** → Supabase Edge Function
7. **Edge Function updates property:** `listing_fee_paid = true`, `status = 'pending'`
8. **Email notification** to Lorraine (via Edge Function)

### **Stripe Webhook Handler (Supabase Edge Function):**

```typescript
// File: supabase/functions/stripe-webhook/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import Stripe from 'https://esm.sh/stripe@14.21.0';

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') || '', {
  apiVersion: '2023-10-16',
});

serve(async (req) => {
  const signature = req.headers.get('stripe-signature');
  const webhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET');
  
  try {
    const body = await req.text();
    const event = stripe.webhooks.constructEvent(body, signature!, webhookSecret!);
    
    if (event.type === 'checkout.session.completed') {
      const session = event.data.object;
      const propertyId = session.metadata?.propertyId;
      
      // Initialize Supabase client
      const supabase = createClient(
        Deno.env.get('SUPABASE_URL') ?? '',
        Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
      );
      
      // Update property: mark as paid and pending approval
      const { error } = await supabase
        .from('properties')
        .update({
          listing_fee_paid: true,
          status: 'pending',
          payment_id: session.payment_intent,
          amount_paid: 99
        })
        .eq('id', propertyId);
      
      if (error) {
        throw error;
      }
      
      // TODO: Send email notification to Lorraine
      // await sendEmailNotification(propertyId);
      
      return new Response(JSON.stringify({ received: true }), {
        headers: { 'Content-Type': 'application/json' },
      });
    }
    
    return new Response(JSON.stringify({ received: true }), {
      headers: { 'Content-Type': 'application/json' },
    });
    
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    );
  }
});
```

---

## 📱 **ADMIN DASHBOARD (React + Supabase)**

### **Simple Admin Dashboard Example:**

```typescript
import { createClient } from '@supabase/supabase-js';
import { useState, useEffect } from 'react';

const supabase = createClient(
  process.env.REACT_APP_SUPABASE_URL!,
  process.env.REACT_APP_SUPABASE_ANON_KEY!
);

function AdminDashboard() {
  const [properties, setProperties] = useState([]);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    fetchPendingProperties();
  }, []);
  
  async function fetchPendingProperties() {
    const { data, error } = await supabase
      .from('properties')
      .select('*')
      .eq('status', 'pending')
      .order('submitted_at', { ascending: false });
    
    if (error) {
      console.error('Error fetching properties:', error);
    } else {
      setProperties(data);
    }
    setLoading(false);
  }
  
  async function approveProperty(propertyId) {
    const { error } = await supabase
      .from('properties')
      .update({ 
        status: 'approved',
        approved_at: new Date().toISOString(),
        approved_by: (await supabase.auth.getUser()).data.user?.id
      })
      .eq('id', propertyId);
    
    if (error) {
      console.error('Error approving property:', error);
    } else {
      // Refresh list
      fetchPendingProperties();
    }
  }
  
  async function rejectProperty(propertyId, reason) {
    const { error } = await supabase
      .from('properties')
      .update({ 
        status: 'rejected',
        rejection_reason: reason
      })
      .eq('id', propertyId);
    
    if (error) {
      console.error('Error rejecting property:', error);
    } else {
      fetchPendingProperties();
    }
  }
  
  if (loading) return <div>Loading...</div>;
  
  return (
    <div className="admin-dashboard">
      <h1>Pending Property Submissions</h1>
      
      {properties.length === 0 ? (
        <p>No pending submissions</p>
      ) : (
        properties.map(property => (
          <div key={property.id} className="property-submission">
            <h3>{property.title}</h3>
            <p>{property.location} - ${property.price}</p>
            <p>Submitted by: {property.seller_name} ({property.seller_email})</p>
            <p>Submitted: {new Date(property.submitted_at).toLocaleDateString()}</p>
            
            <div className="images">
              {JSON.parse(property.images).map((img, i) => (
                <img key={i} src={img} alt={`Property ${i + 1}`} />
              ))}
            </div>
            
            <button onClick={() => approveProperty(property.id)}>
              Approve
            </button>
            <button onClick={() => {
              const reason = prompt('Rejection reason:');
              if (reason) rejectProperty(property.id, reason);
            }}>
              Reject
            </button>
          </div>
        ))
      )}
    </div>
  );
}

export default AdminDashboard;
```

---

## 🚀 **DEPLOYMENT STEPS**

### **1. Create Supabase Project**
```bash
# Go to https://supabase.com
# Click "New Project"
# Set project name: diaspora-to-home
# Set database password (save it!)
# Choose region: closest to Ghana/UK
# Wait for project to be ready (~2 minutes)
```

### **2. Run Database Schema**
```sql
-- In Supabase SQL Editor, run the schema from above
-- Create tables: properties, inquiries
-- Enable RLS policies
-- Create indexes
```

### **3. Create Storage Bucket**
```bash
# In Supabase Dashboard
# Storage → New Bucket
# Name: property-images
# Public: Yes
# Set file size limit: 5MB
```

### **4. Set Up Edge Functions (Optional)**
```bash
# Install Supabase CLI
npm install -g supabase

# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Create webhook function
supabase functions new stripe-webhook

# Deploy function
supabase functions deploy stripe-webhook
```

### **5. Configure Stripe**
```bash
# In Stripe Dashboard
# Webhooks → Add Endpoint
# URL: https://your-project.supabase.co/functions/v1/stripe-webhook
# Events: checkout.session.completed
# Copy webhook secret
```

### **6. Set Environment Variables**
```bash
# In Supabase Dashboard → Settings → Edge Functions
# Add secrets:
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
SUPABASE_SERVICE_ROLE_KEY=... (from Settings → API)
```

---

## 💰 **COST BREAKDOWN (Supabase)**

### **Free Tier Limits:**
- Database: 500MB (plenty for 1000s of properties)
- Storage: 1GB (enough for 200-300 high-res images)
- Bandwidth: 2GB/month
- Edge Functions: 500K invocations/month
- Authentication: Unlimited users

### **When You'd Need to Upgrade ($25/month Pro):**
- 8GB database
- 100GB storage
- 50GB bandwidth
- Daily backups
- Perfect for scaling business

### **Estimated Costs:**
- **Year 1:** $0/month (free tier)
- **After growth:** $25/month (Pro plan)
- **Stripe fees:** Same as before ($3.20 per $99 listing)

---

## ✅ **SUPABASE vs FIREBASE COMPARISON**

| Feature | Supabase | Firebase |
|---------|----------|----------|
| Database | PostgreSQL (SQL) | Firestore (NoSQL) |
| Query Language | SQL (more powerful) | Document queries |
| Free Tier | 500MB DB, 1GB storage | 1GB storage |
| Open Source | ✅ Yes | ❌ No |
| Vendor Lock-in | ✅ Low | ❌ High |
| Real-time | ✅ Yes | ✅ Yes |
| Auth | ✅ Yes | ✅ Yes |
| Storage | ✅ Yes | ✅ Yes |
| Functions | Edge Functions (Deno) | Cloud Functions (Node) |
| Learning Curve | SQL knowledge helpful | Easier if no SQL |

**For this project: Supabase is perfect!** ✅

---

## 📝 **NEXT STEPS WITH SUPABASE**

1. ✅ **Create Supabase project** (5 min)
2. ✅ **Run database schema** (10 min)
3. ✅ **Create storage bucket** (2 min)
4. ✅ **Build property display page** (2-3 hours)
5. ✅ **Build seller submission form** (2-3 hours)
6. ✅ **Set up Stripe** (30 min)
7. ✅ **Deploy Edge Function** (30 min)
8. ✅ **Build admin dashboard** (4-6 hours)
9. ✅ **Test everything** (2 hours)

**Ready to set up Supabase and start building?** 🚀

---

## 🎯 **ARCHITECTURE SUMMARY**

```
┌─────────────────────────────────────────────────────────────┐
│                     PUBLIC USERS                             │
│  (View properties, Submit listings, Make inquiries)          │
└────────────┬────────────────────────────────┬───────────────┘
             │                                 │
             ▼                                 ▼
┌────────────────────────┐      ┌─────────────────────────────┐
│  GHL Property Pages    │      │  GHL Submission Form        │
│  (Vanilla ES5 JS)      │      │  (Vanilla ES5 JS)           │
│  - Display properties  │      │  - Upload images            │
│  - Filters/search      │      │  - Submit data              │
│  - Property details    │      │  - Redirect to Stripe       │
└────────┬───────────────┘      └───────────┬─────────────────┘
         │                                   │
         │        ┌──────────────────────────┘
         │        │
         ▼        ▼
┌─────────────────────────────────────────────────────────────┐
│                    SUPABASE BACKEND                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │  PostgreSQL  │  │   Storage    │  │  Edge Functions  │  │
│  │   Database   │  │  (Images)    │  │  (Webhooks)      │  │
│  └──────────────┘  └──────────────┘  └──────────────────┘  │
│                                                              │
│  ┌──────────────┐                                           │
│  │     Auth     │  (Admin login)                            │
│  └──────────────┘                                           │
└────────┬────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│                    ADMIN INTERFACE                           │
│  (React Dashboard - Vercel/Netlify)                          │
│  - View pending submissions                                  │
│  - Approve/Reject properties                                 │
│  - Add vetted properties                                     │
│  - View analytics                                            │
└─────────────────────────────────────────────────────────────┘

         ▲
         │
         │
┌────────┴────────┐
│  STRIPE         │
│  (Payments)     │
│  - $99 listings │
│  - Webhooks     │
└─────────────────┘
```

**Let's build this! Ready when you are!** 💪
