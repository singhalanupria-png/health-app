# Troubleshoot "Trust This Computer" Not Appearing

## The Problem
Xcode is waiting for you to tap "Trust" on your iPhone, but the prompt isn't showing.

## Step-by-Step Fix

### Step 1: Basic Checks

1. **Unlock your iPhone** - The prompt only appears when unlocked
2. **Keep iPhone screen on** - Don't let it lock
3. **Disconnect and reconnect** the USB cable
4. **Wait 5-10 seconds** after reconnecting

### Step 2: Check if Already Trusted

1. On iPhone: **Settings → General → About**
2. Scroll down - if you see your computer name, it might already be trusted
3. If it's already trusted, try the next steps

### Step 3: Revoke and Re-trust

1. On iPhone: **Settings → General → Transfer or Reset iPhone**
2. Tap **"Reset"**
3. Tap **"Reset Location & Privacy"**
4. Enter your passcode
5. **Disconnect** the USB cable
6. **Reconnect** the USB cable
7. **Unlock iPhone** and keep screen on
8. The "Trust This Computer?" prompt should appear

### Step 4: Check Cable and Port

1. **Try a different USB cable** (if available)
2. **Try a different USB port** on your Mac
3. **Use a direct USB port** (not a hub)

### Step 5: Check Developer Mode (iOS 16+)

If your iPhone is running iOS 16 or later:

1. On iPhone: **Settings → Privacy & Security**
2. Scroll down to **"Developer Mode"**
3. **Enable Developer Mode** if it's off
4. **Restart iPhone** if prompted
5. **Reconnect** and try again

### Step 6: Alternative - Use Simulator

If device connection continues to be problematic:

1. **In Xcode**, click the device selector (top toolbar)
2. **Select a Simulator** (e.g., "iPhone 16 Pro")
3. **Press ⌘R** to run
4. Test in Simulator instead

## Quick Checklist

- [ ] iPhone is unlocked
- [ ] iPhone screen is on (not locked)
- [ ] USB cable is connected
- [ ] Tried disconnecting/reconnecting
- [ ] Checked Settings → General → About
- [ ] Tried resetting Location & Privacy
- [ ] Developer Mode enabled (iOS 16+)
- [ ] Tried different cable/port

## Most Common Fix

**Reset Location & Privacy** usually fixes this:
1. Settings → General → Transfer or Reset iPhone → Reset → Reset Location & Privacy
2. Disconnect and reconnect
3. Unlock iPhone and wait for prompt

## If Still Not Working

Use the **Simulator** - it's easier for development and testing:
1. Click device selector in Xcode
2. Choose "iPhone 16 Pro" (or any simulator)
3. Press ⌘R to run
