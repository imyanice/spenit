//
//  Data.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//

import SwiftData
import Foundation

@Model
class StorageAA {
    var transactions: [Transaction]
    var expenses: Double
    
    init(transactions: [Transaction] = [], expenses: Double) {
        self.transactions = transactions
        self.expenses = expenses
    }
}
