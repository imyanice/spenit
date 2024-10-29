//
//  ListExpensesView.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//
import SwiftData
import SwiftUI

struct ListTransactionView: View {
    @Query var transactions: [Transaction]
    @State var keyWord: String = ""
    @Environment(\.modelContext) var modelContext
    @State private var transactionSheetItem: Transaction? = nil

    var body: some View {
        List {
            ForEach(transactions, id: \.self) { transaction in
                @State var showSheet: Bool = false
                Button(action: {
                    transactionSheetItem = transaction
                    showSheet.toggle()
                }) {
                    HStack {

                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(transaction.account.rawValue)
                                    Text(transaction.label)
                                        .font(.headline)
                                }
                                Text(transaction.date.formatted())
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text(transaction.amount, format: .number)
                                    .font(.caption)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 2)
                                    .background(
                                        transaction.type == .expense
                                            ? .blue : .green
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 5.0)
                                    )
                                    .padding(.vertical, 2)
                            }

                        }

                    }
                }.sheet(item: $transactionSheetItem) { item in
                    TransactionView(transaction: item)
                }.buttonStyle(PlainButtonStyle())

                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    NavigationLink {
                        EditTransactionView(transaction: transaction)
                    } label: {
                        Text("Edit")
                    }
                    .tint(.blue)
                }
            }
            .onDelete(perform: onDelete)
        }
        .overlay(
            alignment: .center,
            content: {
                Group {
                    if false {
                        Text("Oops, looks like there's no data...")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        )
        .navigationTitle("Transactions")
        .searchable(text: $keyWord)
        .toolbar(content: {
            ToolbarItem {
                NavigationLink {
                    AddTransactionView()
                } label: {
                    Image(systemName: "plus")
                }
            }

        })
        .onChange(of: keyWord) {
            // TODO: to be updated
        }
    }

    // TODO: to be updated
    private func onDelete(at indexSet: IndexSet) {
        for index in indexSet {
            let transactionToDelete = transactions[index]
            modelContext.delete(transactionToDelete)
        }
    }

    // TODO: to be updated
    private func onEdit() {
        print("Edit action")
    }
}

#Preview {
    NavigationStack {
        ListTransactionView()
    }
}
