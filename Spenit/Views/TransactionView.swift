//
//  TransactionView.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//

import SwiftData
import SwiftUI

struct TransactionView: View {
    @State var transaction: Transaction = .init(label: "Placeholder", account: .card, amount: 0, date: Date.now, type: .expense)
    
    var body: some View {
        Text(transaction.label)
    }
}
