//
//  SearchViewModel.swift
//  Moviegram
//
//  Created by 이빈 on 2/11/25.
//

import Foundation

final class SearchViewModel: BaseViewModel {
    
    struct Input {
        // 검색 버튼 탭
        let searchButtonTapped: Observable<String?> = Observable(nil)
        
        // 페이지네이션
        let prefetchData: Observable<[IndexPath]> = Observable([])
        
        // 최근 검색어 영역 탭
        let recentKeywordTapped: Observable<String> = Observable("")
    }
    
    struct Output {
        // viewWillAppear
        let viewWillAppearTrigger: Observable<Void> = Observable(())
        
        // viewDidLoad
        let viewDidLoadTrigger: Observable<Void> = Observable(())
        
        // 키보드 내리기
        let resignKeyboard: Observable<Void> = Observable(())
        
        // 상단 스크롤
        let scrollToTop: Observable<Void> = Observable(())
        
        // 검색 결과 데이터
        let searchMovies: Observable<[MovieModel]> = Observable([])
        
        // 검색 결과 개수에 따른 UI
        let searchDataView: Observable<Bool> = Observable(false)
        
        // alert
        let configureError: Observable<StatusCode?> = Observable(nil)
        
        // 영화 상세 탭 - 화면 전환
        let movieTapped: Observable<Int?> = Observable(nil)
        
        // 최근 검색어 영역에서 들어온 경우, 서치바에 텍스트 표시하기
        let searchBarText: Observable<Void> = Observable(())
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    var currentKeyword = ""
    var currentPage = 1
    var totalPage = 1
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        // 검색 버튼 탭
        input.searchButtonTapped.lazyBind { [weak self] _ in
            self?.search()
        }
        
        // 최근 검색어 영역 탭
        input.recentKeywordTapped.lazyBind { [weak self] _ in
            self?.recentKeywordSearch()
        }
        
        // 페이지네이션
        input.prefetchData.lazyBind { [weak self] _ in
            self?.pagination()
        }
    }
    
    private func search() {
        guard let text = input.searchButtonTapped.value else {
            print("검색 오류")
            return
        }
        
        // 검색 후 동작 (키보드 내리기, page 초기화)
        // 키보드 내리기 -> 뷰컨
        // page 초기화 -> 뷰모델
        output.resignKeyboard.value = ()
        initData()
        
        // 같은 검색어 입력 -> 스크롤 상단으로 올리고(뷰컨)
        // 새로운 검색어 입력 -> 최근 검색어에 저장, 최신 키워드 갱신, 통신 (뷰모델)
        if text == currentKeyword {
            output.scrollToTop.value = ()
        } else {
            UserInfo.shared.recentKeywords = [text]
            currentKeyword = text
            fetchData()
        }
        
    }
    
    private func recentKeywordSearch() {
        let text = input.recentKeywordTapped.value
        currentKeyword = text
        output.searchBarText.value = ()
        fetchData()
    }
    
    private func fetchData() {
        NetworkManager.shared.getMovieData(api: .MovieSearch(keyword: currentKeyword, page: String(currentPage)), type: MovieSearchModel.self) { [weak self] value in
            self?.output.resignKeyboard.value = () // 키보드 내리기
            if value.totalResults == 0 {
                self?.output.searchDataView.value = false
            } else {
                self?.output.searchDataView.value = true
                self?.output.searchMovies.value = value.results
                self?.currentPage = value.page
                self?.totalPage = value.totalPages
                
                if self?.currentPage == 1 {
                    self?.output.scrollToTop.value = ()
                }
            }
            
        } failHandler: { [weak self] error in
            self?.output.configureError.value = error
        }

    }
    
    private func pagination() {
        
        let indexPaths = input.prefetchData.value
        
        for indexPath in indexPaths {
            if indexPath.row == output.searchMovies.value.count - 2,
               currentPage < totalPage {
                currentPage += 1
                fetchPaginationData()
            }
        }
        
    }
    
    private func fetchPaginationData() {
        NetworkManager.shared.getMovieData(api: .MovieSearch(keyword: currentKeyword, page: String(currentPage)), type: MovieSearchModel.self) { [weak self] value in
            self?.output.searchMovies.value.append(contentsOf: value.results)
        } failHandler: { [weak self] error in
            self?.currentPage -= 1
            self?.output.configureError.value = error
        }
    }
    
    private func initData() {
        currentPage = 1
        totalPage = 1
    }
    
}
