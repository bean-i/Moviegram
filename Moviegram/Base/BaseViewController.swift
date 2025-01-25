//
//  BaseViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit

class BaseViewController<T: UIView>: UIViewController {
    
    var mainView: T {
        return view as! T
    }
    
    override func loadView() {
        self.view = T(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        configureDelegate()
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() {
        // 모든 뷰컨트롤러에서 백버튼 타이틀 없애기
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    func configureDelegate() { }
    
}
