//
//  UIButton+.swift
//  Moviegram
//
//  Created by 이빈 on 1/31/25.
//

import UIKit

extension UIButton.Configuration {
    
    static func customStyle(title: String?) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = .Font.medium.of(weight: .bold)
        if let title {
            config.attributedTitle = AttributedString(title, attributes: titleContainer)
        }
        config.baseForegroundColor = .point
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return config
    }
    
}
