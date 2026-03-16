# 📦 File Storage - Complete Guide

## 🎯 **WHERE FILES ARE STORED: SUPABASE STORAGE**

All property images and documents will be stored in **Supabase Storage** - their built-in S3-compatible file storage system.

---

## 📂 **STORAGE ARCHITECTURE**

### **Supabase Storage Overview:**
- **What it is:** Built-in file storage (like AWS S3, but integrated with Supabase)
- **Location:** Hosted on Supabase's infrastructure (globally distributed)
- **Access:** Direct HTTPS URLs to files
- **Free Tier:** 1GB storage, 2GB bandwidth/month
- **Pricing after free tier:** $0.021/GB storage, $0.09/GB bandwidth

---

## 🗂️ **FOLDER STRUCTURE**

### **Storage Bucket: `property-images`**

```
property-images/                           <- Storage Bucket (created in Supabase)
│
├── {property-uuid-1}/                     <- Folder per property
│   ├── image-1.jpg                        <- Property images
│   ├── image-2.jpg
│   ├── image-3.jpg
│   ├── image-4.jpg
│   └── documents/                         <- Optional: Land title docs
│       └── land-title.pdf
│
├── {property-uuid-2}/
│   ├── featured.jpg
│   ├── interior-1.jpg
│   ├── interior-2.jpg
│   └── exterior.jpg
│
└── {property-uuid-3}/
    ├── front-view.jpg
    ├── back-view.jpg
    └── aerial.jpg
```

**Example Real URLs:**
```
https://[your-project].supabase.co/storage/v1/object/public/property-images/abc-123-def/image-1.jpg
https://[your-project].supabase.co/storage/v1/object/public/property-images/abc-123-def/image-2.jpg
```

---

## 📤 **HOW FILES GET UPLOADED**

### **Upload Flow:**

```
1. Seller/Lorraine selects images in form
   ↓
2. JavaScript uploads directly to Supabase Storage
   (Direct browser → Supabase, no backend server needed!)
   ↓
3. Supabase returns public URLs for each image
   ↓
4. URLs are saved in PostgreSQL database (properties.images column)
   ↓
5. Property displays images using these URLs
```

---

## 💻 **UPLOAD CODE EXAMPLES**

### **ES5 JavaScript (for GHL pages):**

```javascript
// Upload single image
function uploadPropertyImage(file, propertyId) {
    var fileName = 'image-' + Date.now() + '.jpg';
    var filePath = propertyId + '/' + fileName;
    
    // Upload to Supabase Storage
    supabase.storage
        .from('property-images')
        .upload(filePath, file)
        .then(function(response) {
            if (response.error) {
                console.error('Upload error:', response.error);
                return;
            }
            
            // Get public URL
            var publicUrl = supabase.storage
                .from('property-images')
                .getPublicUrl(filePath);
            
            console.log('Image uploaded:', publicUrl.data.publicUrl);
            return publicUrl.data.publicUrl;
        })
        .catch(function(error) {
            console.error('Error:', error);
        });
}

// Upload multiple images
function uploadMultipleImages(files, propertyId) {
    var uploadPromises = [];
    
    for (var i = 0; i < files.length; i++) {
        var file = files[i];
        var fileName = 'image-' + i + '-' + Date.now() + '.jpg';
        var filePath = propertyId + '/' + fileName;
        
        var promise = supabase.storage
            .from('property-images')
            .upload(filePath, file);
        
        uploadPromises.push(promise);
    }
    
    // Wait for all uploads to complete
    Promise.all(uploadPromises)
        .then(function(results) {
            var imageUrls = [];
            
            results.forEach(function(result, index) {
                if (!result.error) {
                    var filePath = propertyId + '/image-' + index + '-' + Date.now() + '.jpg';
                    var publicUrl = supabase.storage
                        .from('property-images')
                        .getPublicUrl(filePath);
                    
                    imageUrls.push(publicUrl.data.publicUrl);
                }
            });
            
            console.log('All images uploaded:', imageUrls);
            return imageUrls;
        });
}
```

---

## 🖼️ **COMPLETE SELLER SUBMISSION FLOW WITH FILE UPLOAD**

### **Step-by-Step Process:**

```javascript
// STEP 1: User fills out property form
var propertyData = {
    title: 'Beautiful Villa in Accra',
    description: '4 bedroom villa...',
    price: 250000,
    location: 'East Legon, Accra',
    // ... other fields
};

// STEP 2: Generate temporary property ID (before saving to database)
var tempPropertyId = 'temp-' + Date.now();

// STEP 3: Upload images to Supabase Storage
var imageFiles = document.getElementById('property-images').files;
var uploadedImageUrls = [];

function uploadAllImages(files, propertyId, callback) {
    var uploadCount = 0;
    var totalFiles = files.length;
    var urls = [];
    
    Array.from(files).forEach(function(file, index) {
        var fileName = 'image-' + index + '-' + Date.now() + '.' + file.name.split('.').pop();
        var filePath = propertyId + '/' + fileName;
        
        supabase.storage
            .from('property-images')
            .upload(filePath, file)
            .then(function(uploadResponse) {
                if (uploadResponse.error) {
                    console.error('Upload failed:', uploadResponse.error);
                    return;
                }
                
                // Get public URL
                var urlResponse = supabase.storage
                    .from('property-images')
                    .getPublicUrl(filePath);
                
                urls.push(urlResponse.data.publicUrl);
                uploadCount++;
                
                // When all uploads complete
                if (uploadCount === totalFiles) {
                    callback(urls);
                }
            });
    });
}

// STEP 4: After images uploaded, save property to database
uploadAllImages(imageFiles, tempPropertyId, function(imageUrls) {
    // Save property to database with image URLs
    var propertyToSave = {
        type: 'seller',
        status: 'pending',
        title: propertyData.title,
        description: propertyData.description,
        price: propertyData.price,
        location: propertyData.location,
        images: imageUrls, // Array of URLs
        featured_image: imageUrls[0], // First image as featured
        seller_name: 'John Doe',
        seller_email: 'john@example.com',
        created_by: 'seller',
        listing_fee_paid: false
    };
    
    supabase
        .from('properties')
        .insert([propertyToSave])
        .then(function(response) {
            if (response.error) {
                console.error('Error saving property:', response.error);
                return;
            }
            
            var propertyId = response.data[0].id;
            
            // STEP 5: Redirect to Stripe Checkout
            redirectToStripeCheckout(propertyId);
        });
});

// STEP 6: Redirect to Stripe for payment
function redirectToStripeCheckout(propertyId) {
    // Create Stripe Checkout session with property ID
    // After payment, webhook updates property.listing_fee_paid = true
    window.location.href = 'https://checkout.stripe.com/...';
}
```

---

## 🔒 **STORAGE SECURITY (Storage Policies)**

### **Public Read, Controlled Write:**

```sql
-- Anyone can VIEW images (public bucket)
CREATE POLICY "Public can view property images"
ON storage.objects FOR SELECT
USING (bucket_id = 'property-images');

-- Anyone can UPLOAD images (for seller submissions)
-- But files are organized by property ID, and property approval controls visibility
CREATE POLICY "Anyone can upload property images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'property-images');

-- Only admins can DELETE images
CREATE POLICY "Admins can delete property images"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'property-images' AND
  auth.uid() IN (SELECT id FROM admin_users)
);
```

**Security Model:**
- ✅ Anyone can upload images (sellers need to submit photos)
- ✅ Anyone can view images (public bucket - needed for property browsing)
- ✅ Only admins can delete images
- ✅ Unapproved properties don't show on public site (controlled at database level, not storage level)

---

## 📊 **DATABASE STORAGE REFERENCE**

### **How URLs are Stored in PostgreSQL:**

```sql
-- properties table schema (relevant parts)
CREATE TABLE properties (
  id UUID PRIMARY KEY,
  
  -- Image URLs stored as JSONB array
  images JSONB DEFAULT '[]',
  
  -- Example value:
  -- ["https://xyz.supabase.co/storage/v1/object/public/property-images/abc-123/img1.jpg",
  --  "https://xyz.supabase.co/storage/v1/object/public/property-images/abc-123/img2.jpg",
  --  "https://xyz.supabase.co/storage/v1/object/public/property-images/abc-123/img3.jpg"]
  
  -- Featured image (main thumbnail)
  featured_image TEXT,
  
  -- Example value:
  -- "https://xyz.supabase.co/storage/v1/object/public/property-images/abc-123/img1.jpg"
  
  -- Optional: Document URLs (land titles, etc.)
  documentation_urls TEXT[]
  
  -- Example value:
  -- ["https://xyz.supabase.co/storage/v1/object/public/property-images/abc-123/documents/title.pdf"]
);
```

**Querying Images:**
```sql
-- Get all images for a property
SELECT images FROM properties WHERE id = 'property-uuid';

-- Returns: ["url1", "url2", "url3"]
```

**In JavaScript:**
```javascript
// Fetch property with images
supabase
    .from('properties')
    .select('*')
    .eq('id', propertyId)
    .then(function(response) {
        var property = response.data[0];
        var images = property.images; // Array of URLs
        
        // Display images
        images.forEach(function(imageUrl) {
            var img = document.createElement('img');
            img.src = imageUrl;
            document.body.appendChild(img);
        });
    });
```

---

## 🎨 **IMAGE OPTIMIZATION (Optional but Recommended)**

### **Client-Side Compression Before Upload:**

```javascript
// Compress image before uploading (reduce file size)
function compressImage(file, maxWidth, quality, callback) {
    var reader = new FileReader();
    
    reader.onload = function(event) {
        var img = new Image();
        
        img.onload = function() {
            var canvas = document.createElement('canvas');
            var ctx = canvas.getContext('2d');
            
            // Calculate new dimensions
            var width = img.width;
            var height = img.height;
            
            if (width > maxWidth) {
                height = (height * maxWidth) / width;
                width = maxWidth;
            }
            
            canvas.width = width;
            canvas.height = height;
            
            // Draw resized image
            ctx.drawImage(img, 0, 0, width, height);
            
            // Convert to blob
            canvas.toBlob(function(blob) {
                callback(blob);
            }, 'image/jpeg', quality);
        };
        
        img.src = event.target.result;
    };
    
    reader.readAsDataURL(file);
}

// Usage
var originalFile = document.getElementById('image-input').files[0];

compressImage(originalFile, 1920, 0.8, function(compressedBlob) {
    // Upload compressed image instead of original
    uploadPropertyImage(compressedBlob, propertyId);
});
```

---

## 📏 **FILE SIZE LIMITS & BEST PRACTICES**

### **Recommended Limits:**

**Per File:**
- Max size: 5MB per image (enforced at bucket level)
- Recommended: Compress to 500KB - 1MB per image

**Per Property:**
- Max images: 10-15 images per property
- Total per property: ~5-10MB

**Free Tier Capacity:**
- 1GB storage = ~1,000 properties @ 1MB average
- 2GB bandwidth/month = ~20,000 image views/month

### **Storage Bucket Configuration:**

```javascript
// When creating bucket in Supabase Dashboard
{
  "public": true,
  "fileSizeLimit": 5242880, // 5MB in bytes
  "allowedMimeTypes": [
    "image/jpeg",
    "image/jpg", 
    "image/png",
    "image/webp"
  ]
}
```

---

## 🚀 **FILE UPLOAD UI BEST PRACTICES**

### **Drag & Drop Upload Interface:**

```html
<div id="upload-zone" class="upload-zone">
    <p>Drag & drop images here or click to select</p>
    <input type="file" id="file-input" multiple accept="image/*" style="display: none;">
</div>

<div id="preview-container"></div>

<script>
var uploadZone = document.getElementById('upload-zone');
var fileInput = document.getElementById('file-input');
var previewContainer = document.getElementById('preview-container');

// Click to select files
uploadZone.addEventListener('click', function() {
    fileInput.click();
});

// Drag & drop
uploadZone.addEventListener('dragover', function(e) {
    e.preventDefault();
    uploadZone.classList.add('dragover');
});

uploadZone.addEventListener('dragleave', function(e) {
    uploadZone.classList.remove('dragover');
});

uploadZone.addEventListener('drop', function(e) {
    e.preventDefault();
    uploadZone.classList.remove('dragover');
    
    var files = e.dataTransfer.files;
    handleFiles(files);
});

// File selection
fileInput.addEventListener('change', function(e) {
    var files = e.target.files;
    handleFiles(files);
});

// Handle and preview files
function handleFiles(files) {
    previewContainer.innerHTML = '';
    
    Array.from(files).forEach(function(file) {
        // Create preview
        var reader = new FileReader();
        
        reader.onload = function(e) {
            var img = document.createElement('img');
            img.src = e.target.result;
            img.className = 'preview-image';
            previewContainer.appendChild(img);
        };
        
        reader.readAsDataURL(file);
    });
}
</script>
```

---

## 🔄 **FILE DELETION (Admin Only)**

### **Delete Property Images:**

```javascript
// Delete all images for a property
function deletePropertyImages(propertyId) {
    // List all files in property folder
    supabase.storage
        .from('property-images')
        .list(propertyId)
        .then(function(response) {
            if (response.error) {
                console.error('Error listing files:', response.error);
                return;
            }
            
            var files = response.data;
            var filePaths = files.map(function(file) {
                return propertyId + '/' + file.name;
            });
            
            // Delete all files
            return supabase.storage
                .from('property-images')
                .remove(filePaths);
        })
        .then(function(deleteResponse) {
            if (deleteResponse.error) {
                console.error('Error deleting files:', deleteResponse.error);
            } else {
                console.log('All images deleted');
            }
        });
}
```

---

## 📦 **SUMMARY**

### **Where Files Live:**
✅ **Supabase Storage** (S3-compatible, globally distributed)
✅ **Public URLs** (directly accessible via HTTPS)
✅ **Organized by property ID** (clean folder structure)

### **How Upload Works:**
✅ **Direct browser → Supabase** (no backend server needed!)
✅ **URLs saved in PostgreSQL** (easy to query and display)
✅ **Secure & Scalable** (Row Level Security + Storage Policies)

### **Cost:**
✅ **Free tier: 1GB storage** (enough for 1000+ properties)
✅ **After free tier: $0.021/GB** (very affordable)

---

**Ready to start building the upload interface?** 🚀
