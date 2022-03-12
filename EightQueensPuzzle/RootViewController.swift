//
//  ViewController.swift
//  EightQueensPuzzle
//
//  Created by Андрей on 10.03.2022.
//

import UIKit
import Foundation
import SATSolver
import MiniSat
import Algorithms

class RootViewController: UIViewController {
    enum Constants {
        static let basicChessboardSize = 4
    }
    
    private let chessboardFactory = ChessBoardTemplateFactory()
    private let puzzleSolver = NQueensPuzzleSolver()
    
    private var availableSizes : [Int] = Array(Constants.basicChessboardSize...40)
    private var numberOfQueens = Constants.basicChessboardSize

    private lazy var chessboard : UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        
        do {
            try view.image = chessboardFactory.generateImage(of: numberOfQueens)
        } catch {
            view.image = UIImage(named: "checkerboardCageWhite.svg")
        }
        
        
        return view
    }()
    
    private var sizePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sizePicker.dataSource = self
        sizePicker.delegate = self
        
        view.backgroundColor = .systemBackground
        view.addSubviews(chessboard, sizePicker)
        
        puzzleSolver.solveUsingMinisat(for: numberOfQueens) { positions, oldAmount in
            self.chessboard.image = self.chessboardFactory.drawQueens(
                positions: positions,
                chessboard: self.chessboard.image!,
                size: self.numberOfQueens
            )
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutChessboard()
        layoutPicker()
    }
    
    private func layoutPicker() {
        sizePicker.frame = CGRect(
            x: 0, y: view.frame.height * 0.66,
            width: view.frame.width, height: view.frame.height * 0.34
        )
    }

    private func layoutChessboard() {
        let chessboardSize = view.frame.width / 1.5
        chessboard.frame = CGRect(
            x: 0, y: 0,
            width: chessboardSize, height: chessboardSize
        )
        
        chessboard.center = view.center
    }
}

extension RootViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableSizes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(availableSizes[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberOfQueens = availableSizes[row]
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.puzzleSolver.solveUsingMinisat(for: self.numberOfQueens) { positions, oldAmount in
                var temporaryBoard : UIImage
                do {
                    try temporaryBoard = self.chessboardFactory.generateImage(of: self.numberOfQueens)
                    
                    temporaryBoard = self.chessboardFactory.drawQueens(
                        positions: positions,
                        chessboard: temporaryBoard,
                        size: oldAmount
                    )
                } catch {
                    temporaryBoard = UIImage(named: "checkerboardCageWhite.svg")!
                }
    
                // Check if requested number of queens is still relevant
                if(self.numberOfQueens == oldAmount) {
                    DispatchQueue.main.async {
                        self.chessboard.image = temporaryBoard
                    }
                }
            }
        }
    }
}

