//
//  AppleSignInManager.swift
//  Dding
//
//  Created by 이지은 on 11/11/24.
//

import AuthenticationServices
import UIKit
import FirebaseFirestore

class AppleSignInManager: NSObject {
    func requestSignInWithApple(completion: @escaping (Result<Void, Error>) -> Void) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        self.signInCompletion = completion
        authorizationController.performRequests()
    }
    
    private var signInCompletion: ((Result<Void, Error>) -> Void)?
    
    func saveUserInKeyChain(userIdentifier: String, email: String?, completion: @escaping (Bool) -> Void) {
        if let email = email {
            // 첫 로그인: 애플 로그인에서 제공된 이메일 저장
            KeychainManager.shared.saveUserKeychain(userIdentifier, email)
            completion(true)
        } else {
            // 재로그인: Firebase에서 이메일 가져오기
            fetchEmailFromFirebase(userIdentifier: userIdentifier) { existingEmail in
                let finalEmail = existingEmail ?? "nil"
                KeychainManager.shared.saveUserKeychain(userIdentifier, finalEmail)
                completion(true)
            }
        }
    }
    
    func fetchEmailFromFirebase(userIdentifier: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userIdentifier)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Firebase에서 이메일 가져오기 실패: \(error.localizedDescription)")
                completion(nil)
            } else if let document = document, document.exists {
                let email = document.data()?["email"] as? String
                completion(email)
            } else {
                print("유저 문서를 찾을 수 없습니다.")
                completion(nil)
            }
        }
    }
}

extension AppleSignInManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email
            saveUserInKeyChain(userIdentifier: userIdentifier, email: email) { success in
                if success {
                    self.signInCompletion?(.success(()))
                } else {
                    self.signInCompletion?(.failure(NSError(domain: "AppleSignInManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "키체인 저장 실패"])))
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        signInCompletion?(.failure(error))
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
