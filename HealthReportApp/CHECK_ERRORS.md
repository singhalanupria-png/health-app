# How to See and Fix the 8 Errors

## Step 1: See What the Errors Are

1. **Click the red "8" error icon** in the top toolbar (top right of Xcode)
2. Or press **⌘5** to open Issue Navigator
3. **This will show you all 8 errors**

## Common Errors You Might See

### Error: "Cannot find 'ReportStore' in scope"
**Fix:** Make sure `ReportStore.swift` is:
- Added to the project
- In the Models/ folder
- Added to the HealthReportApp target

### Error: "Cannot find 'ReportUploadView' in scope"
**Fix:** Make sure `ReportUploadView.swift` is:
- Added to the project
- In the Views/ folder
- Added to the HealthReportApp target

### Error: "No such module 'Vision'" or "No such module 'PDFKit'"
**Fix:** Make sure frameworks are added:
- Vision.framework
- PDFKit.framework
- In Build Phases → Link Binary With Libraries

### Error: "Use of unresolved identifier"
**Fix:** Check if the file containing that identifier is:
- Added to the project
- Added to the target

## Step 2: Check Target Membership

For each Swift file, make sure it's added to the target:

1. **Select a file** in Navigator (like ReportStore.swift)
2. **Look at right sidebar** (File Inspector)
3. **Find "Target Membership" section**
4. **Make sure "HealthReportApp" is checked**

Do this for:
- ReportStore.swift
- Report.swift
- Metric.swift
- ReportUploadView.swift
- MetricListView.swift
- MetricExplanationView.swift
- ImagePicker.swift
- ReportProcessingService.swift
- LLMService.swift

## Step 3: Verify Files Are Added

In Navigator, check that you have:

```
HealthReportApp (yellow folder)
├── Models/
│   ├── Report.swift ✅
│   ├── Metric.swift ✅
│   └── ReportStore.swift ✅
├── Views/
│   ├── ContentView.swift ✅
│   ├── ReportUploadView.swift ✅
│   ├── MetricListView.swift ✅
│   ├── MetricExplanationView.swift ✅
│   └── ImagePicker.swift ✅
├── Services/
│   ├── ReportProcessingService.swift ✅
│   └── LLMService.swift ✅
└── HealthReportAppApp.swift ✅
```

If any are missing (red or not showing), add them.

## Step 4: Quick Fix - Re-add Missing Files

If files are missing:

1. **Right-click the folder** (Models/, Views/, or Services/)
2. **Select "Add Files to 'HealthReportApp'..."**
3. **Navigate to the folder** on your computer
4. **Select the missing files**
5. **Make sure:**
   - ✅ "Copy items if needed" is checked
   - ✅ "Create groups" is selected
   - ✅ "Add to targets: HealthReportApp" is checked
6. **Click "Add"**

## Step 5: Check Build Phases

1. **Click blue project icon**
2. **Go to "Build Phases" tab**
3. **Expand "Compile Sources"**
4. **Verify all Swift files are listed:**
   - ContentView.swift
   - ReportStore.swift
   - Report.swift
   - Metric.swift
   - ReportUploadView.swift
   - MetricListView.swift
   - MetricExplanationView.swift
   - ImagePicker.swift
   - ReportProcessingService.swift
   - LLMService.swift
   - HealthReportAppApp.swift

If any are missing, add them using the "+" button.

## Most Likely Issue

The errors are probably because:
- Files aren't added to the target
- Files are missing from the project
- Frameworks aren't linked

**Share the actual error messages** (from Issue Navigator) and I can help fix them specifically!
