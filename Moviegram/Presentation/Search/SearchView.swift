//
//  SearchView.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import UIKit
import SnapKit

// MARK: - 검색 View
final class SearchView: BaseView {

    // MARK: - Properties
    let searchBar = UISearchBar()
    let searchResultLabel = UILabel()
    let searchTableView = UITableView()
    
    // MARK: - Configure UI
    override func configureHierarchy() {
        addSubViews(
            searchBar,
            searchResultLabel,
            searchTableView
        )
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        searchResultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        searchBar.isUserInteractionEnabled = true
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.searchTextField.backgroundColor = .customDarkGray
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .customGray
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "영화를 검색해보세요.", attributes: [.foregroundColor : UIColor.customGray])
        
        searchResultLabel.text = "원하는 검색결과를 찾지 못했습니다"
        searchResultLabel.font = .Font.medium.of(weight: .medium)
        searchResultLabel.textColor = .customLightGray
        searchResultLabel.isHidden = true
        
        searchTableView.backgroundColor = .black
        searchTableView.separatorColor = .customGray
        searchTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        searchTableView.isHidden = true
        searchTableView.keyboardDismissMode = .onDrag
        searchTableView.showsVerticalScrollIndicator = true
        searchTableView.indicatorStyle = .white
    }
    
}
