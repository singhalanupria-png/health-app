# How to Delete Derived Data

## Method 1: From Xcode Locations Settings (What You're Seeing)

1. **In Xcode**, you're already in **Settings → Locations**
2. **Find "Derived Data"** section
3. **Click the arrow** (→) next to the path: `/Users/abhisheknarwal/Library/Developer/Xcode/DerivedData`
4. **This opens Finder** to the DerivedData folder
5. **Find the folder** that starts with "HealthReportApp" (or contains your project name)
6. **Delete that entire folder** (drag to Trash or right-click → Move to Trash)
7. **Close Finder**
8. **Back in Xcode**, clean and rebuild: ⇧⌘K then ⌘B

## Method 2: Delete All Derived Data (Nuclear Option)

If you can't find the specific folder:

1. **In Xcode Settings → Locations**
2. **Click the arrow** next to Derived Data path
3. **In Finder**, you'll see all project folders
4. **Delete the entire DerivedData folder** (or just the HealthReportApp one if you can find it)
5. **Xcode will recreate it** when you build next time

## Method 3: Terminal Command (Easiest)

Open Terminal and run:

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/HealthReportApp-*
```

Or delete all Derived Data:

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/*
```

## After Deleting Derived Data

1. **Clean Build Folder**: ⇧⌘K
2. **Build**: ⌘B
3. **Check if error is resolved**

## If Error Persists: Check Build Phases

The "Multiple commands produce" error can also be caused by:

### Check Compile Sources

1. **Click blue project icon**
2. **Go to "Build Phases" tab**
3. **Expand "Compile Sources"**
4. **Look for any file listed TWICE**
5. **If you see duplicates**, remove one by selecting it and clicking "-"

### Check Target Membership

1. **Select any Swift file** in Navigator
2. **In right sidebar** (File Inspector), check "Target Membership"
3. **Make sure files are only in "HealthReportApp" target** (not in Tests targets)

### Check for Duplicate File References

1. **In Navigator**, look for any files that appear in **red** (missing)
2. **Right-click** → **Delete** (Remove Reference)
3. **Re-add** from correct location if needed

## Quick Checklist

- [ ] Deleted Derived Data folder
- [ ] Cleaned build folder (⇧⌘K)
- [ ] Checked Build Phases → Compile Sources for duplicates
- [ ] Checked Target Membership
- [ ] Built project (⌘B)
- [ ] Error resolved
