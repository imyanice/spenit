//
//  Expense.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//

import SwiftData
import Foundation

enum AccountType: String, Codable, CaseIterable {
    case cash = "💶"
    case card = "💳"
}

enum TransactionType: String, Codable, CaseIterable {
    case expense = "📉"
    case income = "📈"
}

@Model
final class Transaction {
    var label: String
    var account: AccountType
    var amount: Double
    var date: Date
    var type: TransactionType
    
    init(label: String, account: AccountType, amount: Double, date: Date = .init(), type: TransactionType) {
        self.label = label
        self.account = account
        self.amount = amount
        self.date = Date.now
        self.type = type
    }
}
