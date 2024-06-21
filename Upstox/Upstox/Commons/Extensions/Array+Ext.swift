//
//  Array+Ext.swift
//  Upstox
//
//  Created by Shreyash Shah on 23/05/24.
//

import Foundation

extension Array {
    func item(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
    mutating func replaceItem(at index: Int, with item: Element) {
        guard index >= 0 && index < count else { return }
        self[index] = item
    }
}
