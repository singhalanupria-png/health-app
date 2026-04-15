# Fix "Multiple commands produce" Error - Complete Guide

## ✅ Derived Data Deleted

I've deleted your Derived Data folder. Now follow these steps:

## Step 1: Clean and Rebuild

1. **In Xcode**, press **⇧⌘K** (Clean Build Folder)
2. **Press ⌘B** (Build)
3. **Check if error is gone**

## Step 2: If Error Persists - Check Build Phases

The error can also be caused by duplicate entries in Build Phases:

### Check Compile Sources

1. **Click blue project icon** in Navigator
2. **Go to "Build Phases" tab**
3. **Expand "Compile Sources"** section
4. **Look through the list** - do you see any file listed **TWICE**?
5. **If yes**, select the duplicate and click the **"-" button** to remove it

### Check Copy Bundle Resources

1. **Still in Build Phases tab**
2. **Expand "Copy Bundle Resources"**
3. **Check if Info.plist or any file appears twice**
4. **Remove duplicates** if found

## Step 3: Check Target Membership

Sometimes files are accidentally added to multiple targets:

1. **Select any Swift file** in Navigator (like ContentView.swift)
2. **Look at the right sidebar** (File Inspector)
3. **Find "Target Membership" section**
4. **Make sure only "HealthReportApp" is checked** (not HealthReportAppTests or HealthReportAppUITests)

### Check All Files

Do this for a few key files:
- ContentView.swift
- HealthReportAppApp.swift
- Any file in Models/, Views/, Services/

## Step 4: Check for File References Issues

1. **In Navigator**, look for any files that show in **red** (missing files)
2. **Right-click** → **Delete** (Remove Reference)
3. **Re-add** from correct location if needed

## Step 5: Check Build Settings

1. **Click blue project icon**
2. **Go to "Build Settings" tab**
3. **Search for "Info.plist"**
4. **Find "Info.plist File" setting**
5. **Make sure it says**: `HealthReportApp/Info.plist` (not duplicated)

## Alternative: Remove and Re-add Files

If nothing works, try this:

1. **Remove all Swift files** from project (right-click → Delete → Remove Reference)
2. **Clean Build Folder**: ⇧⌘K
3. **Re-add files one folder at a time**:
   - Add Models/ folder → Build (⌘B)
   - Add Views/ folder → Build (⌘B)
   - Add Services/ folder → Build (⌘B)

## Quick Checklist

- [x] Derived Data deleted (done!)
- [ ] Cleaned build folder (⇧⌘K)
- [ ] Built project (⌘B)
- [ ] Checked Build Phases → Compile Sources for duplicates
- [ ] Checked Target Membership
- [ ] Error resolved

## Most Common Cause

After Derived Data, the most common cause is **duplicate entries in Build Phases → Compile Sources**. Check that first!
