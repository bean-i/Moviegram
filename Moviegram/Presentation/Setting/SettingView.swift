//
//  SettingView.swift
//  Moviegram
//
//  Created by 이빈 on 1/28/25.
//

import UIKit
import SnapKit

// MARK: - 설정 View
final class SettingView: BaseView {
    
    // MARK: - Properties
    let profileView = ProfileView()
    let settingTableView = UITableView()
    
    // MARK: - Configure UI
    override func configureHierarchy() {
        addSubViews(
            profileView,
            settingTableView
        )
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        settingTableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        settingTableView.backgroundColor = .black
        settingTableView.separatorColor = .customGray
        settingTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}
