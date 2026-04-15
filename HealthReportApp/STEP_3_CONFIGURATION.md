# Step 3: Configure Project Settings - Detailed Guide

## What You Need to Do

1. Set Deployment Target to iOS 16.0
2. Verify Info.plist is linked
3. Check permissions are configured

## Step-by-Step Instructions

### 1. Set Deployment Target to iOS 16.0

1. **In Xcode**, click on the **blue project icon** at the top of the Navigator (left sidebar)
   - It should be named "HealthReportApp" with a blue icon

2. **In the main editor area**, you'll see project settings with tabs at the top:
   - General
   - Signing & Capabilities
   - Build Settings
   - etc.

3. **Click on the "General" tab** (should be selected by default)

4. **Find "Deployment Info" section** (usually near the top)

5. **Look for "iOS Deployment Target"** dropdown

6. **Click the dropdown** and select **"16.0"** (or the highest available version that's 16.0 or later)

   If you don't see 16.0:
   - Select the highest version available (like 17.0, 17.1, etc.)
   - Make sure it's at least 16.0

### 2. Verify Info.plist is Linked

1. **Still in the project settings**, click on the **"Build Phases" tab** (at the top)

2. **Expand "Copy Bundle Resources"** section (click the arrow to expand)

3. **Look for `Info.plist`** in the list

4. **If Info.plist is NOT in the list:**
   - Click the **"+" button** at the bottom of the "Copy Bundle Resources" section
   - Navigate to and select `Info.plist`
   - Click "Add"

5. **If Info.plist IS in the list:**
   - ✅ You're good! Move to step 3

### 3. Verify Info.plist Configuration

1. **In Xcode Navigator** (left sidebar), click on `Info.plist` to open it

2. **You should see entries like:**
   ```
   NSCameraUsageDescription
   NSPhotoLibraryUsageDescription
   NSPhotoLibraryAddUsageDescription
   ```

3. **If these entries are missing:**
   - The Info.plist might not be the correct one
   - Make sure you added the Info.plist from `/Users/abhisheknarwal/HealthReportApp/HealthReportApp/Info.plist`

## Visual Guide

### Project Settings Location:
```
Xcode Window:
├── Left Sidebar (Navigator)
│   └── 📁 HealthReportApp (blue project icon) ← CLICK THIS
│
└── Main Editor Area
    ├── [General] [Signing & Capabilities] [Build Settings] [Build Phases] ← TABS
    │
    └── Deployment Info
        └── iOS Deployment Target: [16.0 ▼] ← SET THIS
```

### Build Phases Location:
```
After clicking "Build Phases" tab:
├── Compile Sources
├── Link Binary With Libraries
└── Copy Bundle Resources ← EXPAND THIS
    ├── Assets.xcassets
    └── Info.plist ← SHOULD BE HERE
```

## Quick Checklist

- [ ] Clicked blue project icon in Navigator
- [ ] Went to "General" tab
- [ ] Set "iOS Deployment Target" to 16.0 or higher
- [ ] Went to "Build Phases" tab
- [ ] Expanded "Copy Bundle Resources"
- [ ] Verified Info.plist is in the list
- [ ] Opened Info.plist and verified permissions are there

## Troubleshooting

### Can't find Deployment Target?
- Make sure you clicked the **blue project icon** (not the yellow folder)
- Look in the "General" tab, not "Build Settings"
- It's in the "Deployment Info" section

### Info.plist not showing in Build Phases?
- Make sure you added it to the project correctly
- Try removing and re-adding it
- Check that it's in the main app folder (yellow folder)

### Info.plist doesn't have permissions?
- You might have added the wrong Info.plist
- Delete it and re-add from `/Users/abhisheknarwal/HealthReportApp/HealthReportApp/Info.plist`
- Or manually add the permission keys (see below)

## Manual Permission Setup (If Needed)

If Info.plist doesn't have the permissions, you can add them manually:

1. Click on `Info.plist` in Navigator
2. Right-click in the editor → "Add Row"
3. Add these three entries:

**Entry 1:**
- Key: `Privacy - Camera Usage Description` (or `NSCameraUsageDescription`)
- Type: String
- Value: `We need access to your camera to take photos of health reports.`

**Entry 2:**
- Key: `Privacy - Photo Library Usage Description` (or `NSPhotoLibraryUsageDescription`)
- Type: String
- Value: `We need access to your photo library to select health report images.`

**Entry 3:**
- Key: `Privacy - Photo Library Additions Usage Description` (or `NSPhotoLibraryAddUsageDescription`)
- Type: String
- Value: `We need access to save processed health reports to your photo library.`

## Next Step

After completing Step 3, move to **Step 4: Add Required Frameworks**
