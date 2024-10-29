
//
//  AddExpense.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var label: String = ""
    @State var account: AccountType = .card
    @State var date: Date = Date.now
    @State var amount: Double? = nil
    @State var transactionType: TransactionType = .expense

    var body: some View {
        List {
            Section(header: Text("Label")) {
                TextField("Groceries", text: $label)

            }
            Section(header: Text("Amount")) {

                TextField("Amount", value: $amount, format: .number).keyboardType(.decimalPad)

            }

            Section(header: Text("Date")) {
                DatePicker(
                    "Date", selection: $date,
                    displayedComponents: .date
                ).datePickerStyle(.graphical)

            }
            Section(header: Text("Type")) {
                Picker("Account used", selection: $account) {
                    ForEach(AccountType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }.pickerStyle(.palette)

                Picker("", selection: $transactionType) {
                    ForEach(TransactionType.allCases, id: \.self) {
                        type in Text(type.rawValue).tag(type)
                    }
                }.pickerStyle(.palette)
            }
        }.listSectionSpacing(.compact)
            .navigationTitle("Add a transaction")
            .toolbarTitleDisplayMode(.inline)
            .toolbar(content: {
                Button(
                    action: {
                        save()
                    }, label: { Text("Save") }
                ).disabled(label == "" || amount ?? -1 <= 0)
            })
    }
    
    func save() {
        if let amount {
            if (!amount.isNaN && !label.isEmpty) {
                let newTransaction = Transaction(label: label, account: account, amount: amount, date: date, type: transactionType)
                modelContext.insert(newTransaction)
                reset()
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
    func reset() {
        label = ""
        amount = nil
        date = Date.now
    }
    
    private var isGoodInput: Bool {
        if let amount {
            if !amount.isNaN && !label.isEmpty && amount > 0 { return true }
            return false
        }
        return false
    }
}
