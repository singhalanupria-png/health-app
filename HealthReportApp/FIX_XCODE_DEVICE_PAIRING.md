# Fix Xcode Device Pairing (Device Shows in Finder but Not Xcode)

## The Problem
Your iPhone is connected and shows in Finder, but Xcode can't pair with it.

## Solution Steps

### Step 1: Close and Reopen Xcode

1. **Quit Xcode completely** (⌘Q)
2. **Disconnect** your iPhone
3. **Reconnect** your iPhone
4. **Open Xcode** again
5. **Wait 30 seconds** for Xcode to detect the device

### Step 2: Check Xcode Devices Window

1. **In Xcode**, go to **Window → Devices and Simulators** (⇧⌘2)
2. **Look for "Anu iphone"** in the left sidebar
3. **What status does it show?**
   - "Connected" = Good, but might need developer setup
   - "Preparing" = Still setting up
   - "Unavailable" = Needs attention
   - Not listed = Xcode hasn't detected it

### Step 3: Enable Developer Mode on iPhone (iOS 16+)

If your iPhone is running iOS 16 or later:

1. On iPhone: **Settings → Privacy & Security**
2. Scroll down to **"Developer Mode"**
3. **Enable Developer Mode** (toggle it ON)
4. **Restart iPhone** if prompted
5. **Reconnect** to Mac
6. **Check Xcode again**

### Step 4: Sign in to Xcode with Apple ID

1. **Xcode → Settings** (⌘,)
2. **Go to "Accounts" tab**
3. **Click "+" button** to add account
4. **Sign in with your Apple ID**
5. **Make sure you're signed in**

### Step 5: Trust Developer Certificate

1. On iPhone: **Settings → General → VPN & Device Management**
2. Look for any **developer certificates** or **profiles**
3. **Trust them** if they appear

### Step 6: Check Xcode Platform Support

1. **Xcode → Settings** (⌘,)
2. **Go to "Platforms" tab**
3. **Make sure iOS is installed/updated**
4. If not, click **"Get"** or **"Update"**

### Step 7: Restart Both Devices

1. **Restart your Mac**
2. **Restart your iPhone**
3. **Reconnect** and try again

## Quick Fix Checklist

- [ ] Quit and reopened Xcode
- [ ] Checked Window → Devices and Simulators (⇧⌘2)
- [ ] Enabled Developer Mode on iPhone (iOS 16+)
- [ ] Signed in to Xcode with Apple ID
- [ ] Checked VPN & Device Management on iPhone
- [ ] Verified iOS platform is installed in Xcode
- [ ] Restarted both devices

## Alternative: Use Simulator

If device pairing continues to be problematic:

1. **Click device selector** in Xcode toolbar
2. **Select "iPhone 16 Pro"** (or any simulator)
3. **Press ⌘R** to run
4. **Test in Simulator** - works great for development!

## Most Likely Fix

**Enable Developer Mode** on iPhone (if iOS 16+):
1. Settings → Privacy & Security → Developer Mode → Enable
2. Restart iPhone
3. Reconnect to Mac
4. Check Xcode again

Try Step 3 (Developer Mode) first - that's usually the issue when Finder sees the device but Xcode doesn't!
