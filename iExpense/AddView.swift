//
//  AddView.swift
//  iExpense
//
//  Created by Caden Huffman on 7/28/23.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @Environment(\.dismiss) var dismiss
    let types = ["Personal", "Business"]
    var body: some View {
        NavigationView{
            Form{
                TextField("Name", text: $name)
                Picker("Type", selection: $type, content: {
                    ForEach(types, id: \.self, content: {
                        Text($0)
                    })
                })
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                    
            }
            .navigationTitle("Add new expense")
            .toolbar(content: {
                Button("Save", action: {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                })
                
            })
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
