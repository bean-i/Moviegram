//
//  UIStackView+.swift
//  Moviegram
//
//  Created by 이빈 on 1/30/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
