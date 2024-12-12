//
//  OnboardingViewModel.swift
//  Dding
//
//  Created by 이지은 on 11/26/24.
//

import Foundation

protocol OnboardingViewModelDelegate: AnyObject {
    func didCompleteSignInSuccessfully()
    func didFailSignIn(error: Error)
}

class OnboardingViewModel {
    private let firebaseService = FirebaseService.shared
    private let appleSignInManager = AppleSignInManager()
    private let keychain = KeychainManager.shared
    
    func handleAppleLogin(completion: @escaping (Result<Void, Error>) -> Void) {
        appleSignInManager.requestSignInWithApple { result in
            switch result {
            case .success:
                self.saveUserToFirebase(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func saveUserToFirebase(completion: @escaping (Result<Void, Error>) -> Void) {
        guard
            let userId = keychain.getUserIdentifier(),
            let userEmail = keychain.getUserEmail()
        else {
            let error = NSError(domain: "Onboarding", code: 1, userInfo: [NSLocalizedDescriptionKey: "Keychain에서 사용자 정보를 찾을 수 없습니다."])
            completion(.failure(error))
            return
        }
        
        let userData = UserData(
            id: userId,
            name: "DefaultName",
            email: userEmail,
            isOnboardingComplete: false,
            registrationDate: Date()
        )
        
        firebaseService.saveUserData(user: userData) { error in
            if let error = error {
                print("유저 데이터 저장 실패: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("유저 데이터 저장 성공")
                completion(.success(()))
            }
        }
    }
}
