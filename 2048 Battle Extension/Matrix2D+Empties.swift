//
//  Matrix2D+Empties.swift
//  2048 Battle
//
//  Created by James Jackson on 6/25/17.
//  Copyright © 2017 James Jackson. All rights reserved.
//

import Foundation

extension Matrix2D {
    
    // Returns an array of indices (column, row) of all free positions
    func getEmpties(_ isEmpty: (T?) -> Bool) -> [(Int, Int)] {
        var arr = [(Int, Int)]()
        for col in 0 ..< rows {
            for row in 0 ..< columns {
                if isEmpty(self[col, row]) {
                    arr.append((col, row))
                }
            }
        }
        return arr
    }
    
}
