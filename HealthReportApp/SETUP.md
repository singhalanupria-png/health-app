# Setup Instructions

## Creating the Xcode Project

Since the Xcode project file is complex, it's recommended to create the project in Xcode:

1. Open Xcode
2. Create a new project:
   - Choose "iOS" → "App"
   - Product Name: `HealthReportApp`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Storage: `None` (or Core Data if you want persistence later)
3. Save the project in the `HealthReportApp` directory (or move the existing files into the new project)

## Adding Files to Xcode

After creating the project, add the existing files:

1. **Models** folder:
   - `Report.swift`
   - `Metric.swift`
   - `ReportStore.swift`

2. **Views** folder:
   - `ContentView.swift`
   - `ReportUploadView.swift`
   - `MetricListView.swift`
   - `MetricExplanationView.swift`
   - `ImagePicker.swift`

3. **Services** folder:
   - `ReportProcessingService.swift`
   - `LLMService.swift`

4. Replace the default `HealthReportAppApp.swift` with the provided one

5. Add `Info.plist` to the project (for camera/photo permissions)

## Configuration

1. **Camera/Photo Permissions**: The `Info.plist` file includes the necessary permission descriptions. Make sure it's added to your Xcode project.

2. **LLM API Key** (for production):
   - Set environment variable `OPENAI_API_KEY`, or
   - Update `LLMService.swift` to use your API key directly

3. **Deployment Target**: Set to iOS 16.0 or later

## Building and Running

1. Select a target device or simulator (iOS 16.0+)
2. Build and run (⌘R)

## Testing

The app includes placeholder implementations for:
- OCR/parsing (simplified pattern matching)
- LLM service (placeholder responses)

For production, you'll need to:
- Enhance the metric parsing logic in `ReportProcessingService`
- Connect the LLM service to your actual API
- Add proper error handling and edge cases
