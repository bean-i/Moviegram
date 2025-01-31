//
//  UIViewController+.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit

extension UIViewController {
    
    // MARK: - Alert
    func showAlert(title: String, message: String, button: String = "확인", cancel: Bool, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: button, style: .default) { action in
            completionHandler()
        }
        alert.addAction(button)
        
        if cancel {
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(cancel)
        }
        self.present(alert, animated: true)
    }
    
    func dismissKeyboardWhenTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - 화면 전환 로직
//    enum TransitionStyle {
//        case presentNavigation // 네비게이션이 임베드 된 present
//        case push
//    }
//    
//    func transition<T: UIViewController>(viewController: T.Type,
//                                         storyboard: String,
//                                         style: TransitionStyle) {
//        
////        let sb = UIStoryboard(name: storyboard, bundle: nil)
////        guard let vc = sb.instantiateViewController(withIdentifier: String(describing: viewController)) as? T else {
////            showAlert(title: "요청하신 화면이 없습니다.", message: "요청하신 화면이 없습니다. 다시 접근해 주세요.", cancel: false) {
////                print("화면 전환 오류: 확인")
////            }
////            return
////        }
//        
//        
//        switch style {
//        case .presentNavigation:
//            let nav = UINavigationController(rootViewController: viewController.init())
//            present(nav, animated: true)
//        case .push:
//            navigationController?.pushViewController(viewController.init(), animated: true)
//        }
//    }
    
    
}
