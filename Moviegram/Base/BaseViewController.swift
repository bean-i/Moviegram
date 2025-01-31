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
        configureGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .black
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
    
    func configureDelegate() { }
    
    func configureGesture() { }
    
}
