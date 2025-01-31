//
//  SettingTableViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/29/25.
//

import UIKit
import SnapKit

// MARK: - 설정 TableViewCell
final class SettingTableViewCell: BaseTableViewCell {

    // MARK: - Properties
    static let identifier = "SettingTableViewCell"
    private let settingOptionLabel = UILabel()
    
    // MARK: - Configure UI
    override func configureHierarchy() {
        addSubview(settingOptionLabel)
    }
    
    override func configureLayout() {
        settingOptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureView() {
        backgroundColor = .black
        selectionStyle = .none
        
        settingOptionLabel.font = .Font.medium.of(weight: .medium)
        settingOptionLabel.textColor = .white
        settingOptionLabel.textAlignment = .left
    }
    
    // MARK: - Configure Data
    func configureData(text: String) {
        settingOptionLabel.text = text
    }
    
}
