# Fix Both Errors

## Error 1: Generate Info.plist File

**Problem:** "Generate Info.plist File" is set to "Yes" - this makes Xcode generate Info.plist automatically, conflicting with your existing file.

**Fix:**
1. **In Build Settings** (where you are now)
2. **Find "Generate Info.plist File"** (you can see it in the list)
3. **Double-click the value** "Yes"
4. **Change it to "No"**
5. **Press Enter**

## Error 2: Report Codable Errors

**Problem:** Report doesn't conform to Decodable/Encodable because ProcessingState enum needs to conform to Codable.

**Fix:** The code should already be fixed, but let's verify:

1. **In Navigator**, open `Models/Report.swift`
2. **Check line 26** - should say: `enum ProcessingState: Codable, Equatable {`
3. **If it doesn't say `Codable`**, I'll need to update the file

## Step-by-Step Fix

### Fix Info.plist First:

1. **In Build Settings** (you're already there)
2. **Find "Generate Info.plist File"** in the list
3. **Double-click "Yes"** → Change to **"No"**
4. **Press Enter**

### Then Fix Report Codable:

1. **Open `Report.swift`** in Navigator
2. **Check if line 26 has `Codable`**
3. **If not, I'll fix it**

### Clean and Rebuild:

1. **Clean Build Folder**: ⇧⌘K
2. **Build**: ⌘B

## Quick Checklist

- [ ] Changed "Generate Info.plist File" to "No"
- [ ] Verified Report.swift has ProcessingState: Codable
- [ ] Cleaned build folder (⇧⌘K)
- [ ] Built successfully (⌘B)
