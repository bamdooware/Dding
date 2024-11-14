//
//  AppleSignInManager.swift
//  Dding
//
//  Created by 이지은 on 11/11/24.
//

import AuthenticationServices
import UIKit
import KeychainSwift

protocol AppleSignInManagerDelegate: NSObject {
    func didCompleteSignInSuccessfully()
    func didFailSignIn(error: Error)
}

class AppleSignInManager: NSObject {
    weak var delegate: AppleSignInManagerDelegate?
    let keychain = KeychainSwift()
    
    func requestSignInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func saveUserInKeyChain(userIdentifier: String, email: String?) {
        keychain.set(userIdentifier, forKey: "userIdentifier")

        if let storedEmail = keychain.get("userEmail") {
            print("기존 이메일 존재: \(storedEmail)")
        } else if let newEmail = email {
            keychain.set(newEmail, forKey: "userEmail")
            print("새로운 이메일 저장: \(newEmail)")
        } else {
            print("이메일 정보 없음")
        }
    }
}

extension AppleSignInManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email

            saveUserInKeyChain(userIdentifier: userIdentifier, email: email)
            delegate?.didCompleteSignInSuccessfully()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        delegate?.didFailSignIn(error: error)
    }
}

extension AppleSignInManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first { $0.isKeyWindow } ?? UIWindow()

    }
}
