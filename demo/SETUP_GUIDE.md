# 🔧 Diaspora Property Demo - Setup Guide

## STEP 1: CREATE SUPABASE PROJECT (5 minutes)

### Go to Supabase:
1. Visit: https://supabase.com
2. Click "Start your project"
3. Sign in with GitHub (or email)
4. Click "New Project"

### Project Settings:
- **Name:** diaspora-property-demo
- **Database Password:** Create a strong password (SAVE THIS!)
- **Region:** Choose closest to UK/Ghana (e.g., "Europe West (London)")
- **Pricing Plan:** Free

### Wait for setup (takes ~2 minutes)
- You'll see "Setting up project..." 
- When done, you'll see your project dashboard

### Get Your API Keys:
1. Click "Settings" (gear icon, bottom left)
2. Click "API" in sidebar
3. Copy these values (we'll need them):
   - **Project URL:** `https://[your-project].supabase.co`
   - **anon public key:** `eyJhbGc...` (long string)

**SAVE THESE - We'll use them in the code!**

---

## STEP 2: CREATE DATABASE TABLES

### In Supabase Dashboard:
1. Click "SQL Editor" in left sidebar
2. Click "New query"
3. Copy and paste the SQL below
4. Click "Run" (or press Cmd/Ctrl + Enter)

```sql
-- Create properties table
CREATE TABLE properties (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type TEXT NOT NULL CHECK (type IN ('vetted', 'seller')),
  status TEXT NOT NULL CHECK (status IN ('pending', 'approved', 'rejected')) DEFAULT 'pending',
  
  -- Basic Info
  title TEXT NOT NULL,
  location TEXT NOT NULL,
  price DECIMAL(12,2) NOT NULL,
  
  -- Property Details
  bedrooms INTEGER,
  bathrooms INTEGER,
  property_type TEXT CHECK (property_type IN ('land', 'villa', 'apartment', 'estate')),
  size TEXT,
  description TEXT,
  
  -- Media
  images JSONB DEFAULT '[]'::jsonb,
  featured_image TEXT,
  
  -- Seller Info (nullable for vetted properties)
  seller_name TEXT,
  seller_email TEXT,
  seller_phone TEXT,
  
  -- Admin
  created_by TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Payment
  listing_fee_paid BOOLEAN DEFAULT false,
  payment_id TEXT
);

-- Create index for faster queries
CREATE INDEX idx_properties_status ON properties(status);
CREATE INDEX idx_properties_type ON properties(type);
CREATE INDEX idx_properties_location ON properties(location);

-- Enable Row Level Security
ALTER TABLE properties ENABLE ROW LEVEL SECURITY;

-- Public can view approved properties
CREATE POLICY "Public can view approved properties"
ON properties FOR SELECT
USING (status = 'approved');

-- Anyone can insert properties (for seller submissions)
CREATE POLICY "Anyone can insert properties"
ON properties FOR INSERT
WITH CHECK (true);
```

You should see "Success. No rows returned"

---

## STEP 3: INSERT SAMPLE DATA (Copy each section separately)

Run these queries one at a time in SQL Editor:

### Vetted Properties (Run this first):
```sql
INSERT INTO properties (
  type, status, title, location, price, bedrooms, bathrooms, 
  property_type, size, description, featured_image, created_by, listing_fee_paid
) VALUES 
('vetted', 'approved', 'Luxury Villa in East Legon', 'East Legon, Accra', 250000, 4, 3, 'villa', '500 sqm', 
 'Beautiful modern villa with swimming pool, landscaped gardens, and premium finishes throughout.', 
 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800', 'lorraine', true),
 
('vetted', 'approved', 'Modern Apartment in Airport Residential', 'Airport Residential, Accra', 120000, 3, 2, 'apartment', '180 sqm',
 'Contemporary 3-bedroom apartment in secure gated community with fitted kitchen and parking.',
 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800', 'lorraine', true),
 
('vetted', 'approved', 'Beachfront Estate in Kokrobite', 'Kokrobite Beach Road', 380000, 5, 4, 'estate', '800 sqm',
 'Stunning beachfront property with direct beach access, infinity pool, and panoramic ocean views.',
 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800', 'lorraine', true),
 
('vetted', 'approved', 'Prime Commercial Land in Tema', 'Tema Community 1', 85000, 0, 0, 'land', '1000 sqm',
 'Development-ready commercial land in high-traffic area. Perfect for retail or mixed-use development.',
 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800', 'lorraine', true),
 
('vetted', 'approved', 'Executive Townhouse in Cantonments', 'Cantonments, Accra', 195000, 3, 3, 'villa', '250 sqm',
 'Elegant townhouse in diplomatic enclave with smart home features and rooftop terrace.',
 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800', 'lorraine', true);
```

### Seller Listings (Run this second):
```sql
INSERT INTO properties (
  type, status, title, location, price, bedrooms, bathrooms, property_type, size, description, 
  featured_image, seller_name, seller_email, seller_phone, created_by, listing_fee_paid
) VALUES 
('seller', 'approved', 'Family Home in Spintex', 'Spintex Road, Accra', 95000, 3, 2, 'villa', '300 sqm',
 'Cozy family home in established neighborhood with secure compound.',
 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800',
 'John Mensah', 'john.mensah@example.com', '+233 20 123 4567', 'seller', true),
 
('seller', 'approved', 'Investment Land in Prampram', 'Prampram Beach Road', 45000, 0, 0, 'land', '600 sqm',
 'Beach-adjacent land parcel perfect for vacation home development.',
 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
 'Grace Osei', 'grace.osei@example.com', '+233 24 987 6543', 'seller', true),
 
('seller', 'approved', 'Renovated Bungalow in Madina', 'Madina Estate, Accra', 78000, 2, 2, 'villa', '200 sqm',
 'Recently renovated bungalow ideal for small family or rental investment.',
 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
 'Kwame Asante', 'kwame.asante@example.com', '+233 26 555 1234', 'seller', true),
 
('seller', 'approved', 'Duplex in Trassaco Valley', 'Trassaco Valley Estate', 165000, 4, 3, 'villa', '350 sqm',
 'Modern duplex in prestigious gated estate with pool access.',
 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
 'Ama Boateng', 'ama.boateng@example.com', '+233 27 888 9999', 'seller', true),
 
('seller', 'approved', 'Warehouse Space in Tema', 'Tema Industrial Area', 125000, 0, 2, 'land', '1200 sqm',
 'Spacious warehouse with office annex and loading dock.',
 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800',
 'Samuel Owusu', 'samuel.owusu@example.com', '+233 20 777 3333', 'seller', true);
```

### Pending Submissions (Run this third):
```sql
INSERT INTO properties (
  type, status, title, location, price, bedrooms, bathrooms, property_type, size, description,
  featured_image, seller_name, seller_email, seller_phone, created_by, listing_fee_paid
) VALUES
('seller', 'pending', 'New Development in Tema', 'Tema Community 25', 150000, 3, 3, 'villa', '280 sqm',
 'Brand new construction with modern finishes and private garden.',
 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
 'Michael Adjei', 'michael.adjei@example.com', '+233 24 111 2222', 'seller', true),
 
('seller', 'pending', 'Apartment Complex in Dansoman', 'Dansoman Estates', 220000, 8, 6, 'apartment', '600 sqm',
 'Income-generating 4-unit apartment building. All units currently rented.',
 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
 'Beatrice Appiah', 'beatrice.appiah@example.com', '+233 26 333 4444', 'seller', true),
 
('seller', 'pending', 'Residential Land in Oyarifa', 'Oyarifa, near Adenta', 38000, 0, 0, 'land', '450 sqm',
 'Well-located plot in fast-developing area with clear documentation.',
 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
 'Patricia Mends', 'patricia.mends@example.com', '+233 27 555 6666', 'seller', true);
```

Each should show "Success. X rows affected"

---

## ✅ YOU'RE DONE!

You now have a working Supabase backend with 13 properties ready to display!

**Next:** I'll help you build the frontend demo pages.
