//
//  ReportStore.swift
//  HealthReportApp
//
//  State management for reports
//

import Foundation
import SwiftUI

@MainActor
class ReportStore: ObservableObject {
    @Published var currentReport: Report?
    
    func createReport(fileName: String) {
        currentReport = Report(fileName: fileName, processingState: .notStarted)
    }
    
    func setProcessingState(_ state: ProcessingState) {
        currentReport?.processingState = state
    }
    
    func updateMetrics(_ metrics: [Metric]) {
        currentReport?.metrics = metrics
    }
    
    func setProcessingError(_ error: String) {
        currentReport?.processingState = .failed(error)
    }
    
    func clearCurrentReport() {
        currentReport = nil
    }
}
