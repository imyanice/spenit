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

@Model
final class Expense {
    var label: String
    var account: AccountType
    var amount: Double
    var date: Date
    
    init(label: String, account: AccountType, amount: Double, date: Date = .init()) {
        self.label = label
        self.account = account
        self.amount = amount
        self.date = Date.now
    }
}
