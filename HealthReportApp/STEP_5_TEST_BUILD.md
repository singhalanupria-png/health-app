# Step 5: Test Build - Complete Guide

## Goal
Build the project successfully and verify there are no errors.

## Step-by-Step Instructions

### Step 1: Clean Build Folder (Optional but Recommended)

1. **In Xcode**, press **⇧⌘K** (Shift + Command + K)
   - Or go to **Product → Clean Build Folder**
2. **Wait for it to complete** (you'll see "Clean Finished" in status bar)

### Step 2: Build the Project

1. **Press ⌘B** (Command + B)
   - Or go to **Product → Build**
2. **Watch the status bar** at the top of Xcode
3. **Wait for build to complete**

### Step 3: Check Build Status

**Success Indicators:**
- ✅ Status bar shows: **"Build Succeeded"**
- ✅ No red error icons in toolbar
- ✅ Issue Navigator (⌘5) shows no errors (only warnings are OK)

**Failure Indicators:**
- ❌ Status bar shows: **"Build Failed"**
- ❌ Red error icon with number in toolbar
- ❌ Issue Navigator shows errors

### Step 4: If Build Succeeds

**Congratulations!** Your app is ready to run.

**Next Steps:**
1. **Run the app**: Press **⌘R** (or click the Play button)
2. **Select a simulator**: Choose iPhone 16 Pro or any iOS 16+ device
3. **Test the app**: Try uploading a health report

### Step 5: If Build Fails

1. **Open Issue Navigator**: Press **⌘5** (or click the warning icon)
2. **Review errors**: Read each error message
3. **Fix errors**: Follow the error messages to fix issues
4. **Common fixes**:
   - Missing files → Add them to project
   - Import errors → Check frameworks are added
   - Syntax errors → Fix code
5. **Rebuild**: Press **⌘B** again

## Quick Build Checklist

- [ ] Cleaned build folder (⇧⌘K) - Optional
- [ ] Built project (⌘B)
- [ ] Status shows "Build Succeeded"
- [ ] No errors in Issue Navigator
- [ ] Ready to run app (⌘R)

## Running the App

### Step 1: Select a Simulator

1. **Click the device selector** in toolbar (shows "iPhone 16 Pro")
2. **Choose a simulator**:
   - iPhone 16 Pro (recommended)
   - iPhone 15 Pro
   - Any iOS 16.0+ device

### Step 2: Run the App

1. **Press ⌘R** (Command + R)
   - Or click the **Play button** (▶️) in toolbar
2. **Wait for app to launch** in simulator
3. **App should open** showing the upload screen

### Step 3: Test Basic Functionality

1. **Upload screen**: Should show upload options (Library, Camera, Files)
2. **Navigation**: Should work smoothly
3. **No crashes**: App should stay open

## Troubleshooting

### Build Fails with Errors

1. **Check Issue Navigator** (⌘5)
2. **Read error messages carefully**
3. **Common issues**:
   - Missing frameworks → Add Vision, PDFKit
   - Missing files → Add to project
   - Syntax errors → Fix code
   - Info.plist issues → Check settings

### App Crashes on Launch

1. **Check console** (bottom of Xcode)
2. **Look for error messages**
3. **Common causes**:
   - Missing Info.plist
   - Missing permissions
   - Code errors

### Simulator Issues

1. **Reset simulator**: Device → Erase All Content and Settings
2. **Restart Xcode**
3. **Try different simulator**

## Success Criteria

✅ **Build succeeds** without errors
✅ **App launches** in simulator
✅ **Upload screen** appears
✅ **No crashes** on launch

## Next Steps After Successful Build

1. **Test upload flow**: Try uploading a test image/PDF
2. **Test processing**: See if OCR works
3. **Test metric list**: Check if metrics are extracted
4. **Test explanations**: View metric explanations (will call LLM API)

## Quick Reference

- **Build**: ⌘B
- **Run**: ⌘R
- **Clean**: ⇧⌘K
- **Stop**: ⌘. (Command + Period)
- **Issue Navigator**: ⌘5
