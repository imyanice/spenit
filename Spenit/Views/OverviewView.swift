//
//  OverviewView.swift
//  Spenit
//
//  Created by Yan :) on 29/10/2024.
//
import SwiftUI
import SwiftData

struct OverviewView: View {
    @State var expensesAmountCard: Double = 0
    @State var expensesAmountCash: Double = 0
    @State var incomesAmountCard: Double = 0
    @State var incomesAmountCash: Double = 0
    
    @Query var transactions: [Transaction] = []
    var body: some View {
        
        List {
            Section(header: Text(AccountType.card.rawValue)) {
                HStack {
                    VStack {
                        Text(incomesAmountCard - expensesAmountCard, format: .currency(code: "EUR")).font(.headline).foregroundStyle(incomesAmountCard - expensesAmountCard < 0 ? .red : .primary)
                        Text("Available")
                        Text("Available")
                    }
                    Spacer()
                    VStack {
                        Text(expensesAmountCard, format: .currency(code: "EUR")).font(.headline)
                        Text("Spent")
                    }
                    Spacer()
                    VStack {
                        Text(incomesAmountCard, format: .currency(code: "EUR")).font(.headline)
                        Text("Earned")
                    }
                }
            }
            Section(header: Text(AccountType.cash.rawValue)) {
                HStack {
                    VStack {
                        Text(incomesAmountCash - expensesAmountCash, format: .currency(code: "EUR")).font(.headline).foregroundStyle(incomesAmountCash - expensesAmountCash < 0 ? .red : .primary)
                        Text("Available")
                    }
                    Spacer()
                    VStack {
                        Text(expensesAmountCash, format: .currency(code: "EUR")).font(.headline)
                        Text("Spent")
                    }
                    Spacer()
                    VStack {
                        Text(incomesAmountCash, format: .currency(code: "EUR")).font(.headline)
                        Text("Earned")
                    }
                }
            }
        }.onAppear(perform: getExpenseTotal)
    }
    
    private func getExpenseTotal() {
        expensesAmountCard = 0
        expensesAmountCash = 0
        incomesAmountCard = 0
        incomesAmountCash = 0
        
        for transaction in transactions {
            switch (transaction.type, transaction.account) {
            case (.expense, .card):
                expensesAmountCard += transaction.amount
            case (.expense, .cash):
                expensesAmountCash += transaction.amount
            case (.income, .card):
                incomesAmountCard += transaction.amount
            case (.income, .cash):
                incomesAmountCash += transaction.amount
            }
        }
    }
}

