//
//  BaseViewController.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var spinner = UIActivityIndicatorView()
    let alertService = AlertService()
    lazy var isLoading: Bool = false
    private var enableHideKeyBoardWhenTouchInScreen: Bool = true
    var isEnableHideKeyBoardWhenTouchInScreen: Bool {
        get {
            return self.enableHideKeyBoardWhenTouchInScreen ? true : false
        }
        
        set {
            self.enableHideKeyBoardWhenTouchInScreen = newValue
            if self.enableHideKeyBoardWhenTouchInScreen {
                let touchOnScreen = UITapGestureRecognizer(target: self, action: #selector(self.touchOnScreen))
                touchOnScreen.delegate = self
                touchOnScreen.cancelsTouchesInView = false
                view.addGestureRecognizer(touchOnScreen)
            }
        }
    }
    
    @objc func touchOnScreen() {
        view.endEditing(true)
    }
    
    func setSpinner() {
        if #available(iOS 13.0, *) {
            spinner.style = .large
        } else {
            spinner.style = .whiteLarge
        }
//        spinner.style = .large
        
        spinner.color = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func showLoading() {
        setSpinner()
        spinner.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        spinner.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    func showAlert(type: AlertType, message: String, close: @escaping () -> Void) -> Void {
        let vc = alertService.showAlert(type: type, message: message, close: close)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false, completion: nil)
    }
    
    func showAlertWithConfirm(type: AlertType, message: String, cancel: @escaping () -> Void, ok: @escaping () -> Void) -> Void {
        let vc = alertService.showAlertWithConfirm(type: type, message: message, cancel: cancel, ok: ok)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false, completion: nil)
    }
    
    //login lai
//    func reLogin(resultcode: String, action: @escaping() -> ()) {
//        guard resultcode == "MS-0004" else {
//            return
//        }
//        self.showAlert(type: .notice, message: "Phiên đăng nhập của bạn đã hết hạn.\nVui lòng đăng nhập", close: {
//            let vc = Storyboard.Main.reLoginVC()
//            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            vc.actionReLogin = action
//            self.present(vc, animated: true, completion: nil)
//        })
//    }
}


