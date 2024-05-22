//
//  Extensions.swift
//  BudgetApp
//
//  Created by Raghavendra Mirajkar on 20/05/24.
//

import Foundation

extension String {
    var isNumeric : Bool {
        Double(self) != nil
    }
    
    func isGreaterThan(_ value: Double) -> Bool {
        guard self.isNumeric else {
            return false
        }
        
        return Double(self)! > value
    }
}

extension NSSet {
    
    func toArray<T>() -> [T] {
        let array = self.map { $0 as! T}
        return array
    }
}
