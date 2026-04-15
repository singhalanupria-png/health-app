# Testing the App in Simulator

## Good News! ✅
Your app launched successfully! Now let's test the features.

## Testing File Uploads in Simulator

The simulator DOES support file uploads. Here's how:

### Method 1: Drag and Drop (Easiest)

1. **Find a test image or PDF** on your Mac
   - Any image file (.jpg, .png)
   - Any PDF file
   - Or create a simple test image

2. **Drag the file** from Finder
3. **Drop it onto the simulator** window
4. **The file picker should appear** in your app

### Method 2: Use Photos App

1. **In Simulator**, open the **Photos app**
2. **Add test images**:
   - Drag images into Photos app
   - Or use Simulator menu: **Device → Photos → Add Sample Photos**
3. **Go back to your app**
4. **Tap "Choose from Library"**
5. **Select a photo**

### Method 3: Use Files App

1. **In Simulator**, open the **Files app**
2. **Add test files**:
   - Drag PDF or image files into Files app
3. **Go back to your app**
4. **Tap "Choose from Files"**
5. **Select a file**

### Method 4: Camera (Simulated)

1. **In your app**, tap **"Take Photo"**
2. **Simulator will show a camera interface**
3. **You can use simulated photos** or add your own

## Quick Test Workflow

1. **Add sample photos to Simulator**:
   - Device → Photos → Add Sample Photos
2. **Open your app**
3. **Tap "Choose from Library"**
4. **Select a sample photo**
5. **Watch the processing flow**

## Testing Without Real Files (Development Mode)

If you want to test the app flow without actual file uploads, I can add:
- Sample metrics data
- Test mode that skips OCR
- Mock data for development

Would you like me to add a test mode?

## What to Test

1. ✅ **App launches** - DONE!
2. ⏳ **Upload flow** - Try the methods above
3. ⏳ **Processing state** - Should show "Processing report..."
4. ⏳ **Metric list** - Should show extracted metrics
5. ⏳ **Metric explanation** - Should show LLM-generated explanation

## Troubleshooting

### File picker doesn't appear
- Make sure you're using iOS 16+ simulator
- Check that permissions are set in Info.plist (they are!)

### No files in Photos/Files
- Add sample photos: Device → Photos → Add Sample Photos
- Or drag files into the simulator

### Processing fails
- This is expected if OCR can't read the file
- Try with a clear, simple image or PDF
- Or we can add test mode with sample data

## Next Steps

1. **Try uploading a file** using one of the methods above
2. **Test the full flow**: Upload → Process → List → Explanation
3. **Check if LLM API calls work** (will use your API key)

Let me know if you'd like me to add a test mode with sample data for easier testing!
