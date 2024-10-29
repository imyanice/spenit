
//
//  AddExpense.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var label: String = ""
    @State var account: AccountType = .card
    @State var date: Date = Date.now
    @State var amount: Double? = nil
    @State var transactionType: TransactionType = .expense

    var body: some View {
        Form {
            Section {
                HStack { TextField("Name", text: $label) }
                HStack {
                    Text("Amount")
                    TextField("Amount", value: $amount, format: .number) }
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
                
                Picker("Account used", selection: $account ) {
                    ForEach(AccountType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)}
                }.pickerStyle(.menu)
                
                Picker("", selection: $transactionType) {
                    ForEach(TransactionType.allCases, id: \.self) {
                        type in Text(type.rawValue).tag(type)
                    }
                }.pickerStyle(.palette)
            }
        }
        .navigationTitle("Add a transaction")
            .toolbarTitleDisplayMode(.inline)
            .toolbar(content: {
                Button(action: {
                    save()
                }, label: { Text("Save") }).disabled(!isGoodInput)
            })
    }
    
    func save() {
        if let amount {
            if (!amount.isNaN && !label.isEmpty) {
                let newTransaction = Transaction(label: label, account: account, amount: amount, date: date, type: transactionType)
                modelContext.insert(newTransaction)
                dismiss()
            }
        }
    }
    
    private var isGoodInput: Bool {
        if let amount {
            if !amount.isNaN && !label.isEmpty { return true }
            return false
        }
        return false
    }
}
