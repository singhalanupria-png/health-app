# Fix "Build input file cannot be found: Info.plist"

## The Problem

Xcode is looking for Info.plist at:
- `/Users/abhisheknarwal/Desktop/HealthReportApp/Info.plist` ❌ (wrong location)

But it's actually at:
- `/Users/abhisheknarwal/Desktop/HealthReportApp/HealthReportApp/Info.plist` ✅ (correct location)

## Solution: Fix the Path in Build Settings

### Step 1: Open Build Settings

1. **Click blue project icon** in Navigator
2. **Select the target "HealthReportApp"** (under TARGETS, not PROJECT)
3. **Go to "Build Settings" tab**
4. **In the search box**, type: `Info.plist`

### Step 2: Fix Info.plist File Path

1. **Find "Info.plist File"** setting (under "Packaging" section)
2. **Click on the value** (it probably says `Info.plist` or wrong path)
3. **Change it to:** `HealthReportApp/Info.plist`
   - Or click the folder icon and navigate to the correct file
4. **Press Enter** to save

### Step 3: Verify the Path

1. **Select Info.plist** in Navigator
2. **Right sidebar** → "Identity and Type"
3. **Check "Full Path"** - should show the correct location
4. **Check "Location"** - should be "Relative to Group"

### Step 4: Clean and Rebuild

1. **Clean Build Folder**: ⇧⌘K
2. **Build**: ⌘B
3. **Error should be fixed!**

## Alternative: If Path Doesn't Work

If setting `HealthReportApp/Info.plist` doesn't work:

1. **Click the folder icon** next to "Info.plist File" setting
2. **Navigate to:** `/Users/abhisheknarwal/Desktop/HealthReportApp/HealthReportApp/`
3. **Select `Info.plist`**
4. **Click "Open"**

## Quick Checklist

- [ ] Selected target "HealthReportApp" (not project)
- [ ] Went to Build Settings tab
- [ ] Searched for "Info.plist"
- [ ] Changed "Info.plist File" to `HealthReportApp/Info.plist`
- [ ] Cleaned build folder (⇧⌘K)
- [ ] Built successfully (⌘B)

## Important Note

Make sure you're editing the **TARGET** settings, not the **PROJECT** settings:
- Click blue project icon
- Under "TARGETS" (not "PROJECT"), click "HealthReportApp"
- Then go to Build Settings
