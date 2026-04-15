//
//  MetricExplanationView.swift
//  HealthReportApp
//
//  Screen 2: Metric Explanation
//  Following Figma annotations: display metric name, value, reference range, explanation, lifestyle context
//

import SwiftUI

struct MetricExplanationView: View {
    let metric: Metric
    @StateObject private var llmService = LLMService()
    @State private var explanation: String?
    @State private var lifestyleContext: String?
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Metric Name - exactly as in report
                metricNameSection
                
                // Metric Value - raw value and unit, no color coding
                metricValueSection
                
                // Reference Range - exactly as in report
                referenceRangeSection
                
                // Explanation Card - LLM-generated, calm, non-medical
                if isLoading {
                    explanationLoadingView
                } else if let explanation = explanation {
                    explanationCard(explanation)
                }
                
                // Lifestyle Context - high-level only, no plans/targets
                if let lifestyleContext = lifestyleContext {
                    lifestyleContextSection(lifestyleContext)
                }
            }
            .padding()
        }
        .navigationTitle(metric.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadExplanation()
        }
    }
    
    private var metricNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Metric name")
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(metric.name)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var metricValueSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Metric Value")
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(metric.value)
                .font(.title)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var referenceRangeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reference Range")
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(metric.referenceRange)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func explanationCard(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Explanation card")
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var explanationLoadingView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Explanation card")
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            HStack {
                ProgressView()
                Text("Generating explanation...")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func lifestyleContextSection(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Lifestyle context")
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func loadExplanation() async {
        isLoading = true
        
        // Check if explanation already exists
        if let existingExplanation = metric.explanation,
           let existingLifestyle = metric.lifestyleContext {
            explanation = existingExplanation
            lifestyleContext = existingLifestyle
            isLoading = false
            return
        }
        
        do {
            let result = try await llmService.generateExplanation(for: metric)
            // Clean up any remaining unwanted text
            explanation = cleanResponseText(result.explanation)
            if let lifestyle = result.lifestyleContext {
                lifestyleContext = cleanResponseText(lifestyle)
            } else {
                lifestyleContext = nil
            }
        } catch {
            explanation = "Unable to generate explanation at this time. Please try again later."
            lifestyleContext = nil
        }
    }
    
    private func cleanResponseText(_ text: String) -> String {
        var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove "RESPONSE 1:", "RESPONSE 2:", etc. (case insensitive)
        cleaned = cleaned.replacingOccurrences(
            of: #"(?i)\s*RESPONSE\s+\d+[:.]?\s*"#,
            with: "",
            options: .regularExpression
        )
        
        // Remove numbered prefixes/suffixes
        cleaned = cleaned.replacingOccurrences(
            of: #"^\d+\.\s*|\s*\d+\.\s*$"#,
            with: "",
            options: .regularExpression
        )
        
        // Remove unwanted headers
        let unwanted = ["EXPLANATION:", "Explanation:", "LIFESTYLE CONTEXT:", "Lifestyle Context:"]
        for item in unwanted {
            cleaned = cleaned.replacingOccurrences(of: item, with: "", options: .caseInsensitive)
        }
        
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        MetricExplanationView(metric: Metric(
            name: "Hemoglobin",
            value: "14.5 g/dL",
            referenceRange: "12.0-16.0"
        ))
    }
}
