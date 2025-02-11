//
//  MainViewModel.swift
//  Moviegram
//
//  Created by 이빈 on 2/11/25.
//

import Foundation

final class MainViewModel: BaseViewModel {
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void> = Observable(())
        
        // 최근 검색 키워드 (최근 검색어 있는지 체크)
        let recentKeywords: Observable<[String]> = Observable([])
        
        // 최근 검색어 - 전체 삭제 버튼 탭
        let deleteAllKeywordTapped: Observable<Void> = Observable(())
        
        // 최근 검색어 - 한개 삭제
        let deleteKeywordTapped: Observable<Int?> = Observable(nil)
    }
    
    struct Output {
        // viewWillAppear
        let viewWillAppearTrigger: Observable<Void> = Observable(())
        
        // 오늘의 영화 데이터
        let todayMovies: Observable<[MovieModel]> = Observable([])
        
        // alert
        let configureError: Observable<StatusCode?> = Observable(nil)
        
        // 최근 검색어 개수에 따라 컬렉션 뷰 또는 레이블 보여주기
        let recentKeywordView: Observable<Bool> = Observable(false)
        
        // 네비게이션바 - 검색 버튼 탭
        let searchTapped: Observable<Void> = Observable(())
        
        // 최근 검색 키워드 영역 - 버튼 탭
        let recentKeywordTapped: Observable<Int?> = Observable(nil)
        
        // 프로필뷰 탭 - 화면 전환
        let profileViewTapped: Observable<Void> = Observable(())
        
        // 키워드 테이블 뷰 업데이트
        let recentKeywordsChanged: Observable<Void> = Observable(())
        
        // 영화 상세 탭 - 화면 전환
        let movieTapped: Observable<Int?> = Observable(nil)
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    
    func transform() {
        // viewDidLoad 시점에
        input.viewDidLoadTrigger.lazyBind { [weak self] _ in
            self?.fetchData()
        }
        
        // 최근 검색어 데이터 업데이트
        input.recentKeywords.bind { [weak self] _ in
            self?.updateRecentKeywordView()
            // 테이블뷰 업데이트
            self?.output.recentKeywordsChanged.value = ()
        }
        
        // 최근 검색어 전체 삭제
        input.deleteAllKeywordTapped.lazyBind { [weak self] _ in
            self?.updateRecentKeywordView()
        }
        
        // 최근 검색어 하나 삭제
        input.deleteKeywordTapped.lazyBind { [weak self] _ in
            self?.deleteOneKeyword()
        }
    }
    
    private func fetchData() {
        // 오늘의 영화 데이터 불러오기
        NetworkManager.shared.getMovieData(api: .TodayMovie,
                                           type: TodayMovieModel.self) { [weak self] value in
            self?.output.todayMovies.value = value.results
        } failHandler: { [weak self] statusCode in
            self?.output.configureError.value = statusCode
        }
    }
    
    // 최근 검색어 개수에 따라, 컬렉션뷰 or 레이블 보여주기
    private func updateRecentKeywordView() {
        if input.recentKeywords.value.count > 0 {
            output.recentKeywordView.value = false
        } else {
            output.recentKeywordView.value = true
        }
    }
    
    // "전체 삭제" 버튼 터치 시, userdefaults에 저장 된 정보 삭제
    private func deleteAllKeywords() {
        UserDefaults.standard.removeObject(forKey: UserInfoKey.recentKeywordsKey.rawValue)
        input.recentKeywords.value = []
    }
    
    // x 버튼 터치 시, 키워드 하나 삭제
    private func deleteOneKeyword() {
        guard let index = input.deleteKeywordTapped.value else {
            print("index 오류")
            return
        }
        var keywords = input.recentKeywords.value
        keywords.remove(at: index)
        UserDefaults.standard.set(keywords, forKey: UserInfoKey.recentKeywordsKey.rawValue)
        input.recentKeywords.value = UserInfo.shared.recentKeywords ?? []
    }
    
    func getTextWidth(index: Int) -> CGFloat {
        let text = input.recentKeywords.value[index]
        let textSize = text.calculateTextWidth(font: .Font.medium.of(weight: .medium))
        return textSize
    }
    
}
