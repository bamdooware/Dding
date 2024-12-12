//
//  AddItemViewModel.swift
//  Dding
//
//  Created by 이지은 on 12/4/24.
//

import Foundation

class AddNewItemViewModel {
    var didFailWithError: ((Error) -> Void)?
    private let firebaseService: FirebaseService
    
    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }

    func saveRoutineItem(for userId: String, routine: RoutineItem, completion: @escaping (Result<Void, Error>) -> Void) {
        firebaseService.saveRoutineItem(userId: userId, routine: routine) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
