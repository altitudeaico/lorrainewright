#!/bin/bash

# Fix navigation links in all HTML files
# Change from /new-page to new-page.html

for file in new-home.html new-about.html new-book-call.html new-contact.html; do
    if [ -f "$file" ]; then
        echo "Fixing links in $file..."
        
        # Fix navigation menu links
        sed -i 's|href="/new-home"|href="new-home.html"|g' "$file"
        sed -i 's|href="/new-about"|href="new-about.html"|g' "$file"
        sed -i 's|href="/new-services"|href="new-services.html"|g' "$file"
        sed -i 's|href="/new-properties"|href="new-properties.html"|g' "$file"
        sed -i 's|href="/new-resources"|href="new-resources.html"|g' "$file"
        sed -i 's|href="/new-contact"|href="new-contact.html"|g' "$file"
        sed -i 's|href="/new-book-call"|href="new-book-call.html"|g' "$file"
        
        # Fix other internal links
        sed -i 's|href="/choose-free-guide"|href="choose-free-guide.html"|g' "$file"
        
        echo "  ✅ Fixed $file"
    fi
done

echo ""
echo "All links fixed!"
