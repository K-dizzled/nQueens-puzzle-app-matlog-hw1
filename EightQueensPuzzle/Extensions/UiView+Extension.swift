//
//  UiView+Extension.swift
//  EightQueensPuzzle
//
//  Created by Андрей on 11.03.2022.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView ...) {
        views.forEach { (view) in
            self.addSubview(view)
        }
    }
}
