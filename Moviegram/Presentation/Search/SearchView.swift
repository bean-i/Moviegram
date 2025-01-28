//
//  SearchView.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import UIKit
import SnapKit

final class SearchView: BaseView {

    let searchBar = UISearchBar()
    let searchTableView = UITableView()
    
    override func configureHierarchy() {
        addSubViews(
            searchBar,
            searchTableView
        )
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
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
        searchBar.searchTextField.backgroundColor = .customDarkGray
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .customGray
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "영화를 검색해보세요.", attributes: [.foregroundColor : UIColor.customGray])
        
        searchTableView.backgroundColor = .black
        searchTableView.separatorColor = .customGray
        searchTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}
