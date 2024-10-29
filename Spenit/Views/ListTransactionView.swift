import SwiftData
import SwiftUI

struct ListTransactionView: View {
    @Query var transactions: [Transaction]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        
        let groupedTransactions = groupTransactionsByWeek(
            transactions: transactions.sorted { $0.date > $1.date })
        List {
            ForEach(groupedTransactions.indices, id: \.self) { index in
                let weekTransactions = groupedTransactions[index]
                Section() {
                    ForEach(weekTransactions, id: \.self) { transaction in
                        @State var showSheet: Bool = false
                        
                        NavigationLink{ EditTransactionView(transaction: transaction)} label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(transaction.account.rawValue)
                                        Text(transaction.label)
                                            .font(.headline)
                                    }
                                    Text(dateFormatter.string(from: transaction.date))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text(
                                        "\(transaction.type == .expense ? "-" : "+") \(transaction.amount.formatted(.currency(code: "EUR")))"
                                    )
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        transaction.type == .expense
                                        ? .red : .green
                                    )
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 2)
                                }
                            }
                        }
                        
                    }
                }
            }
            
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
        .toolbar(content: {
            ToolbarItem {
                NavigationLink {
                    AddTransactionView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        })
    }
    
    private func groupTransactionsByWeek(transactions: [Transaction])
    -> [[Transaction]]
    {
        var groupedTransactions: [[Transaction]] = []
        var currentWeek: [Transaction] = []
        var currentWeekStart: Date? = nil
        
        for transaction in transactions {
            let startOfWeek = Calendar.current.startOfWeek(
                for: transaction.date)
            if currentWeekStart == nil || startOfWeek != currentWeekStart {
                if !currentWeek.isEmpty {
                    groupedTransactions.append(currentWeek)
                }
                currentWeek = []
                currentWeekStart = startOfWeek
            }
            currentWeek.append(transaction)
        }
        
        if !currentWeek.isEmpty {
            groupedTransactions.append(currentWeek)
        }
        
        print(groupedTransactions)
        
        return groupedTransactions
    }
    
    private func onDelete(at indexSet: IndexSet) {
        for index in indexSet {
            let transactionToDelete = transactions[index]
            modelContext.delete(transactionToDelete)
        }
    }
    
    private func onEdit() {
        print("Edit action")
    }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/MM/yyyy"
            return dateFormatter
        }()
    
    
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
