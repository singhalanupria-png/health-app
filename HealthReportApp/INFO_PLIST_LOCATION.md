# Where to Add Info.plist in Xcode

## Location: Main App Folder (Same Level as Models, Views, Services)

The `Info.plist` file should be added to the **main app folder** - the same folder that contains your `Models/`, `Views/`, and `Services/` folders.

## Visual Guide

In Xcode Navigator, it should look like this:

```
📁 HealthReportApp (blue project icon)
  📁 HealthReportApp (yellow folder icon) ← Main app folder
    📄 HealthReportAppApp.swift
    📁 Models (yellow folder)
    📁 Views (yellow folder)
    📁 Services (yellow folder)
    📄 Info.plist ← ADD IT HERE (same level as folders)
    📁 Assets.xcassets
```

## Step-by-Step Instructions

1. **In Xcode Navigator**, find the yellow folder named `HealthReportApp` (the main app folder)

2. **Right-click on that yellow folder** (the one containing Models, Views, Services)

3. **Select "Add Files to 'HealthReportApp'..."**

4. **Navigate to:** `/Users/abhisheknarwal/HealthReportApp/HealthReportApp/`

5. **Select `Info.plist`**

6. **Important Options:**
   - ✅ Check "Copy items if needed" (if file isn't already in project location)
   - ✅ Make sure "Add to targets: HealthReportApp" is checked
   - ✅ Choose "Create groups" (default)

7. **Click "Add"**

## Result

After adding, your Xcode Navigator should show:

```
📁 HealthReportApp (project)
  📁 HealthReportApp (main app folder)
    📄 HealthReportAppApp.swift
    📁 Models
    📁 Views
    📁 Services
    📄 Info.plist ← Should appear here
    📁 Assets.xcassets
```

## Important Notes

- **NOT** in the blue project icon (top level)
- **NOT** inside Models, Views, or Services folders
- **YES** in the yellow main app folder, at the same level as the other folders
- The file should appear as a **yellow document icon** (not a blue folder)

## Verify It's Added Correctly

1. Click on `Info.plist` in Xcode
2. You should see it open in the editor
3. It should contain entries like:
   - `NSCameraUsageDescription`
   - `NSPhotoLibraryUsageDescription`
   - `NSPhotoLibraryAddUsageDescription`

## If You Already Have an Info.plist

If Xcode created a default `Info.plist`:
1. Delete the default one
2. Add the one from `/Users/abhisheknarwal/HealthReportApp/HealthReportApp/Info.plist`
3. Or copy the contents from our Info.plist into the existing one
