
//
//  AddExpense.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var label: String = ""
    @State var account: AccountType = .card
    @State var date: Date = Date.now
    @State var amount: Double = 0

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
        .navigationTitle("Add an expense")
            .toolbarTitleDisplayMode(.inline)
            .toolbar(content: {
                Button(action: {
                    save()
                }, label: {Text("Save")})
            })
    }
    
    func save() {
        let newExpense = Expense(label: label, account: account, amount: amount, date: date)
        modelContext.insert(newExpense)
        
        dismiss()
    }
}
