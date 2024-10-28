//
//  ListExpensesView.swift
//  Spenit
//
//  Created by Yan :) on 28/10/2024.
//
import SwiftData
import SwiftUI

struct ListExpensesView: View {
    @Query var expenses: [Expense]
    @State var keyWord: String = ""
    @Environment(\.modelContext) var modelContext
    
    
    var body: some View {
           List {
               ForEach(expenses, id: \.self) { expense in
                   HStack {
                       HStack {
                           VStack(alignment: .leading) {
                               Text(expense.label)
                                   .font(.headline)
                               Text(expense.date.formatted())
                                   .font(.subheadline)
                                   .foregroundStyle(.secondary)
                           }
                           
                           Spacer()
                           
                           VStack(alignment: .trailing) {
                               Text(expense.amount, format: .number)
                                   .font(.caption)
                                   .foregroundStyle(.white)
                                   .padding(.horizontal, 10)
                                   .padding(.vertical, 2)
                                   .background(.blue)
                                   .clipShape(RoundedRectangle(cornerRadius: 5.0))
                                   .padding(.vertical, 2)
                           }
                           
                       }
                   }
                  .swipeActions(edge: .leading, allowsFullSwipe: false) {
                      NavigationLink {
                          EditExpenseView(expense: expense)
                       } label: {
                           Text("Edit")
                       }
                    .tint(.blue)
                   }
               }
               .onDelete(perform: onDelete)
           }
           .overlay(alignment: .center, content: {
               Group {
                   if false {
                       Text("Oops, looks like there's no data...")
                           .foregroundStyle(.secondary)
                           .multilineTextAlignment(.center)
                   }
               }
           })
           .navigationTitle("Expense List")
           .searchable(text: $keyWord)
           .toolbar(content: {
               ToolbarItem {
                   NavigationLink {
                       AddExpenseView()
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
       private func onDelete(at indexSet: IndexSet){
           for index in indexSet {
               let expenseToDelete = expenses[index]
               modelContext.delete(expenseToDelete)
           }
       }

       // TODO: to be updated
       private func onEdit() {
           print("Edit action")
       }
   }

#Preview {
    NavigationStack {
        ListExpensesView()
    }
}
