//
//  ContentView.swift
//  HealthReportApp
//
//  Main entry point view
//

import SwiftUI

struct ContentView: View {
    @StateObject private var reportStore = ReportStore()
    
    var body: some View {
        NavigationStack {
            ReportUploadView()
                .environmentObject(reportStore)
        }
    }
}

#Preview {
    ContentView()
}
