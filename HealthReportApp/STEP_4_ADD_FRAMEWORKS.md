# Step 4: Add Required Frameworks - Detailed Guide

## Frameworks to Add

1. **Vision.framework** - For OCR (text recognition from images)
2. **PDFKit.framework** - For PDF parsing

## Step-by-Step Instructions

### 1. Open Project Settings

1. **In Xcode Navigator** (left sidebar), click on the **blue project icon** at the top
   - It should say "HealthReportApp" with a blue icon
   - This is the project, not the yellow folder

2. **In the main editor area**, you'll see project settings

3. **Make sure you're on the "General" tab** (should be selected by default)

### 2. Find Frameworks Section

1. **Scroll down** in the General tab

2. **Look for the section called:**
   - **"Frameworks, Libraries, and Embedded Content"**
   - It's usually near the bottom of the General tab

3. **You might see some frameworks already listed** (like SwiftUI, Foundation, etc.)

### 3. Add Vision Framework

1. **Click the "+" button** at the bottom of the "Frameworks, Libraries, and Embedded Content" section

2. **A dialog box will appear** with a list of frameworks

3. **In the search box**, type: `Vision`

4. **Select "Vision.framework"** from the list

5. **Click "Add"**

6. **After adding**, make sure the dropdown next to it says **"Do Not Embed"** (this is the default and correct for system frameworks)

### 4. Add PDFKit Framework

1. **Click the "+" button** again

2. **In the search box**, type: `PDFKit`

3. **Select "PDFKit.framework"** from the list

4. **Click "Add"**

5. **Make sure it's set to "Do Not Embed"**

### 5. Verify

Your "Frameworks, Libraries, and Embedded Content" section should now show:
- Vision.framework (Do Not Embed)
- PDFKit.framework (Do Not Embed)
- Plus any other frameworks that were already there

## Visual Guide

```
Xcode Window:
├── Left Sidebar
│   └── 📁 HealthReportApp (blue project icon) ← CLICK THIS
│
└── Main Editor (General tab)
    └── Scroll down to:
        └── Frameworks, Libraries, and Embedded Content
            ├── [Existing frameworks...]
            ├── Vision.framework [Do Not Embed ▼] ← ADDED
            └── PDFKit.framework [Do Not Embed ▼] ← ADDED
            └── [+] ← Click to add
```

## Important Notes

- **"Do Not Embed"** is correct for system frameworks like Vision and PDFKit
- These frameworks are part of iOS, so they don't need to be embedded in your app
- If you see "Embed & Sign" or "Embed Without Signing", change it to "Do Not Embed"

## Troubleshooting

### Can't find "Frameworks, Libraries, and Embedded Content" section?

1. Make sure you clicked the **blue project icon** (not the yellow folder)
2. Make sure you're on the **"General" tab**
3. Scroll down - it's usually at the bottom

### Framework not in the list?

1. Make sure you're searching correctly
2. Try typing the full name: "Vision.framework" or "PDFKit.framework"
3. These are system frameworks, so they should always be available

### Wrong embedding option?

1. Click the dropdown next to the framework
2. Select **"Do Not Embed"**
3. This is the correct option for system frameworks

## After Adding Frameworks

1. **Build the project**: Press ⌘B
2. **Check for errors**: Should build successfully
3. **If you see import errors**, make sure the frameworks are added correctly

## Quick Checklist

- [ ] Clicked blue project icon
- [ ] Went to "General" tab
- [ ] Found "Frameworks, Libraries, and Embedded Content" section
- [ ] Added Vision.framework (set to "Do Not Embed")
- [ ] Added PDFKit.framework (set to "Do Not Embed")
- [ ] Built project successfully (⌘B)
- [ ] No import errors

## Next Step

After adding frameworks, move to **Step 5: Test Basic Build**
