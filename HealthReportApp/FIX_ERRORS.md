# How to Fix the 5 Errors

## Step 1: See What the Errors Are

1. **Click the red "5" error icon** in the top toolbar
2. Or press **⌘5** to open Issue Navigator
3. This shows all errors and warnings

## Step 2: Common Fixes

### If Errors Say "Cannot Find Type" or "No Such Module"

**Missing Frameworks - Add These:**

1. Click the **blue project icon** (HealthReportApp) in Navigator
2. Select the **target** "HealthReportApp" (under TARGETS)
3. Go to **"General" tab**
4. Scroll to **"Frameworks, Libraries, and Embedded Content"**
5. Click the **"+" button**
6. Add these frameworks:
   - `Vision.framework`
   - `PDFKit.framework`
7. Make sure they're set to **"Do Not Embed"**

### If Errors Say "Cannot Find File" or Missing Imports

**Missing Swift Files - Add These:**

1. In Navigator, right-click the **yellow HealthReportApp folder**
2. Select **"Add Files to 'HealthReportApp'..."**
3. Navigate to where your files are
4. Select these folders:
   - `Models/` folder
   - `Views/` folder  
   - `Services/` folder
5. Make sure:
   - ✅ "Copy items if needed" is checked
   - ✅ "Create groups" is selected (NOT folder references)
   - ✅ "Add to targets: HealthReportApp" is checked
6. Click "Add"

### If Errors Are About Info.plist

**Check Build Settings:**

1. Click **blue project icon**
2. Go to **"Build Settings" tab**
3. Search for "Info.plist"
4. Find **"Info.plist File"** setting
5. Make sure it says: `HealthReportApp/Info.plist`

## Step 3: Clean and Rebuild

After fixing:
1. **Product → Clean Build Folder** (⇧⌘K)
2. **Product → Build** (⌘B)
3. Check if errors are gone

## Still Have Errors?

**Share the error messages** and I can help fix them specifically!

Common error patterns:
- "No such module 'Vision'" → Add Vision framework
- "Cannot find 'Report' in scope" → Add Models folder
- "Use of unresolved identifier" → Missing imports
