import SwiftData
import SwiftUI

struct ListTransactionView: View {
    @Query var transactions: [Transaction]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        
        let groupedTransactions = groupTransactionsByDay(
            transactions: transactions.sorted { $0.date > $1.date })
        List {
            ForEach(groupedTransactions.indices, id: \.self) { index in
                let dayTransactions = groupedTransactions[index]
     
                Section(header: Text(dateFormatter.string(from: dayTransactions[0].date))) {
                    ForEach(dayTransactions, id: \.self) { transaction in
                        @State var showSheet: Bool = false
                        
                        NavigationLink{ EditTransactionView(transaction: transaction)} label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(transaction.account.rawValue)
                                        Text(transaction.label)
                                            .font(.headline)
                                    }
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
        };
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
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "fr_FR")
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
