//
//  FirebaseService.swift
//  Dding
//
//  Created by 이지은 on 11/23/24.
//

import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func saveUserData(user: UserData, completion: @escaping (Error?) -> Void) {
        let userData = user.toDictionary()
        db.collection("users").document(user.id).setData(userData) { error in
            if let error = error {
                print("유저 데이터 저장 실패: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            print("유저 데이터 저장 성공")
            
            self.initializeRoutines(userId: user.id) { routineError in
                if let routineError = routineError {
                    print("루틴 초기화 실패: \(routineError.localizedDescription)")
                } else {
                    print("루틴 초기화 성공")
                }
                completion(routineError)
            }
        }
    }
    
    func fetchUserData(userId: String, completion: @escaping (UserData?) -> Void) {
        db.collection("users").document(userId).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("유저 데이터 불러오기 실패: \(error?.localizedDescription ?? "")")
                completion(nil)
                return
            }
            
            if let user = UserData(from: data) {
                completion(user)
            } else {
                print("유저 데이터 파싱 실패")
                completion(nil)
            }
        }
    }
    
    func updateUserData(userId: String, updatedData: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("users").document(userId).updateData(updatedData) { error in
            if let error = error {
                print("유저 데이터 업데이트 실패: \(error.localizedDescription)")
            } else {
                print("유저 데이터 업데이트 성공")
            }
            completion(error)
        }
    }
    
    func deleteUserData(userId: String, completion: @escaping (Error?) -> Void) {
        let routinesCollection = db.collection("users").document(userId).collection("routines")
        
        routinesCollection.getDocuments { snapshot, error in
            if let error = error {
                print("루틴 불러오기 실패: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            let batch = self.db.batch()
            snapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }
            
            let userDocument = self.db.collection("users").document(userId)
            batch.deleteDocument(userDocument)
            
            batch.commit { error in
                if let error = error {
                    print("유저 데이터 삭제 실패: \(error.localizedDescription)")
                } else {
                    print("유저 데이터 삭제 성공")
                }
                completion(error)
            }
        }
    }
    
    func initializeRoutines(userId: String, completion: @escaping (Error?) -> Void) {
        let routinesCollection = db.collection("users").document(userId).collection("routines")
        
        routinesCollection.getDocuments { snapshot, error in
            if let error = error {
                print("하위 컬렉션 확인 실패: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            if snapshot?.isEmpty == true {
                print("루틴 하위 컬렉션 없음 - 초기화 진행")
                
                let sampleRoutine = [
                    RoutineItem(
                        id: UUID().uuidString,
                        title: "길게 눌러서 완료하기",
                        tag: .red,
                        repeatDays: [1, 2, 3, 4, 5, 6, 7],
                        routineTime: DateComponents(hour: 13, minute: 05),
                        isCompleted: false,
                        reminderTime: 10,
                        completionCheckTime: 10,
                        memo: "간단한 메모를 작성할 수 있습니다."
                    ),RoutineItem(
                        id: UUID().uuidString,
                        title: "왼쪽으로 밀어서 삭제하기 <--",
                        tag: .yellow,
                        repeatDays: [1, 2, 3, 4, 5, 6, 7],
                        routineTime: DateComponents(hour: 13, minute: 05),
                        isCompleted: false,
                        reminderTime: 10,
                        completionCheckTime: 10,
                        memo: "간단한 메모를 작성할 수 있습니다."
                    ),RoutineItem(
                        id: UUID().uuidString,
                        title: "--> 오른쪽으로 밀어서 고정하기",
                        tag: .blue,
                        repeatDays: [1, 2, 3, 4, 5, 6, 7],
                        routineTime: DateComponents(hour: 13, minute: 05),
                        isCompleted: false,
                        reminderTime: 10,
                        completionCheckTime: 10,
                        memo: "간단한 메모를 작성할 수 있습니다."
                    )]
                for routine in sampleRoutine {
                    self.saveRoutineItem(userId: userId, routine: routine, completion: completion)
                }
            } else {
                print("루틴 하위 컬렉션 이미 존재 - 초기화 필요 없음")
                completion(nil)
            }
        }
    }
    
    func saveRoutineItem(userId: String, routine: RoutineItem, completion: @escaping (Error?) -> Void) {
        let routineData = routine.toDictionary()
        db.collection("users").document(userId).collection("routines").document(routine.id).setData(routineData) { error in
            if let error = error {
                print("루틴 저장 실패: \(error.localizedDescription)")
            } else {
                print("루틴 저장 성공")
            }
            completion(error)
        }
    }
    
    func fetchRoutineItems(userId: String, completion: @escaping (Result<[RoutineItem], Error>) -> Void) {
        db.collection("users").document(userId).collection("routines").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let routines = snapshot?.documents.compactMap { doc -> RoutineItem? in
                guard let routine = RoutineItem(from: doc.data()) else {
                    print("루틴 데이터 변환 실패: \(doc.data())")
                    return nil
                }
                return routine
            } ?? []
            completion(.success(routines))
        }
    }
    
    
    func updateRoutineItem(userId: String, routineId: String, updatedData: [String: Any], completion: @escaping (Error?) -> Void) {
        let routineRef = db.collection("users").document(userId).collection("routines").document(routineId)
        routineRef.updateData(updatedData) { error in
            if let error = error {
                print("routine 업데이트 실패: \(error.localizedDescription)")
            } else {
                print("routine 업데이트 성공")
            }
            completion(error)
        }
    }
    
    func toggleRoutineCompletion(userId: String, routineId: String, completion: @escaping (Error?) -> Void) {
        let routineRef = db.collection("users").document(userId).collection("routines").document(routineId)
        
        routineRef.getDocument { snapshot, error in
            if let error = error {
                print("루틴 데이터 불러오기 실패: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            guard let data = snapshot?.data(), let currentStatus = data["isCompleted"] as? Bool else {
                print("루틴 데이터가 없거나 형식이 올바르지 않음")
                completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "데이터 없음"]))
                return
            }
            
            let newStatus = !currentStatus
            routineRef.updateData(["isCompleted": newStatus]) { error in
                if let error = error {
                    print("루틴 상태 업데이트 실패: \(error.localizedDescription)")
                    completion(error)
                } else {
                    print("루틴 상태 업데이트 성공: \(newStatus)")
                    completion(nil)
                }
            }
        }
    }
    
    func deleteRoutineItem(userId: String, routineId: String, completion: @escaping (Error?) -> Void) {
        let routineRef = db.collection("users").document(userId).collection("routines").document(routineId)
        routineRef.delete { error in
            completion(error)
        }
    }
}
