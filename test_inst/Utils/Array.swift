//
//  Array.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import Foundation

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result: [Element] = []
        for element in self {
            if !result.contains(element) {
                result.append(element)
            }
        }
        return result
    }
}
