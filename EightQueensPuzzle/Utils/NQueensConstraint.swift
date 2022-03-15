//
//  NQueensConstraint.swift
//  EightQueensPuzzle
//
//  Created by Андрей on 11.03.2022.
//

import Foundation
import MiniSat

class NQueensPuzzleSolver {
    func solveUsingMinisat(for queensNum: Int, completion: @escaping (MiniSat, Int) -> Void) {
        let start = DispatchTime.now()
        let minisat = MiniSat()
        
        var variables : [Int32] = []
        for _ in 0..<queensNum * queensNum {
            let v = minisat.new()
            variables.append(v)
        }

        // At least one per row
        for i in 0..<queensNum {
            var clause : [Int32] = []
            for j in stride(from: i * queensNum, through: (i+1) * queensNum - 1, by: 1) {
                clause.append(variables[j])
            }

            minisat.add(clause: clause)
        }
        
        // Exactly one per row
        for i in 0..<queensNum {
            var clause : [Int32] = []
            for j in stride(from: i * queensNum, through: (i+1) * queensNum - 1, by: 1) {
                clause.append(variables[j])
            }
            Array(clause.combinations(ofCount: 2)).forEach { pair in
                var temp = pair
                for i in temp.indices { temp[i].negate() }
                minisat.add(clause: temp)
            }
        }
        
        // Exactly one per column
        for i in 0..<queensNum {
            var clause : [Int32] = []
            for j in stride(from: i, through: queensNum*queensNum - 1, by: queensNum) {
                clause.append(variables[j])
            }
            
            Array(clause.combinations(ofCount: 2)).forEach { pair in
                var temp = pair
                for i in temp.indices { temp[i].negate() }
                minisat.add(clause: temp)
            }
        }
        
        // Exactly one per secondary diagonal
        for i in 1..<queensNum {
            var clause : [Int32] = []
            var j = i * queensNum
            while j >= queensNum {
                clause.append(variables[j])
                j -= (queensNum - 1)
            }
            clause.append(variables[j])
            
            Array(clause.combinations(ofCount: 2)).forEach { pair in
                var temp = pair
                for i in temp.indices { temp[i].negate() }
                minisat.add(clause: temp)
            }
        }
        
        for i in (queensNum * (queensNum - 1) + 1)..<(queensNum * queensNum - 1) {
            var clause : [Int32] = []
            var j = i
            while(j % queensNum != queensNum - 1 && j > 0) {
                clause.append(variables[j])
                j -= (queensNum - 1)
            }
            clause.append(variables[j])

            Array(clause.combinations(ofCount: 2)).forEach { pair in
                var temp = pair
                for i in temp.indices { temp[i].negate() }
                minisat.add(clause: temp)
            }
        }
        
        // Exactly one per main diagonal
        for i in 1..<queensNum - 1 {
            var clause : [Int32] = []
            var j = i * queensNum
            while j <= queensNum * queensNum {
                clause.append(variables[j])
                j += (queensNum + 1)
            }

            Array(clause.combinations(ofCount: 2)).forEach { pair in
                var temp = pair
                for i in temp.indices { temp[i].negate() }
                minisat.add(clause: temp)
            }
        }
        
        for i in 0..<queensNum - 1 {
            var clause : [Int32] = []
            var j = i
            while(j % queensNum != queensNum - 1) {
                clause.append(variables[j])
                j += (queensNum + 1)
            }
            clause.append(variables[j])

            Array(clause.combinations(ofCount: 2)).forEach { pair in
                var temp = pair
                for i in temp.indices { temp[i].negate() }
                minisat.add(clause: temp)
            }
        }

        let _ = minisat.solve()
        
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print("Time to solve using SAT: \(timeInterval) seconds")
        
        completion(minisat, queensNum)
    }

}
