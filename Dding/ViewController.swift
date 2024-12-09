//
//  ViewController.swift
//  Dding
//
//  Created by 이지은 on 9/30/24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UIViewController {
    func enableKeyboardDismissOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(title: String, message: String, onDismiss: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            onDismiss?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}
//
//func showAlert(title: String, message: String) {
//    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
//        self?.dismiss(animated: true)
//    }))
//    present(alert, animated: true)
//}
