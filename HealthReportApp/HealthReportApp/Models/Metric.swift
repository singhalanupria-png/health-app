//
//  Metric.swift
//  HealthReportApp
//
//  Data model for individual health metric
//

import Foundation

struct Metric: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String // Exactly as in report - no renaming or categorization
    let value: String // Raw value with unit - no color coding or severity
    let referenceRange: String // Exactly as in report - no inferred labels
    var explanation: String? // LLM-generated explanation
    var lifestyleContext: String? // LLM-generated lifestyle context
    
    init(id: UUID = UUID(), name: String, value: String, referenceRange: String, explanation: String? = nil, lifestyleContext: String? = nil) {
        self.id = id
        self.name = name
        self.value = value
        self.referenceRange = referenceRange
        self.explanation = explanation
        self.lifestyleContext = lifestyleContext
    }
}
