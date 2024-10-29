//
//  SpenitApp.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//

import SwiftUI
import SwiftData

@main
struct SpenitApp: App {
    
    var sharedModelContainer: ModelContainer = {
       let schema = Schema([
        Transaction.self
       ])
       let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

       do {
           return try ModelContainer(for: schema, configurations: [modelConfiguration])
       } catch {
           fatalError("Could not create ModelContainer: \(error)")
       }
    }()
    
    var body: some Scene {
        WindowGroup {
            TabView() {
                
                NavigationStack() {
                    OverviewView()
                        .navigationTitle("Overview")
                }
                .tabItem {
                    Label("Overview", systemImage: "eye")
                }
                .tag(0)
                
                        NavigationStack() {
                            AddTransactionView()
                                .navigationTitle("Add")
                        }
                        .tabItem {
                            Text("Add")
                            Image(systemName: "plus.app")
                                .renderingMode(.template)
                        }
                        .tag(1)
                        
                        NavigationStack() {
                            ListTransactionView()
                                .navigationTitle("List")
                        }
                        .tabItem {
                            Label("List", systemImage: "list.bullet")
                        }
                        .tag(2)

                    }
        }
        .modelContainer(sharedModelContainer)
    }
    
}
