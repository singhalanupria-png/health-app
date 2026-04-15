//
//  Report.swift
//  HealthReportApp
//
//  Data model for health report
//

import Foundation

struct Report: Identifiable, Codable {
    let id: UUID
    let fileName: String
    let uploadDate: Date
    var metrics: [Metric]
    var processingState: ProcessingState
    
    init(id: UUID = UUID(), fileName: String, uploadDate: Date = Date(), metrics: [Metric] = [], processingState: ProcessingState = .notStarted) {
        self.id = id
        self.fileName = fileName
        self.uploadDate = uploadDate
        self.metrics = metrics
        self.processingState = processingState
    }
}

enum ProcessingState: Codable, Equatable {
    case notStarted
    case processing
    case success
    case failed(String) // Error message
}
