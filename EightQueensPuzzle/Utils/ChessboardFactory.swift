//
//  ChessboardFactory.swift
//  EightQueensPuzzle
//
//  Created by Андрей on 10.03.2022.
//

import Foundation
import UIKit
import MiniSat

class ChessBoardTemplateFactory {
    enum GeneratorError: Error {
        case unexpectedSizeError(desc: String)
    }
    
    func generateImage(of size: Int) throws -> UIImage {
        let start = DispatchTime.now()
        
        guard size > 3 else {
            throw GeneratorError.unexpectedSizeError(desc: "Requested chessboard size too low.")
        }
        
        let cageSize = CGFloat(123 / (size / 4))
        
        print(cageSize)
        
        let chessboardImageSize = CGSize(
            width: cageSize * CGFloat(size),
            height: cageSize * CGFloat(size)
        )
        
        UIGraphicsBeginImageContext(chessboardImageSize)
        let context = UIGraphicsGetCurrentContext()
        
        var colorFlag : Bool = false
        
        let height = size % 2 == 0 ? size - 1 : size
        for i in 0...size {
            for j in 0...height {
                let cageArea = CGRect(
                    x: cageSize * CGFloat(i), y: cageSize * CGFloat(j),
                    width: cageSize, height: cageSize
                )
                if !colorFlag {
                    context?.setLineWidth(0.0)
                    context?.setFillColor(UIColor(
                        red: 0.94, green: 0.84,
                        blue: 0.72, alpha: 1.00).cgColor
                    )
                    context?.fill(cageArea)
                } else {
                    context?.setLineWidth(0.0)
                    context?.setFillColor(UIColor(
                        red: 0.44, green: 0.30,
                        blue: 0.21, alpha: 1.00).cgColor
                    )
                    context?.fill(cageArea)
                }
                colorFlag = !colorFlag
            }
            
            colorFlag = !colorFlag
        }

        let chessboard : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        
        UIGraphicsEndImageContext()
        
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print("Time to generate board: \(timeInterval) seconds")
        
        return chessboard
    }
    
    func drawQueens(positions: MiniSat, chessboard: UIImage, size: Int) -> UIImage {
        let start = DispatchTime.now()
        
        let queenImage = UIImage(named: "queenImage.svg")!
        
        UIGraphicsBeginImageContext(chessboard.size)
        
        let boardArea = CGRect(
            x: 0, y: 0,
            width: chessboard.size.width,
            height: chessboard.size.height
        )
        chessboard.draw(in: boardArea)
        
        let cageSize = Int(chessboard.size.width) / size
        for i in 0..<size * size {
            if (positions.value(of: Int32(i + 1)) == .positive) {
                let cageArea = CGRect(
                    x: cageSize * Int(i / size), y: cageSize * Int(i % size),
                    width: cageSize, height: cageSize
                )
                
                queenImage.draw(in: cageArea)
            }
        }
        
        let chessboardWithQueens : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print("Time to draw queens: \(timeInterval) seconds")
        
        return chessboardWithQueens
    }
}
