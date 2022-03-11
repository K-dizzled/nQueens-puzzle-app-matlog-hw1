//
//  NQueensConstraint.swift
//  EightQueensPuzzle
//
//  Created by Андрей on 11.03.2022.
//

import Foundation
import SwiftCSP

final class NQueensConstraint: ListConstraint <Int, Int> {
    var numberOfQueens : Int = 0
    
    init(variables: [Int], N: Int) {
        super.init(variables: variables)
        
        numberOfQueens = N
    }
    
    override func isSatisfied(assignment: Dictionary<Int, Int>) -> Bool {
        for q in assignment.values {
            // Check one per column
            for i in (q - (q % numberOfQueens))..<q {
                if assignment.values.firstIndex(of: i) != nil {
                    return false
                }
            }
            var cc = q + (numberOfQueens - (q % numberOfQueens))
            if numberOfQueens % 2 != 0 {
                cc += 1
            }
            for i in (q + 1)..<cc {
                if assignment.values.firstIndex(of: i) != nil {
                    return false
                }
            }
            
            // Check one per diagonal
            for i in stride(from: (q - numberOfQueens - 1), through: 0, by: -(numberOfQueens+1)) {
                // diagonal up and back
                guard q % numberOfQueens > i % numberOfQueens else { break }
                if assignment.values.firstIndex(of: i) != nil {
                    return false
                }
            }
            for i in stride(from: (q - numberOfQueens + 1), through: 0, by: -(numberOfQueens - 1)) {
                // diagonal up and forward
                guard q % numberOfQueens < i % numberOfQueens else { break }
                if assignment.values.firstIndex(of: i) != nil {
                    return false
                }
            }
            for i in stride(from: (q + numberOfQueens - 1), to: numberOfQueens * numberOfQueens, by: numberOfQueens - 1) {
                // diagonal down and back
                guard i % numberOfQueens < q % numberOfQueens else { break }
                if assignment.values.firstIndex(of: i) != nil {
                    return false
                }
            }
            for i in stride(from: (q + numberOfQueens + 1), to: numberOfQueens * numberOfQueens, by: numberOfQueens + 1) {
                // diagonal down and forward
                guard q % numberOfQueens < i % numberOfQueens else { break }
                if assignment.values.firstIndex(of: i) != nil {
                    return false
                }
            }
        }
        
        return true
    }
}
