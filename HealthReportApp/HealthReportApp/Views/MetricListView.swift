//
//  MetricListView.swift
//  HealthReportApp
//
//  Displays list of extracted metrics
//  Following Phase 0: no additional metrics, no severity colors, each metric is clickable
//

import SwiftUI

struct MetricListView: View {
    let metrics: [Metric]
    @EnvironmentObject var reportStore: ReportStore
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(metrics) { metric in
                    NavigationLink(value: metric) {
                        MetricRowView(metric: metric)
                    }
                }
            }
            .navigationTitle("Metrics")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        reportStore.clearCurrentReport()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Back")
                        }
                    }
                }
            }
            .navigationDestination(for: Metric.self) { metric in
                MetricExplanationView(metric: metric)
            }
        }
    }
}

struct MetricRowView: View {
    let metric: Metric
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(metric.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Text(metric.value)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(metric.referenceRange)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MetricListView(metrics: [
        Metric(name: "Hemoglobin", value: "14.5 g/dL", referenceRange: "12.0-16.0"),
        Metric(name: "Glucose", value: "95 mg/dL", referenceRange: "70-100")
    ])
}
