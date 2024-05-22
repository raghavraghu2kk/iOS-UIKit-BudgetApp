//
//  BudgetCategoryTableViewCell.swift
//  BudgetApp
//
//  Created by Raghavendra Mirajkar on 22/05/24.
//

import SwiftUI
import UIKit

struct BudgetCategoryTableViewCell: View {
    @State var nameLabel : String
    @State var amountLabel : String
    @State var remainingLabel : String
    
    init(nameLabel: String, amountLabel: String, remainingLabel: String) {
        self.nameLabel = nameLabel
        self.amountLabel = amountLabel
        self.remainingLabel = remainingLabel
    }

    var body: some View {
        HStack{
            Text(nameLabel).padding(.leading)
            Spacer()
            VStack(alignment: .trailing){
                Text(Double(amountLabel)?.formatted(.currency(code: "USD")) ?? "")
                Text("Remaining $\(remainingLabel)")
                .opacity(0.5)
                .font(.caption)
            }
            .padding(.trailing)
        }
    }
}

#Preview {
    BudgetCategoryTableViewCell(nameLabel: "Budget", amountLabel: "200", remainingLabel: "150")
}
