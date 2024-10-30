import SwiftData
import SwiftUI

struct ListTransactionView: View {
    @Query var transactions: [Transaction]
    @Environment(\.modelContext) var modelContext

    var body: some View {
        let groupedTransactions = groupTransactionsByDay(transactions: transactions.sorted { $0.date > $1.date })
        
        List {
            ForEach(groupedTransactions, id: \.self) { dayTransactions in
                Section(
                    header: HStack() {
                        Text(dateFormatter.string(from: dayTransactions[0].date))
                        Spacer()
                        Text(getNetTotal(transactionsToCheck: dayTransactions))
                    }
                ) {
                    ForEach(dayTransactions, id: \.self) { transaction in
                        NavigationLink {
                            EditTransactionView(transaction: transaction)
                        } label: {
                            transactionLabel(transaction: transaction)
                        }
                    }
                }
            }
        }
        .overlay(
            alignment: .center,
            content: {
                if transactions.isEmpty {
                    Text("Oops, looks like there's no data...")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        )
        .navigationTitle("Transactions")
    }

    private func transactionLabel(transaction: Transaction) -> some View {
        HStack {
            HStack() {
                Text(transaction.account.rawValue)
                Text(transaction.label).font(.headline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(transaction.type == .expense ? "-" : "+") \(transaction.amount.formatted(.currency(code: "EUR")))")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(transaction.type == .expense ? .red : .green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
            }
        }
    }

    private func groupTransactionsByDay(transactions: [Transaction]) -> [[Transaction]] {
        var groupedTransactions: [[Transaction]] = []
        var currentDay: [Transaction] = []
        var currentDayStart: Date? = nil

        for transaction in transactions {
            let startOfDay = Calendar.current.startOfDay(for: transaction.date)
            if currentDayStart == nil || startOfDay != currentDayStart {
                if !currentDay.isEmpty {
                    groupedTransactions.append(currentDay)
                }
                currentDay = []
                currentDayStart = startOfDay
            }
            currentDay.append(transaction)
        }

        if !currentDay.isEmpty {
            groupedTransactions.append(currentDay)
        }
        return groupedTransactions
    }

    private func onDelete(at indexSet: IndexSet) {
        for index in indexSet {
            let transactionToDelete = transactions[index]
            modelContext.delete(transactionToDelete)
        }
    }

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter
    }()

    private func getNetTotal(transactionsToCheck: [Transaction]) -> String {
        let netTotal = transactionsToCheck.reduce(0) { partialResult, transaction in
            partialResult + (transaction.type == .expense ? -transaction.amount : transaction.amount)
        }
        return netTotal.formatted(.currency(code: "EUR"))
    }
}

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        return self.dateInterval(of: .weekOfYear, for: date)?.start ?? date
    }
}

#Preview {
    NavigationStack {
        ListTransactionView()
    }
}
