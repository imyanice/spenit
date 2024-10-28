//
//  EditExpenseView.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//


import SwiftUI
import SwiftData

struct EditExpenseView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var label: String = ""
    @State var account: AccountType = .card
    @State var date: Date = Date.now
    @State var amount: Double = 0
    
    @State var expense: Expense = .init(label: "Test", account: .card, amount: 0, date: Date.now)
    
    var body: some View {
        Form {
            Section {
                HStack { TextField("Name", text: $label) }
                HStack { TextField("Amount", value: $amount, format: .number) }
                DatePicker("Date", selection: $date, displayedComponents: .date)
                Picker("Account used", selection: $account ) {
                    ForEach(AccountType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)}
                }.pickerStyle(.menu)
            }
        }
        .navigationTitle("Edit an expense")
            .toolbarTitleDisplayMode(.inline)
            .toolbar(content: {
                Button(action: {
                    save()
                }, label: {Text("Save")})
            })
    }
    
    func save() {
        do {
            try modelContext.save()
        } catch {
            print("Failed update task...", error.localizedDescription)
        }
        dismiss()
    }
    
}
