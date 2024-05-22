//
//  Budgetcategory+CoreData.swift
//  BudgetApp
//
//  Created by Raghavendra Mirajkar on 22/05/24.
//

import Foundation
import CoreData

@objc(BudgetCateogry)
public class BudgetCateogry : NSManagedObject {
    var transactionTotal : Double {
        let transactionsArray: [Transaction] = transaction?.toArray() ?? []
        return transactionsArray.reduce(0, { partialResult, transaction in
            partialResult + transaction.amount
        })
    }
    
    var remainingAmount : Double {
        amount - transactionTotal
    }
}
