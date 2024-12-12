//
//  User.swift
//  Dding
//
//  Created by 이지은 on 11/23/24.
//

import Foundation
import FirebaseFirestore

struct UserData {
    let id: String
    let name: String
    let email: String
    let isOnboardingComplete: Bool
    let registrationDate: Date

    // MARK: - 초기화 메서드
    init(
        id: String = UUID().uuidString,
        name: String,
        email: String,
        isOnboardingComplete: Bool = false,
        registrationDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.isOnboardingComplete = isOnboardingComplete
        self.registrationDate = registrationDate
    }

    init?(from dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let email = dictionary["email"] as? String,
            let isOnboardingComplete = dictionary["isOnboardingComplete"] as? Bool,
            let registrationDate = (dictionary["registrationDate"] as? Timestamp)?.dateValue()
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.email = email
        self.isOnboardingComplete = isOnboardingComplete
        self.registrationDate = registrationDate
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "email": email,
            "isOnboardingComplete": isOnboardingComplete,
            "registrationDate": Timestamp(date: registrationDate)
        ]
    }
}
