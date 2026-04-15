# Fix "Multiple commands produce" Error

## The Problem

This error means Xcode is trying to compile the same file twice. This usually happens when:
- A file is added to the project twice
- A file exists in multiple locations
- Build settings have duplicate references

## Solution: Remove Duplicate Files

### Step 1: Find the Duplicate

1. **In Xcode Navigator**, look for `ContentView.swift`
2. **Check if it appears in TWO places:**
   - At the root level of HealthReportApp folder
   - Inside the Views/ folder

### Step 2: Remove the Duplicate

**Option A: Keep the one in Views/ folder (Recommended)**

1. Find `ContentView.swift` at the **root level** (not in Views/)
2. **Right-click** on it
3. Select **"Delete"**
4. Choose **"Move to Trash"** (or "Remove Reference" if you want to keep the file on disk)

**Option B: Check Build Phases**

1. Click **blue project icon**
2. Go to **"Build Phases" tab**
3. Expand **"Compile Sources"**
4. Look for duplicate entries (same file listed twice)
5. If you see `ContentView.swift` twice, remove one by clicking the "-" button

### Step 3: Check for Other Duplicates

Look for these files that might be duplicated:
- `HealthReportAppApp.swift` (should only be at root level)
- Any Swift files that appear in multiple locations

### Step 4: Clean and Rebuild

1. **Clean Build Folder**: ⇧⌘K (Shift + Command + K)
2. **Delete Derived Data** (if cleaning doesn't work):
   - Xcode → Settings → Locations
   - Click arrow next to Derived Data path
   - Delete the folder for your project
3. **Build**: ⌘B

## Alternative: Check File References

### If files are in wrong location:

1. In Navigator, check where files are located
2. Files should be:
   - `HealthReportAppApp.swift` → Root level
   - `ContentView.swift` → Inside Views/ folder
   - All other views → Inside Views/ folder
   - All models → Inside Models/ folder
   - All services → Inside Services/ folder

### If a file shows as red (missing):

1. Right-click the red file
2. Select "Delete"
3. Re-add it from the correct location

## Nuclear Option: Remove and Re-add

If nothing works:

1. **Remove all Swift files** from project (not from disk, just references)
2. **Clean Build Folder**: ⇧⌘K
3. **Re-add files** one folder at a time:
   - Add Models/ folder
   - Build (⌘B) - should succeed
   - Add Views/ folder
   - Build (⌘B) - should succeed
   - Add Services/ folder
   - Build (⌘B) - should succeed

## Quick Checklist

- [ ] Checked for duplicate ContentView.swift
- [ ] Removed duplicate file
- [ ] Checked Build Phases → Compile Sources for duplicates
- [ ] Cleaned build folder (⇧⌘K)
- [ ] Deleted Derived Data (if needed)
- [ ] Built successfully (⌘B)
- [ ] Error resolved
