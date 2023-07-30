//
//  ContentView.swift
//  iExpense
//
//  Created by Caden Huffman on 7/26/23.
//

import SwiftUI



struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    var body: some View {
        NavigationView{
            List{
                Section(header:Text("Personal")){
                    ForEach(expenses.items) { item in
                        if item.type == "Personal"{
                            ExpenseRowView(item: item)
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                Section(header:Text("Business")){
                    ForEach(expenses.items) { item in
                        if item.type == "Business"{
                            ExpenseRowView(item: item)
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .navigationTitle("iExpense")
            .toolbar{
                Button{
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense, content: {
                AddView(expenses: expenses)
            })
        }
    }
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}
struct ExpenseRowView: View{
    var item: ExpenseItem
    var body: some View{
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            
            Spacer()
            if item.amount < 100{
                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(item.amount > 10 ? .title: .body)
            }
            else{
                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.largeTitle)
            }
            
        }
    }
}
struct ExpenseItem: Identifiable, Codable{
    let name:String
    let type:String
    let amount:Double
    var id = UUID()
}
class Expenses: ObservableObject{
    @Published var items = [ExpenseItem]() {
        didSet{
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
