# Fix "Multiple commands produce Info.plist" Error

## The Problem

Xcode is trying to process Info.plist twice:
1. Automatically (as part of the build process)
2. Manually (if it's in Copy Bundle Resources)

## Solution: Remove Info.plist from Copy Bundle Resources

### Step 1: Check Build Phases

1. **Click blue project icon** in Navigator
2. **Go to "Build Phases" tab**
3. **Expand "Copy Bundle Resources"** section
4. **Look for `Info.plist`** in the list

### Step 2: Remove Info.plist

1. **If you see `Info.plist` in "Copy Bundle Resources":**
   - **Select it**
   - **Click the "-" button** to remove it
   - **Info.plist should NOT be in Copy Bundle Resources**

2. **Info.plist should only be:**
   - In the project Navigator (as a file)
   - Referenced in Build Settings → Info.plist File

### Step 3: Verify Build Settings

1. **Still in project settings**, go to **"Build Settings" tab**
2. **Search for "Info.plist"** in the search box
3. **Find "Info.plist File"** setting
4. **Make sure it says:** `HealthReportApp/Info.plist` (or just `Info.plist`)

### Step 4: Clean and Rebuild

1. **Clean Build Folder**: ⇧⌘K
2. **Build**: ⌘B
3. **Error should be gone!**

## Why This Happens

- **Info.plist is special** - Xcode processes it automatically
- **It should NOT be copied** like other resources
- **It should only be referenced** in Build Settings

## Quick Checklist

- [ ] Went to Build Phases tab
- [ ] Expanded "Copy Bundle Resources"
- [ ] Removed Info.plist if it was there
- [ ] Verified Build Settings → Info.plist File is set correctly
- [ ] Cleaned build folder (⇧⌘K)
- [ ] Built successfully (⌘B)

## Alternative: If Info.plist is Not in Copy Bundle Resources

If Info.plist is NOT in Copy Bundle Resources but you still get the error:

1. **Check if there are multiple Info.plist files** in the project
2. **Check Build Settings** → Search for "Info.plist"
3. **Make sure only ONE Info.plist path is set**
