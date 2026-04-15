//
//  ReportProcessingService.swift
//  HealthReportApp
//
//  Service for OCR and parsing health reports
//

import Foundation
import UIKit
import Vision
import PDFKit

@MainActor
class ReportProcessingService: ObservableObject {
    @Published var isProcessing = false
    @Published var errorMessage: String?
    
    private let apiKey = "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"
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    func processReport(from url: URL) async throws -> [Metric] {
        isProcessing = true
        errorMessage = nil
        defer { isProcessing = false }
        
        // Determine file type
        let fileExtension = url.pathExtension.lowercased()
        
        if fileExtension == "pdf" {
            return try await processPDF(url: url)
        } else if ["jpg", "jpeg", "png", "heic"].contains(fileExtension) {
            return try await processImage(url: url)
        } else {
            throw ProcessingError.unsupportedFileType
        }
    }
    
    private func processPDF(url: URL) async throws -> [Metric] {
        guard let pdfDocument = PDFDocument(url: url) else {
            throw ProcessingError.unreadableFile
        }
        
        var fullText = ""
        for pageIndex in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: pageIndex) else { continue }
            if let pageText = page.string {
                fullText += pageText + "\n"
            }
        }
        
        if fullText.isEmpty {
            throw ProcessingError.ocrFailed
        }
        
        return try await parseMetrics(from: fullText)
    }
    
    private func processImage(url: URL) async throws -> [Metric] {
        guard let imageData = try? Data(contentsOf: url),
              let uiImage = UIImage(data: imageData) else {
            throw ProcessingError.unreadableFile
        }
        
        guard let cgImage = uiImage.cgImage else {
            throw ProcessingError.unreadableFile
        }
        
        return try await performOCR(on: cgImage)
    }
    
    private func performOCR(on image: CGImage) async throws -> [Metric] {
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { [weak self] request, error in
                Task { @MainActor in
                    if let error = error {
                        continuation.resume(throwing: ProcessingError.ocrFailed)
                        return
                    }
                    
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {
                        continuation.resume(throwing: ProcessingError.ocrFailed)
                        return
                    }
                    
                    var fullText = ""
                    for observation in observations {
                        guard let topCandidate = observation.topCandidates(1).first else { continue }
                        fullText += topCandidate.string + "\n"
                    }
                    
                    if fullText.isEmpty {
                        continuation.resume(throwing: ProcessingError.ocrFailed)
                        return
                    }
                    
                    guard let self = self else {
                        continuation.resume(throwing: ProcessingError.ocrFailed)
                        return
                    }
                    
                    do {
                        let metrics = try await self.parseMetrics(from: fullText)
                        continuation.resume(returning: metrics)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: ProcessingError.ocrFailed)
            }
        }
    }
    
    private func parseMetrics(from text: String) async throws -> [Metric] {
        // Use LLM to parse metrics from OCR text
        // Following Phase 0 rules: extract metrics exactly as they appear in the report
        
        // Validate OCR text quality
        let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedText.isEmpty {
            throw ProcessingError.ocrFailed
        }
        
        // Check if text looks reasonable (has some alphanumeric content)
        let alphanumericCount = cleanedText.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().count
        if alphanumericCount < 10 {
            print("⚠️ OCR text seems too short or invalid")
            throw ProcessingError.ocrFailed
        }
        
        print("=== OCR Extracted Text ===")
        print(cleanedText)
        print("=== End OCR Text ===")
        
        // Call LLM to extract metrics
        // LLM is better at handling OCR errors than regex patterns
        let metrics = try await extractMetricsWithLLM(from: cleanedText)
        
        // Validate extracted metrics
        if metrics.isEmpty {
            print("❌ No metrics extracted from text")
            throw ProcessingError.parsingFailed
        }
        
        // Additional validation: check if metrics look reasonable
        let validMetrics = metrics.filter { metric in
            !metric.name.isEmpty && metric.name.count > 2 &&
            !metric.value.isEmpty &&
            !metric.referenceRange.isEmpty
        }
        
        if validMetrics.isEmpty {
            print("❌ No valid metrics found after validation")
            throw ProcessingError.parsingFailed
        }
        
        print("✅ Total metrics extracted: \(validMetrics.count)")
        return validMetrics
    }
    
    private func extractMetricsWithLLM(from text: String) async throws -> [Metric] {
        let prompt = """
        Extract health metrics from this lab report text. The text may have OCR errors, so be robust in parsing.
        
        OCR Text (may contain recognition errors):
        \(text)
        
        Instructions:
        1. Extract ONLY metrics that are explicitly mentioned in the text
        2. Handle OCR errors gracefully (e.g., "0" vs "O", "1" vs "l", spacing issues)
        3. For each metric, extract:
           - metric_name: Exact name as it appears (e.g., "Haemoglobin", "S.G.P.T.", "S.G.O.T.")
           - metric_value: The numeric value or symbol (e.g., "11.8", "80.00", "+++", "+")
           - unit: The unit if present (e.g., "G%", "U/L", "mg/dL", "µg/dL", "ng/mL", "/HPF") - leave empty string "" if no unit
           - reference_range: The reference range exactly as shown (e.g., "12.00 - 15.00", "< 34", "5.0 - 34.0", "Negative", "Nil")
        4. Do NOT infer or add metrics not in the text
        5. Do NOT categorize or rename metrics
        6. If text is unclear or has too many OCR errors, return empty array []
        7. Return ONLY valid JSON array, no other text or explanations
        
        Example output format:
        [
          {
            "metric_name": "Haemoglobin",
            "metric_value": "11.8",
            "unit": "G%",
            "reference_range": "12.00 - 15.00"
          },
          {
            "metric_name": "S.G.P.T.",
            "metric_value": "80.00",
            "unit": "U/L",
            "reference_range": "< 34"
          },
          {
            "metric_name": "Leucocytes (ESTERASE)",
            "metric_value": "+++",
            "unit": "",
            "reference_range": "Negative"
          }
        ]
        """
        
        let systemMessage = """
        You are a health report parser. Extract health metrics from lab reports.
        Return ONLY a valid JSON array. Do not add explanations or additional text.
        Extract metrics exactly as they appear in the report.
        """
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "system", "content": systemMessage],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.1, // Low temperature for consistent parsing
            "max_tokens": 2000
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ProcessingError.parsingFailed
        }
        
        let llmResponse = try JSONDecoder().decode(LLMParseResponse.self, from: data)
        guard let content = llmResponse.choices.first?.message.content else {
            throw ProcessingError.parsingFailed
        }
        
        // Parse the JSON response
        return try parseLLMResponse(content)
    }
    
    private func parseLLMResponse(_ jsonString: String) throws -> [Metric] {
        // Clean the response - remove markdown code blocks if present
        var cleaned = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned.hasPrefix("```json") {
            cleaned = String(cleaned.dropFirst(7))
        }
        if cleaned.hasPrefix("```") {
            cleaned = String(cleaned.dropFirst(3))
        }
        if cleaned.hasSuffix("```") {
            cleaned = String(cleaned.dropLast(3))
        }
        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Parse JSON
        guard let data = cleaned.data(using: .utf8) else {
            throw ProcessingError.parsingFailed
        }
        
        let metricsData = try JSONDecoder().decode([MetricData].self, from: data)
        
        return metricsData.map { data in
            let value = data.unit.isEmpty ? data.metric_value : "\(data.metric_value) \(data.unit)"
            return Metric(
                name: data.metric_name,
                value: value,
                referenceRange: data.reference_range
            )
        }
    }
    
    struct LLMParseResponse: Codable {
        let choices: [Choice]
        
        struct Choice: Codable {
            let message: Message
            
            struct Message: Codable {
                let content: String
            }
        }
    }
    
    struct MetricData: Codable {
        let metric_name: String
        let metric_value: String
        let unit: String
        let reference_range: String
    }
    
    private func parseTextBlocks(text: String) -> [Metric] {
        var metrics: [Metric] = []
        
        // Split by common delimiters and try to find metric patterns
        let blocks = text.components(separatedBy: CharacterSet(charactersIn: "\n\r\t"))
        
        for block in blocks {
            let trimmed = block.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty { continue }
            
            // Try to extract metric from block
            if let metric = extractMetric(from: trimmed) {
                metrics.append(metric)
            }
        }
        
        return metrics
    }
    
    private func parseAggressive(text: String) -> [Metric] {
        var metrics: [Metric] = []
        
        // More aggressive pattern matching - look for any pattern that might be a metric
        // Pattern: Any word(s) followed by number(s) followed by unit-like text
        
        // Try to find patterns like: "Word Word: Number Unit (Range)"
        let aggressivePattern = #"([A-Z][A-Za-z\s().]+?):\s*([\d.+\-]+)\s*([A-Za-z/%µg\s]*)\s*[\(<]?([^)\n]+)[\)]?"#
        
        if let regex = try? NSRegularExpression(pattern: aggressivePattern, options: [.caseInsensitive]) {
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            
            for match in matches {
                if match.numberOfRanges >= 4,
                   let nameRange = Range(match.range(at: 1), in: text),
                   let valueRange = Range(match.range(at: 2), in: text),
                   let unitRange = Range(match.range(at: 3), in: text),
                   let refRange = Range(match.range(at: 4), in: text) {
                    
                    let name = String(text[nameRange]).trimmingCharacters(in: .whitespaces)
                    let value = String(text[valueRange]).trimmingCharacters(in: .whitespaces)
                    let unit = String(text[unitRange]).trimmingCharacters(in: .whitespaces)
                    let refRangeStr = String(text[refRange]).trimmingCharacters(in: .whitespaces)
                    
                    if !name.isEmpty && name.count > 2 && !value.isEmpty {
                        metrics.append(Metric(
                            name: name,
                            value: unit.isEmpty ? value : "\(value) \(unit)",
                            referenceRange: refRangeStr.isEmpty ? "Not specified" : refRangeStr
                        ))
                    }
                }
            }
        }
        
        return metrics
    }
    
    private func extractMetric(from line: String) -> Metric? {
        // Enhanced pattern matching for various health report formats
        // Specifically handles Neuberg Supratech and similar lab report formats
        
        // Clean up the line - remove extra whitespace
        let cleaned = line.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        
        // Pattern 1: "Test Name: Value Unit (Reference Range)"
        // Example: "Haemoglobin: 11.8 G% (12.00 - 15.00)"
        // More flexible with spacing
        if let metric = tryPattern(cleaned, pattern: #"([A-Z][A-Za-z\s&/().]+?):\s*([\d.+\-]+)\s+([A-Za-z/%µg\s]+)\s*\(([^)]+)\)"#) {
            return metric
        }
        
        // Pattern 2: "Test Name: Value Unit Reference Range" (no parentheses)
        // Example: "S.G.P.T.: 80.00 U/L < 34"
        if let metric = tryPattern(cleaned, pattern: #"([A-Z][A-Za-z\s&/().]+?):\s*([\d.+\-]+)\s+([A-Za-z/%µg\s]+)\s+([<>\d.\s\-]+)"#) {
            return metric
        }
        
        // Pattern 3: "Test Name: Value (Reference Range)" - no unit
        // Example: "Leucocytes (ESTERASE): +++ (Negative)"
        if let metric = tryPatternNoUnit(cleaned, pattern: #"([A-Z][A-Za-z\s&/()]+?):\s*([\d.+\-]+)\s*\(([^)]+)\)"#) {
            return metric
        }
        
        // Pattern 4: "Test Name Value Unit (Reference Range)" - no colon
        if let metric = tryPattern(cleaned, pattern: #"([A-Z][A-Za-z\s&/()]+?)\s+([\d.+\-]+)\s+([A-Za-z/%µg\s]+)\s+\(([^)]+)\)"#) {
            return metric
        }
        
        // Pattern 5: Tab-separated format
        let tabComponents = cleaned.components(separatedBy: "\t")
        if tabComponents.count >= 3 {
            let name = tabComponents[0].trimmingCharacters(in: .whitespaces)
            let value = tabComponents[1].trimmingCharacters(in: .whitespaces)
            let unit = tabComponents.count > 2 ? tabComponents[2].trimmingCharacters(in: .whitespaces) : ""
            let refRange = tabComponents.count > 3 ? tabComponents[3].trimmingCharacters(in: .whitespaces) : ""
            
            if !name.isEmpty && !value.isEmpty && name.count > 2 {
                return Metric(
                    name: name,
                    value: unit.isEmpty ? value : "\(value) \(unit)",
                    referenceRange: refRange.isEmpty ? "Not specified" : refRange
                )
            }
        }
        
        // Pattern 6: Multiple spaces (table-like format) - more flexible
        let spaceComponents = cleaned.components(separatedBy: CharacterSet.whitespaces).filter { !$0.isEmpty }
        if spaceComponents.count >= 3 {
            // Try to identify name, value, unit, reference
            // Name is usually first, value is usually a number
            var nameParts: [String] = []
            var value: String?
            var unit: String?
            var refParts: [String] = []
            
            for (index, component) in spaceComponents.enumerated() {
                // Check if component is a number or symbol
                let isNumber = component.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
                let isSymbol = component == "+" || component == "++" || component == "+++" || component == "-"
                
                if value == nil && (isNumber || isSymbol) {
                    // This is likely the value
                    value = component
                    // Previous components are likely the name
                    if index > 0 {
                        nameParts = Array(spaceComponents[0..<index])
                    }
                    // Next component might be unit
                    if index + 1 < spaceComponents.count {
                        let next = spaceComponents[index + 1]
                        if next.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil && next.count < 10 {
                            unit = next
                            if index + 2 < spaceComponents.count {
                                refParts = Array(spaceComponents[(index + 2)...])
                            }
                        } else {
                            refParts = Array(spaceComponents[(index + 1)...])
                        }
                    }
                    break
                }
            }
            
            if let value = value, !nameParts.isEmpty {
                let name = nameParts.joined(separator: " ")
                let refRange = refParts.isEmpty ? "Not specified" : refParts.joined(separator: " ")
                
                return Metric(
                    name: name,
                    value: unit == nil ? value : "\(value) \(unit!)",
                    referenceRange: refRange
                )
            }
        }
        
        // Pattern 7: Pipe-separated format
        let pipeComponents = cleaned.components(separatedBy: "|")
        if pipeComponents.count >= 3 {
            let name = pipeComponents[0].trimmingCharacters(in: .whitespaces)
            let valueUnit = pipeComponents[1].trimmingCharacters(in: .whitespaces)
            let refRange = pipeComponents.count > 2 ? pipeComponents[2].trimmingCharacters(in: .whitespaces) : ""
            
            if !name.isEmpty && !valueUnit.isEmpty && name.count > 2 {
                return Metric(
                    name: name,
                    value: valueUnit,
                    referenceRange: refRange.isEmpty ? "Not specified" : refRange
                )
            }
        }
        
        return nil
    }
    
    private func tryPatternNoUnit(_ line: String, pattern: String) -> Metric? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]),
              let match = regex.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count)) else {
            return nil
        }
        
        guard match.numberOfRanges >= 3,
              let nameRange = Range(match.range(at: 1), in: line),
              let valueRange = Range(match.range(at: 2), in: line),
              let refRange = Range(match.range(at: 3), in: line) else {
            return nil
        }
        
        let name = String(line[nameRange]).trimmingCharacters(in: .whitespaces)
        let value = String(line[valueRange]).trimmingCharacters(in: .whitespaces)
        let referenceRange = String(line[refRange]).trimmingCharacters(in: .whitespaces)
        
        // Validate that we have meaningful data
        guard !name.isEmpty, !value.isEmpty, name.count > 2 else {
            return nil
        }
        
        return Metric(
            name: name,
            value: value,
            referenceRange: referenceRange.isEmpty ? "Not specified" : referenceRange
        )
    }
    
    private func tryPattern(_ line: String, pattern: String) -> Metric? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]),
              let match = regex.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count)) else {
            return nil
        }
        
        guard match.numberOfRanges >= 4,
              let nameRange = Range(match.range(at: 1), in: line),
              let valueRange = Range(match.range(at: 2), in: line),
              let unitRange = Range(match.range(at: 3), in: line),
              let refRange = Range(match.range(at: 4), in: line) else {
            return nil
        }
        
        let name = String(line[nameRange]).trimmingCharacters(in: .whitespaces)
        let value = String(line[valueRange]).trimmingCharacters(in: .whitespaces)
        let unit = String(line[unitRange]).trimmingCharacters(in: .whitespaces)
        let referenceRange = String(line[refRange]).trimmingCharacters(in: .whitespaces)
        
        // Validate that we have meaningful data
        // Value can be a number OR symbols like +, ++, +++
        let hasNumber = value.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
        let hasSymbol = value == "+" || value == "++" || value == "+++" || value == "-"
        guard !name.isEmpty, !value.isEmpty, name.count > 2, (hasNumber || hasSymbol) else {
            return nil
        }
        
        return Metric(
            name: name,
            value: unit.isEmpty ? value : "\(value) \(unit)",
            referenceRange: referenceRange.isEmpty ? "Not specified" : referenceRange
        )
    }
    
    private func parseTableFormat(text: String) throws -> [Metric] {
        // Try to parse table-like structures
        var metrics: [Metric] = []
        let lines = text.components(separatedBy: .newlines)
        
        // Look for lines that might be table rows
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty { continue }
            
            // Try to split by multiple spaces (table-like)
            let components = trimmed.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
            
            // If we have at least 3 components, might be a metric row
            if components.count >= 3 {
                // First component might be name, second value, third unit or reference
                let name = components[0]
                let value = components[1]
                
                // Check if value looks like a number
                if value.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil && name.count > 2 {
                    let unit = components.count > 2 ? components[2] : ""
                    let refRange = components.count > 3 ? components[3...].joined(separator: " ") : "Not specified"
                    
                    metrics.append(Metric(
                        name: name,
                        value: unit.isEmpty ? value : "\(value) \(unit)",
                        referenceRange: refRange
                    ))
                }
            }
        }
        
        return metrics
    }
}

enum ProcessingError: LocalizedError {
    case unsupportedFileType
    case unreadableFile
    case ocrFailed
    case parsingFailed
    
    var errorDescription: String? {
        switch self {
        case .unsupportedFileType:
            return "Unsupported file type. Please upload a PDF or image file."
        case .unreadableFile:
            return "Unable to read the file. Please try uploading again."
        case .ocrFailed:
            return "Unable to read the report. Please upload a clearer image or PDF."
        case .parsingFailed:
            return "Unable to extract metrics from the report. Please ensure the report is clear and try again."
        }
    }
}
