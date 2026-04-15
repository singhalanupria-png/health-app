# Fix "Multiple commands produce Info.plist" Error

## The Problem

Xcode is trying to process Info.plist twice:
1. Automatically generating it (because "Generate Info.plist File" = "Yes")
2. Using your custom Info.plist file

## Solution: Set "Generate Info.plist File" to "No"

### Step 1: Open Build Settings

1. **Click blue project icon** in Navigator
2. **Select target "HealthReportApp"** (under TARGETS, not PROJECT)
3. **Go to "Build Settings" tab**
4. **In search box**, type: `Generate Info.plist`

### Step 2: Change Setting

1. **Find "Generate Info.plist File"** in the list
2. **Double-click the value "Yes"**
3. **Change it to "No"**
4. **Press Enter**

### Step 3: Verify Info.plist File Path

1. **Still in Build Settings**, search for: `Info.plist File`
2. **Find "Info.plist File"** setting
3. **Should say**: `HealthReportApp/Info.plist`
4. **If it's different**, change it to `HealthReportApp/Info.plist`

### Step 4: Check Copy Bundle Resources

1. **Go to "Build Phases" tab**
2. **Expand "Copy Bundle Resources"**
3. **Make sure Info.plist is NOT in the list**
4. **If it is**, remove it (select and click "-")

### Step 5: Clean and Rebuild

1. **Clean Build Folder**: Press **⇧⌘K**
2. **Delete Derived Data** (if needed):
   - Xcode → Settings (⌘,)
   - Locations tab
   - Click arrow next to Derived Data
   - Delete HealthReportApp folder
3. **Build**: Press **⌘B**

## Quick Checklist

- [ ] "Generate Info.plist File" = "No"
- [ ] "Info.plist File" = "HealthReportApp/Info.plist"
- [ ] Info.plist NOT in Copy Bundle Resources
- [ ] Cleaned build folder (⇧⌘K)
- [ ] Built successfully (⌘B)

## Why This Happens

When you have a custom Info.plist file:
- "Generate Info.plist File" should be **"No"**
- Xcode will use your custom file instead of generating one
