//
//  ReportUploadView.swift
//  HealthReportApp
//
//  Screen 1: Report Upload and Processing
//  Following Figma annotations: upload from library/camera/files, show processing message, handle failures
//

import SwiftUI

struct ReportUploadView: View {
    @EnvironmentObject var reportStore: ReportStore
    @StateObject private var processingService = ReportProcessingService()
    @State private var showingImagePicker = false
    @State private var showingDocumentPicker = false
    @State private var showingCamera = false
    @State private var selectedImage: UIImage?
    @State private var selectedDocument: URL?
    
    var body: some View {
        VStack(spacing: 24) {
            if reportStore.currentReport == nil {
                // Upload card - following Figma: option for library/camera/files
                uploadCard
            } else if case .processing = reportStore.currentReport?.processingState {
                // Processing state - show neutral message
                processingView
            } else if case .failed(let error) = reportStore.currentReport?.processingState {
                // Failure state - ask to re-upload
                failureView(error: error)
            } else if case .success = reportStore.currentReport?.processingState,
                      let report = reportStore.currentReport,
                      !report.metrics.isEmpty {
                // Success - show metric list
                MetricListView(metrics: report.metrics)
                    .environmentObject(reportStore)
            }
        }
        .padding()
        .navigationTitle("Health Report")
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $showingCamera) {
            ImagePicker(image: $selectedImage, sourceType: .camera)
        }
        .fileImporter(
            isPresented: $showingDocumentPicker,
            allowedContentTypes: [.pdf, .image],
            allowsMultipleSelection: false
        ) { result in
            handleFileSelection(result: result)
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                handleImageSelection(image: image)
            }
        }
    }
    
    private var uploadCard: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("Upload Report Card")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Upload your health report from your library, camera, or files")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                Button(action: { showingImagePicker = true }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                        Text("Choose from Library")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: { showingCamera = true }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Take Photo")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: { showingDocumentPicker = true }) {
                    HStack {
                        Image(systemName: "folder")
                        Text("Choose from Files")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                // Test Mode Button
                Button(action: { useTestData() }) {
                    HStack {
                        Image(systemName: "testtube.2")
                        Text("Use Test Data (Demo)")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding(24)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func useTestData() {
        // Create sample metrics for testing
        let sampleMetrics = [
            Metric(
                name: "Hemoglobin",
                value: "14.5 g/dL",
                referenceRange: "12.0-16.0"
            ),
            Metric(
                name: "Glucose",
                value: "95 mg/dL",
                referenceRange: "70-100"
            ),
            Metric(
                name: "Total Cholesterol",
                value: "185 mg/dL",
                referenceRange: "Less than 200"
            ),
            Metric(
                name: "HDL Cholesterol",
                value: "55 mg/dL",
                referenceRange: "40 or higher"
            ),
            Metric(
                name: "LDL Cholesterol",
                value: "110 mg/dL",
                referenceRange: "Less than 100"
            )
        ]
        
        reportStore.createReport(fileName: "Test Report")
        reportStore.setProcessingState(.processing)
        
        // Simulate processing delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            reportStore.updateMetrics(sampleMetrics)
            reportStore.setProcessingState(.success)
        }
    }
    
    private var processingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Processing report...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func failureView(error: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Unable to Process Report")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(error)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text("Please upload a clearer report")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                reportStore.clearCurrentReport()
            }) {
                Text("Upload Again")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding(24)
    }
    
    private func handleImageSelection(image: UIImage) {
        // Save image temporarily and process
        let fileName = "report_\(UUID().uuidString).jpg"
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        do {
            try imageData.write(to: fileURL)
            processReport(url: fileURL, fileName: fileName)
        } catch {
            reportStore.setProcessingError("Failed to save image: \(error.localizedDescription)")
        }
    }
    
    private func handleFileSelection(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                let fileName = url.lastPathComponent
                processReport(url: url, fileName: fileName)
            }
        case .failure(let error):
            reportStore.setProcessingError("Failed to select file: \(error.localizedDescription)")
        }
    }
    
    private func processReport(url: URL, fileName: String) {
        reportStore.createReport(fileName: fileName)
        reportStore.setProcessingState(.processing)
        
        Task {
            do {
                let metrics = try await processingService.processReport(from: url)
                await MainActor.run {
                    reportStore.updateMetrics(metrics)
                    reportStore.setProcessingState(.success)
                }
            } catch {
                await MainActor.run {
                    let errorMessage = error.localizedDescription
                    reportStore.setProcessingState(.failed(errorMessage))
                }
            }
        }
    }
}

#Preview {
    ReportUploadView()
        .environmentObject(ReportStore())
}
