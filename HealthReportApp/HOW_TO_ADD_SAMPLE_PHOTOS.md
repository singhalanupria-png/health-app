# How to Add Sample Photos to iOS Simulator

## Step-by-Step Instructions

### Step 1: Make Sure Simulator is Running

1. **In Xcode**, make sure your app is running in Simulator
2. **Or manually open Simulator**: Xcode → Open Developer Tool → Simulator
3. **Simulator window should be visible**

### Step 2: Access the Device Menu

1. **Look at the top menu bar** of your Mac (not Xcode, the macOS menu bar)
2. **Find "Device"** in the menu bar
   - This appears when Simulator is the active window
   - It's between "Edit" and "Window" menus
3. **Click "Device"** to open the dropdown menu

### Step 3: Navigate to Photos Menu

1. **In the "Device" dropdown**, hover over or click **"Photos"**
2. **A submenu appears** with options:
   - Add Sample Photos
   - Add Videos
   - Reset Photos Library
   - etc.

### Step 4: Add Sample Photos

1. **Click "Add Sample Photos"**
2. **Wait a few seconds** - photos are being added
3. **You should see a notification** or the Photos app might open
4. **Photos are now in the Simulator's Photos app**

### Step 5: Verify Photos Were Added

1. **In Simulator**, open the **Photos app** (home screen icon)
2. **You should see sample photos** added
3. **These are now available** for your app to access

## Visual Guide

```
macOS Menu Bar (when Simulator is active):
[Apple] [Xcode] [File] [Edit] [Device ▼] [Window] [Help]
                          ↑
                    Click here

Device Menu:
├── Device
│   ├── Photos
│   │   ├── Add Sample Photos ← Click this
│   │   ├── Add Videos
│   │   └── Reset Photos Library
│   └── ...
```

## Alternative: If "Device" Menu Doesn't Appear

1. **Click on the Simulator window** to make it active
2. **The "Device" menu should appear** in the menu bar
3. **If it doesn't**, try:
   - Clicking different parts of the Simulator window
   - Making sure Simulator is the frontmost app

## Quick Checklist

- [ ] Simulator is running
- [ ] Simulator window is active/selected
- [ ] "Device" menu appears in macOS menu bar
- [ ] Clicked "Device" → "Photos" → "Add Sample Photos"
- [ ] Waited for photos to be added
- [ ] Verified photos in Photos app
- [ ] Ready to test in your app!

## After Adding Photos

1. **Open your HealthReportApp** in Simulator
2. **Tap "Choose from Library"**
3. **Photos app opens**
4. **Select a sample photo**
5. **Your app processes it!**

## Troubleshooting

### "Device" Menu Not Showing
- Make sure Simulator window is active/selected
- Click on the Simulator window
- Try quitting and reopening Simulator

### Photos Not Appearing
- Wait a few more seconds
- Try "Add Sample Photos" again
- Check Photos app in Simulator

### Still Having Issues
- Try dragging an image directly into Simulator
- Or use the Files app method instead
