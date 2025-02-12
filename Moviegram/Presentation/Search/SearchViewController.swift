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
    let viewModel = SearchViewModel()
    
    // MARK: - 생명주기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.output.viewWillAppearTrigger.value = ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.output.viewDidLoadTrigger.value = ()
    }
    
    deinit {
        print("SearchViewController Deinit")
    }

    // MARK: - Configure
    override func bindData() {
        // viewWillAppear
        viewModel.output.viewWillAppearTrigger.lazyBind { [weak self] _ in
            // 좋아요 업데이트
            self?.mainView.searchTableView.reloadData()
        }
        
        // viewDidLoad
        viewModel.output.viewDidLoadTrigger.lazyBind { [weak self] _ in
            self?.title = "영화 검색"
            self?.mainView.searchBar.becomeFirstResponder()
            self?.dismissKeyboardWhenTapped()
        }
        
        // 키보드 내리기
        viewModel.output.resignKeyboard.bind { [weak self] _ in
            self?.mainView.searchBar.resignFirstResponder()
        }
        
        // 상단 스크롤
        viewModel.output.scrollToTop.lazyBind { [weak self] _ in
            self?.mainView.searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        // 검색 결과 데이터
        viewModel.output.searchMovies.lazyBind { [weak self] _ in
            self?.mainView.searchTableView.reloadData()
        }
        
        // 검색 결과 개수에 따른 UI
        viewModel.output.searchDataView.lazyBind { [weak self] bool in
            self?.mainView.searchResultLabel.isHidden = bool
            self?.mainView.searchTableView.isHidden = !bool
        }
        
        // alert (통신 실패 -> 오류 alert)
        viewModel.output.configureError.lazyBind { [weak self] error in
            guard let error else {
                print("error nil")
                return
            }
            self?.showErrorAlert(error: error)
        }
        
        // 영화 상세 화면 전환
        viewModel.output.movieTapped.lazyBind { [weak self] index in
            guard let self,
                  let index else {
                print("self, index 오류")
                return
            }
            let vc = MovieDetailViewController()
            vc.movieInfo = viewModel.output.searchMovies.value[index]
            navigationController?.pushViewController(vc, animated: true)
        }
        
        // 최근 검색어 영역에서 들어온 경우, 서치바에 텍스트 표시하기
        viewModel.output.searchBarText.bind { [weak self] _ in
            self?.mainView.searchBar.text = self?.viewModel.input.recentKeywordTapped.value ?? "검색어 없음"
        }
    }
    
    override func configureDelegate() {
        mainView.searchBar.delegate = self
        
        mainView.searchTableView.delegate = self
        mainView.searchTableView.dataSource = self
        mainView.searchTableView.prefetchDataSource = self
        mainView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
    }

}

// MARK: - Extension: SearchBar
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.searchButtonTapped.value = mainView.searchBar.text
    }
}

// MARK: - Extension: TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.searchMovies.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        cell.movieLikeButton.delegate = self
        cell.configureData(data: viewModel.output.searchMovies.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 영화 상세 화면
        viewModel.output.movieTapped.value = indexPath.item
    }
    
}

// MARK: - Extension: Prefetch
extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.input.prefetchData.value = indexPaths
    }
}
