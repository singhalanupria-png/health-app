# Health Report App - Phase 0 MVP

iOS app (SwiftUI) for health report explanation following Phase 0 product rules.

A consumer iOS app that helps users understand their health reports without medical jargon. Built independently as an applied AI product prototype — designed, architected, and developed end to end using SwiftUI, OpenAI APIs, and Apple's Vision framework for OCR. Demonstrates practical AI product design principles including responsible AI guardrails, LLM input/output constraints, and human-safe explanation generation.

## Features

- Upload health reports (PDF or images) from library, camera, or files
- OCR and parsing of health reports
- Display extracted metrics list
- View detailed metric explanations with lifestyle context

## Phase 0 Rules Compliance

### Product Rules
- ✅ Metric names match report exactly (no renaming or categorization)
- ✅ Metric values display raw value and unit (no color coding severity)
- ✅ Reference ranges use exact values from report (no inferred labels)
- ✅ Explanation cards are calm, non-medical, explanatory only
- ✅ Lifestyle context is high-level only (no plans, targets, prescriptions)
- ✅ No diagnosis, prediction, or urgency language
- ✅ No chat functionality in MVP1

### AI/LLM Rules
- ✅ LLM only generates explanation text and lifestyle context
- ✅ LLM only sees: metric name, value, reference range, optional age/gender
- ✅ LLM never sees: raw PDF/OCR text, medical history, prescriptions, doctor notes
- ✅ LLM never diagnoses, predicts, or gives medical advice

### Error Handling
- ✅ OCR failures prompt user to re-upload
- ✅ Parsing failures do not generate metric list
- ✅ Processing states clearly communicated

## Project Structure

```
HealthReportApp/
├── HealthReportApp/
│   ├── Models/
│   │   ├── Report.swift
│   │   ├── Metric.swift
│   │   └── ReportStore.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── ReportUploadView.swift
│   │   ├── MetricListView.swift
│   │   ├── MetricExplanationView.swift
│   │   └── ImagePicker.swift
│   ├── Services/
│   │   ├── ReportProcessingService.swift
│   │   └── LLMService.swift
│   ├── HealthReportAppApp.swift
│   └── Info.plist
└── README.md
```

## Setup

1. Open the project in Xcode
2. Configure LLM API key (if using real LLM service):
   - Set `OPENAI_API_KEY` environment variable, or
   - Update `LLMService.init()` to use your API key
3. Build and run on iOS device or simulator

## Notes

- OCR uses Vision framework for text recognition
- PDF parsing uses PDFKit
- LLM service currently uses placeholder responses (update `LLMService` for production)
- Metric parsing is simplified for MVP (enhance `ReportProcessingService.parseMetrics()` for production)

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
