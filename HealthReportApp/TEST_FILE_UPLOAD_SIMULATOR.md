# How to Test File Upload in iOS Simulator

## Method 1: Add Sample Photos (Easiest)

### Step 1: Add Sample Photos to Simulator

1. **In Simulator**, go to menu: **Device → Photos → Add Sample Photos**
2. **This adds test images** to the Photos app automatically
3. **Wait a few seconds** for photos to appear

### Step 2: Test in Your App

1. **Open your HealthReportApp** in Simulator
2. **Tap "Choose from Library"**
3. **Photos app should open**
4. **Select one of the sample photos**
5. **Your app should receive the image**

## Method 2: Drag and Drop Files

### Step 1: Prepare a Test File

1. **Find any image or PDF** on your Mac
   - Any .jpg, .png, or .pdf file
   - Or create a simple test image

### Step 2: Drag to Simulator

1. **Drag the file** from Finder
2. **Drop it onto the Simulator window**
3. **The file picker should appear** in your app
4. **Select the file**

## Method 3: Use Files App

### Step 1: Add Files to Simulator

1. **In Simulator**, open the **Files app**
2. **Drag a PDF or image** from Finder into Files app
3. **File should appear** in Files app

### Step 2: Test in Your App

1. **Open your HealthReportApp**
2. **Tap "Choose from Files"**
3. **Files app should open**
4. **Select the file you added**
5. **Your app should receive it**

## Method 4: Use Camera (Simulated)

1. **In your app**, tap **"Take Photo"**
2. **Simulator camera interface** appears
3. **You can use simulated photos** or add your own

## Troubleshooting

### Photos App is Empty

1. **Device → Photos → Add Sample Photos** (try again)
2. **Or drag images** directly into Photos app in Simulator

### File Picker Doesn't Appear

1. **Make sure Simulator is running iOS 16+**
2. **Check that permissions are set** in Info.plist (they are!)
3. **Try a different method** (Photos vs Files)

### Processing Fails

- **This is expected** if OCR can't read the file
- **Try with a clear, simple image**
- **Or we can add test mode** with sample data

## Quick Test Workflow

1. **Add sample photos**: Device → Photos → Add Sample Photos
2. **Open your app**
3. **Tap "Choose from Library"**
4. **Select a sample photo**
5. **Watch the processing flow**

## Alternative: Add Test Mode

If file uploads are still difficult, I can add a **test mode** that:
- Skips file upload
- Uses sample metrics data
- Lets you test the full flow

Would you like me to add a test mode?
