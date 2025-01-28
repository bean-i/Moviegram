//
//  SearchViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import UIKit

final class SearchViewController: BaseViewController<SearchView> {
    
    var searchMovies: [Movie] = []
    
    var currentKeyword = ""
    var currentPage = 1
    var totalPage = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 얘 나중에 다른 데로 옮겨야 될 수도..
        mainView.searchBar.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "영화 검색"
        
        mainView.searchTableView.delegate = self
        mainView.searchTableView.dataSource = self
        mainView.searchTableView.prefetchDataSource = self
        mainView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        mainView.searchBar.delegate = self
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        
        guard let text = mainView.searchBar.text else {
            print("검색 오류")
            return
        }
        
        // 네트워크 통신
        NetworkManager.shared.getMovieData(api: .MovieSearch(keyword: text, page: String(currentPage)),
                                           type: MovieSearchData.self) { value in
//            print(value)
            // 검색 결과가 없으면
            if value.totalResults == 0 {
                print("검색 결과가 없어용")
            } else {// 검색 결과가 있으면 테이블뷰 보여줭~
                self.currentKeyword = text
                self.currentPage = value.page
                self.totalPage = value.totalPages
                self.searchMovies = value.results
                self.mainView.searchTableView.reloadData()
            }
            
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMovies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        
        cell.delegate = self
        cell.tag = searchMovies[indexPath.row].id
        cell.configureData(data: searchMovies[indexPath.row])
        return cell
    }
    
}

extension SearchViewController: LikeButtonDelegate {
    
    func likeButtonTapped(id: Int, isSelected: Bool) {
        print(#function, id, isSelected)
        if isSelected { // true이면 저장
            UserInfo.shared.storedMovies = [id]
        } else { // false이면 삭제
            if let index = UserInfo.storedMovieList.firstIndex(of: id) {
                UserInfo.storedMovieList.remove(at: index)
                UserInfo.shared.storedMovies = Array(UserInfo.storedMovieList) // 새로운 집합으로 업데이트
            }
        }
    }
    
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.row == searchMovies.count - 2,
               currentPage < totalPage {
                currentPage += 1
                
                NetworkManager.shared.getMovieData(api: .MovieSearch(keyword: currentKeyword, page: String(currentPage)), type: MovieSearchData.self) { value in
                    self.searchMovies.append(contentsOf: value.results)
                    self.mainView.searchTableView.reloadData()
                }
            }
        }
    }
    
}
