//
//  EditExpenseView.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//


import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var transaction: Transaction = .init(label: "Placeholder", account: .card, amount: 0, date: Date.now, type: .expense)
    
    var body: some View {
        Form {
            Section {
                HStack { TextField("Name", text: $transaction.label) }
                HStack { TextField("Amount", value: $transaction.amount, format: .number) }
                
                DatePicker("Date", selection: $transaction.date, displayedComponents: .date)
                
                Picker("Account used", selection: $transaction.account ) {
                    ForEach(AccountType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)}
                }.pickerStyle(.menu)
                
                Picker("", selection: $transaction.type) {
                    ForEach(TransactionType.allCases, id: \.self) {
                        type in Text(type.rawValue).tag(type)
                    }
                }.pickerStyle(.palette)
                
            }
        }
        .navigationTitle("Edit a transaction")
            .toolbarTitleDisplayMode(.inline)
            .toolbar(content: {
                Button(action: {
                    save()
                }, label: { Text("Save") }).disabled(transaction.label == "" || transaction.amount == 0)
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
