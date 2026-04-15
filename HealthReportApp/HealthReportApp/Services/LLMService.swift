//
//  LLMService.swift
//  HealthReportApp
//
//  Service for generating explanations and lifestyle context
//  Following Phase 0 rules: calm, non-medical, explanatory only
//

import Foundation

@MainActor
class LLMService: ObservableObject {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String? = nil) {
        // Use provided key, environment variable, or default key
        self.apiKey = apiKey ?? 
                     ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? 
                     ["OPENAI_API_KEY_NAME"]
    }
    
    /// Generates explanation and lifestyle context for a metric following Phase 0 rules
    /// - Phase 0 compliance: LLM only sees metric name, value, reference range, optional age/gender
    /// - Phase 0 compliance: Generates calm, non-medical, explanatory text only
    /// - Phase 0 compliance: NO diagnosis, prediction, urgency, medication, supplements, tests
    func generateExplanation(for metric: Metric, ageRange: String? = nil, gender: String? = nil) async throws -> (explanation: String, lifestyleContext: String) {
        let prompt = buildPrompt(for: metric, ageRange: ageRange, gender: gender)
        
        // Call real LLM API
        let response = try await callLLMAPI(prompt: prompt)
        return parseLLMResponse(response)
    }
    
    private func buildPrompt(for metric: Metric, ageRange: String?, gender: String?) -> String {
        var prompt = """
        Generate a calm, non-medical explanation for this health metric following Phase 0 rules.
        
        METRIC DATA (ONLY data you have access to):
        - Metric Name: \(metric.name)
        - Metric Value: \(metric.value)
        - Reference Range: \(metric.referenceRange)
        """
        
        if let ageRange = ageRange {
            prompt += "\n- Age Range: \(ageRange)"
        }
        
        if let gender = gender {
            prompt += "\n- Gender: \(gender)"
        }
        
        prompt += """
        
        PHASE 0 RULES - STRICTLY FOLLOW:
        
        EXPLANATION CARD REQUIREMENTS:
        1. Must be calm, non-medical, and explanatory only
        2. NO diagnosis of conditions
        3. NO prediction of disease or health outcomes
        4. NO urgent, alarmist, or fear-inducing language
        5. NO medical categorization or interpretation
        6. Explain what the metric measures in simple, educational terms
        7. Use neutral, informative tone
        
        LIFESTYLE CONTEXT REQUIREMENTS:
        1. High-level lifestyle change suggestions ONLY
        2. NO specific plans, targets, or prescriptions
        3. NO recommendations for medication, supplements, or medical tests
        4. NO detailed action plans or step-by-step instructions
        5. General guidance about lifestyle factors (activity, nutrition, sleep, stress)
        
        STRICT PROHIBITIONS:
        - NEVER diagnose conditions
        - NEVER predict health outcomes
        - NEVER use urgent language (e.g., "immediately", "urgent", "critical", "dangerous")
        - NEVER recommend specific medications, supplements, or tests
        - NEVER create treatment plans or prescriptions
        - NEVER interpret values as "normal" or "abnormal" - only state the reference range
        - NEVER provide medical advice
        
        DATA CONSTRAINTS:
        - You ONLY see: metric name, value, reference range, optional age/gender
        - You NEVER see: raw PDF text, OCR output, medical history, prescriptions, doctor notes, user emotions
        
        If data is missing or unclear, state uncertainty and do not speculate.
        
        RESPONSE FORMAT:
        - Generate ONLY the explanation text and lifestyle context text
        - Do NOT include labels like "EXPLANATION:", "RESPONSE 1:", "RESPONSE 2:", "LIFESTYLE CONTEXT:", etc.
        - Do NOT include numbered prefixes like "1.", "2."
        - Do NOT include headers or footers
        - Return ONLY the clean text content
        
        Format your response as:
        [Explanation text here - no labels or prefixes]
        
        LIFESTYLE CONTEXT:
        [Lifestyle context text here - no labels or prefixes]
        """
        
        return prompt
    }
    
    private func generatePlaceholderExplanation(for metric: Metric) -> String {
        // Placeholder - in production, this would be the actual LLM response
        return """
        \(metric.name) is a measurement that helps understand certain aspects of health. 
        Your value of \(metric.value) falls within the context of the reference range \(metric.referenceRange). 
        This measurement is one of many factors that can be considered when looking at overall health patterns.
        """
    }
    
    private func generatePlaceholderLifestyleContext(for metric: Metric) -> String {
        // Placeholder - in production, this would be the actual LLM response
        // Following Phase 0: high-level lifestyle suggestions only, no plans/targets/prescriptions
        return """
        General lifestyle factors such as regular physical activity, balanced nutrition, 
        adequate sleep, and stress management can contribute to overall well-being. 
        Consider discussing your health goals with a healthcare provider.
        """
    }
    
    // MARK: - Production API Implementation
    
    /// Calls LLM API with Phase 0 rules embedded in system message and user prompt
    private func callLLMAPI(prompt: String) async throws -> String {
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // System message with Phase 0 rules - enforces safety at the model level
        let systemMessage = """
        You are a health information assistant that provides calm, non-medical explanations about health metrics following Phase 0 safety rules.
        
        CRITICAL RULES:
        - You ONLY provide educational explanations about what metrics measure
        - You NEVER diagnose conditions, predict outcomes, or provide medical advice
        - You NEVER use urgent, alarmist, or fear-inducing language
        - You NEVER recommend medications, supplements, or medical tests
        - You provide high-level lifestyle suggestions only (no plans, targets, or prescriptions)
        - You maintain a calm, neutral, educational tone at all times
        
        RESPONSE FORMAT:
        - Return ONLY the text content, no labels, headers, or prefixes
        - Do NOT include "RESPONSE 1:", "RESPONSE 2:", "EXPLANATION:", "LIFESTYLE CONTEXT:" or similar labels
        - Do NOT include numbered prefixes like "1.", "2."
        - Return clean text only
        
        Your role is to help users understand their health metrics in a safe, non-medical, educational way.
        """
        
        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "system", "content": systemMessage],
                ["role": "user", "content": prompt] // User prompt also contains Phase 0 rules
            ],
            "temperature": 0.7,
            "max_tokens": 500
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw LLMError.apiError("API request failed")
        }
        
        let llmResponse = try JSONDecoder().decode(LLMResponse.self, from: data)
        return llmResponse.choices.first?.message.content ?? ""
    }
    
    /// Parses LLM response into explanation and lifestyle context
    /// Cleans up unwanted prefixes and formatting
    private func parseLLMResponse(_ response: String) -> (explanation: String, lifestyleContext: String) {
        // Clean up unwanted prefixes like "RESPONSE 1:", "RESPONSE 2:", etc.
        var cleaned = response.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove common unwanted prefixes
        let unwantedPrefixes = [
            "RESPONSE 1:",
            "RESPONSE 2:",
            "Response 1:",
            "Response 2:",
            "RESPONSE 1",
            "RESPONSE 2",
            "Response 1",
            "Response 2",
            "1.",
            "2.",
            "EXPLANATION:",
            "Explanation:",
            "LIFESTYLE CONTEXT:",
            "Lifestyle Context:"
        ]
        
        for prefix in unwantedPrefixes {
            if cleaned.hasPrefix(prefix) {
                cleaned = String(cleaned.dropFirst(prefix.count)).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        // Try to split by "LIFESTYLE CONTEXT:" or similar markers
        let lifestyleMarkers = [
            "LIFESTYLE CONTEXT:",
            "Lifestyle Context:",
            "LIFESTYLE:",
            "Lifestyle:",
            "LIFESTYLE CONTEXT",
            "Lifestyle Context"
        ]
        
        for marker in lifestyleMarkers {
            let components = cleaned.components(separatedBy: marker)
            if components.count >= 2 {
                var explanation = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                var lifestyleContext = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Clean up explanation - remove all unwanted text
                explanation = cleanText(explanation)
                lifestyleContext = cleanText(lifestyleContext)
                
                return (explanation, lifestyleContext)
            }
        }
        
        // Fallback: split response in half
        let lines = cleaned.components(separatedBy: .newlines)
        let midPoint = lines.count / 2
        var explanation = lines[0..<midPoint].joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
        var lifestyleContext = lines[midPoint..<lines.count].joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
        
        explanation = cleanText(explanation)
        lifestyleContext = cleanText(lifestyleContext)
        
        return (explanation.isEmpty ? cleaned : explanation, lifestyleContext)
    }
    
    /// Cleans up text by removing unwanted prefixes, suffixes, and formatting
    private func cleanText(_ text: String) -> String {
        var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove "RESPONSE 1:", "RESPONSE 2:", etc. anywhere in the text (case insensitive)
        // This pattern matches "RESPONSE" or "Response" followed by space, number, and optional colon/period
        cleaned = cleaned.replacingOccurrences(
            of: #"(?i)\s*RESPONSE\s+\d+[:.]?\s*"#,
            with: "",
            options: .regularExpression
        )
        
        // Also remove "Response" (capitalized) patterns
        cleaned = cleaned.replacingOccurrences(
            of: #"\s*Response\s+\d+[:.]?\s*"#,
            with: "",
            options: .regularExpression
        )
        
        // Remove numbered prefixes like "1.", "2.", etc. at the start
        cleaned = cleaned.replacingOccurrences(
            of: #"^\d+\.\s*"#,
            with: "",
            options: .regularExpression
        )
        
        // Remove numbered suffixes like "2.", "3." etc. at the end
        cleaned = cleaned.replacingOccurrences(
            of: #"\s*\d+\.\s*$"#,
            with: "",
            options: .regularExpression
        )
        
        // Remove numbered items in the middle (like standalone "2." on its own line)
        cleaned = cleaned.replacingOccurrences(
            of: #"\n\s*\d+\.\s*\n"#,
            with: "\n",
            options: .regularExpression
        )
        
        // Remove common headers/footers
        let unwantedHeaders = [
            "EXPLANATION:",
            "Explanation:",
            "EXPLANATION",
            "Explanation",
            "LIFESTYLE CONTEXT:",
            "Lifestyle Context:",
            "LIFESTYLE:",
            "Lifestyle:"
        ]
        
        for header in unwantedHeaders {
            // Remove from anywhere (case insensitive)
            cleaned = cleaned.replacingOccurrences(of: header, with: "", options: .caseInsensitive)
        }
        
        // Remove markdown formatting if present
        cleaned = cleaned.replacingOccurrences(of: "**", with: "")
        cleaned = cleaned.replacingOccurrences(of: "*", with: "")
        cleaned = cleaned.replacingOccurrences(of: "__", with: "")
        cleaned = cleaned.replacingOccurrences(of: "_", with: "")
        
        // Remove any remaining "RESPONSE X:" patterns (final pass, more aggressive)
        // Match with or without spaces before/after
        cleaned = cleaned.replacingOccurrences(
            of: #"(?i)(\s|^)RESPONSE\s+\d+[:.]?(\s|$)"#,
            with: "$1$2",
            options: .regularExpression
        )
        
        // Clean up multiple spaces and newlines
        cleaned = cleaned.replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: #"\n\s*\n"#, with: "\n", options: .regularExpression)
        
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum LLMError: LocalizedError {
    case missingAPIKey
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "LLM API key not configured"
        case .apiError(let message):
            return "LLM API error: \(message)"
        }
    }
}

struct LLMResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
        
        struct Message: Codable {
            let content: String
        }
    }
}
