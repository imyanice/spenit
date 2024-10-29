//
//  EditExpenseView.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//

import SwiftData
import SwiftUI

struct EditTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State var transaction: Transaction = .init(
        label: "Placeholder", account: .card, amount: 0, date: Date.now,
        type: .expense)

    var body: some View {
        List {
            Section(header: Text("LABEL")) {
                TextField("Groceries", text: $transaction.label)

            }
            Section(header: Text("AMOUNT")) {

                TextField("Amount", value: $transaction.amount, format: .number)

            }

            Section(header: Text("DATE")) {
                DatePicker(
                    "Date", selection: $transaction.date,
                    displayedComponents: .date
                ).datePickerStyle(.graphical)

            }
            Section(header: Text("Type")) {
                Picker("Account used", selection: $transaction.account) {
                    ForEach(AccountType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }.pickerStyle(.palette)

                Picker("", selection: $transaction.type) {
                    ForEach(TransactionType.allCases, id: \.self) {
                        type in Text(type.rawValue).tag(type)
                    }
                }.pickerStyle(.palette)
            }
            Section(header: Text("DANGER")) {
                Button(action: deleteTransaction) {
                    Label("Delete Transaction", systemImage: "trash.fill")
                        .foregroundStyle(.red)
                }
            }
        }.listSectionSpacing(.compact)
            .navigationTitle("Edit a transaction")
            .toolbarTitleDisplayMode(.inline)
            .toolbar(content: {
                Button(
                    action: {
                        save()
                    }, label: { Text("Save") }
                ).disabled(transaction.label == "" || transaction.amount <= 0)
            })
    }

    func deleteTransaction() {
        modelContext.delete(transaction)
        dismiss()
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
