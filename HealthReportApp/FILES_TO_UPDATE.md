# Files to Update in Xcode

## Files That Need to Be Updated

### 1. **ReportProcessingService.swift** ⚠️ CRITICAL
**Location:** `Services/ReportProcessingService.swift`
**Changes:** 
- Added LLM-based parsing (uses OpenAI API)
- Removed old regex parsing
- Added async/await for LLM calls

**How to Update:**
1. In Xcode, find `ReportProcessingService.swift` in Services folder
2. Right-click → "Show in Finder" to see current location
3. Copy the updated file from `/Users/abhisheknarwal/HealthReportApp/HealthReportApp/Services/ReportProcessingService.swift`
4. Replace the file in Xcode (or delete and re-add)

### 2. **ReportUploadView.swift** ⚠️ IMPORTANT
**Location:** `Views/ReportUploadView.swift`
**Changes:**
- Added "Use Test Data (Demo)" button
- Added `useTestData()` function

**How to Update:**
1. Find `ReportUploadView.swift` in Views folder
2. Copy from `/Users/abhisheknarwal/HealthReportApp/HealthReportApp/Views/ReportUploadView.swift`
3. Replace in Xcode

### 3. **LLMService.swift** ✅ (Already has API key)
**Location:** `Services/LLMService.swift`
**Status:** Should already have API key, but verify

### 4. **Report.swift** ✅ (Codable fix)
**Location:** `Models/Report.swift`
**Status:** Should already be fixed, but verify `ProcessingState: Codable`

### 5. **Metric.swift** ✅ (Hashable)
**Location:** `Models/Metric.swift`
**Status:** Should already have Hashable conformance

## Quick Update Method

### Option 1: Replace Files in Xcode

1. **For each file above:**
   - In Xcode, right-click the file → "Delete" → "Remove Reference" (NOT Move to Trash)
   - Drag the updated file from Finder into Xcode
   - Make sure "Add to targets: HealthReportApp" is checked

### Option 2: Copy Content Manually

1. **Open both files side by side:**
   - Updated file in Finder/TextEdit
   - Xcode file
2. **Copy all content** from updated file
3. **Paste** into Xcode file
4. **Save** (⌘S)

### Option 3: Use Xcode's File Comparison

1. **In Xcode**, right-click file → "Show in Finder"
2. **Open both files** in separate windows
3. **Compare** and copy changes

## Priority Order

1. **ReportProcessingService.swift** - Most critical (LLM parsing)
2. **ReportUploadView.swift** - Important (test mode)
3. Others - Verify they're correct

## Verification Checklist

After updating, verify:
- [ ] ReportProcessingService.swift has `extractMetricsWithLLM` function
- [ ] ReportProcessingService.swift has API key constant
- [ ] ReportUploadView.swift has "Use Test Data" button
- [ ] Build succeeds (⌘B)
- [ ] No errors in Issue Navigator (⌘5)

## File Locations

**Source files (updated):**
- `/Users/abhisheknarwal/HealthReportApp/HealthReportApp/Services/ReportProcessingService.swift`
- `/Users/abhisheknarwal/HealthReportApp/HealthReportApp/Views/ReportUploadView.swift`
- `/Users/abhisheknarwal/HealthReportApp/HealthReportApp/Services/LLMService.swift`
- `/Users/abhisheknarwal/HealthReportApp/HealthReportApp/Models/Report.swift`
- `/Users/abhisheknarwal/HealthReportApp/HealthReportApp/Models/Metric.swift`

**Xcode project location:**
- Check your Xcode project path (likely `/Users/abhisheknarwal/Desktop/HealthReportApp/`)
