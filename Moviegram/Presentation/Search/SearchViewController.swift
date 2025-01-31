//
//  SearchViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import UIKit

// MARK: - 검색 ViewController
final class SearchViewController: BaseViewController<SearchView> {
    
    // MARK: - Properties
    private var searchMovies: [Movie] = []
    
    var currentKeyword = ""
    private var currentPage = 1
    private var totalPage = 1
    
    // MARK: - 생명주기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 좋아요 업데이트
        mainView.searchTableView.reloadData()
    }

    // MARK: - Configure
    override func configureView() {
        title = "영화 검색"
    }
    
    override func configureDelegate() {
        mainView.searchBar.delegate = self
        
        mainView.searchTableView.delegate = self
        mainView.searchTableView.dataSource = self
        mainView.searchTableView.prefetchDataSource = self
        mainView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    override func configureGesture() {
        mainView.searchBar.becomeFirstResponder()
        dismissKeyboardWhenTapped()
    }
    
    // MARK: - Methods
    func getData() {
        NetworkManager.shared.getMovieData(api: .MovieSearch(keyword: currentKeyword, page: String(currentPage)),
                                           type: MovieSearchData.self) { value in
            // 검색 결과가 없으면
            if value.totalResults == 0 {
                self.mainView.searchResultLabel.isHidden = false
            } else {// 검색 결과가 있으면 테이블뷰 보여줭~
                self.mainView.searchTableView.isHidden = false
                self.currentPage = value.page
                self.totalPage = value.totalPages
                self.searchMovies = value.results
                self.mainView.searchTableView.reloadData()
                
                if self.currentPage == 1 {
                    self.mainView.searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            }
            
        }
    }
    
    private func initData() {
        currentPage = 1
        totalPage = 1
    }

}

// MARK: - Extension: SearchBar
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let text = mainView.searchBar.text else {
            print("검색 오류")
            return
        }
        // 검색 후, 키보드 내리기
        mainView.searchBar.resignFirstResponder()
        
        initData()
        
        // 바로 전과 같은 검색어를 입력했으면, 네트워크 통신X
        if text == currentKeyword {
            // 스크롤 상단으로 올려주기
            mainView.searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        } else {
            // userdefaults의 최근 검색어에 저장
            UserInfo.shared.recentKeywords = [text]
            
            currentKeyword = text
            // 네트워크 통신
            getData()
        }
        
        
    }
}

// MARK: - Extension: TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMovies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        
        cell.movieLikeButton.delegate = self
        cell.configureData(data: searchMovies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 영화 상세 화면
        let vc = MovieDetailViewController()
        vc.movieInfo = searchMovies[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Extension: Prefetch
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
