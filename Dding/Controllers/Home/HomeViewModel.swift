//
//  HomeViewModel.swift
//  Dding
//
//  Created by 이지은 on 11/23/24.
//

import Foundation

protocol RoutineListViewInteractionDelegate: AnyObject {
    func didSelectRoutineItem(_ item: RoutineItem)
    func didLongPressRoutineItem(_ item: RoutineItem)
}

class HomeViewModel {
    weak var delegate: RoutineListViewInteractionDelegate?
    var didFailWithError: ((Error) -> Void)?
    var didUpdateItems: (() -> Void)?
    private let firebaseService: FirebaseService
    private let calendar = Calendar.current
    private let today: Int = Calendar.current.component(.weekday, from: Date())
    private(set) var routines: [RoutineItem] = []
    private(set) var todos: [RoutineItem] = []
    var filteredRoutines: [RoutineItem] = []
    var fixedRoutines: [RoutineItem] = []
    var unfixedRoutines: [RoutineItem] = []
    var completedRoutines: Int {
        filteredRoutines.filter { $0.isCompleted }.count
    }
    private let keychain = KeychainManager.shared
    
    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }
    
    var progress: Float {
        guard !filteredRoutines.isEmpty else {
            return 0
        }
        let result = Float(completedRoutines) / Float(filteredRoutines.count)
        return result
    }
    
    func fetchRoutineItems(for userId: String) {
        firebaseService.fetchRoutineItems(userId: userId) { [weak self] result in
            switch result {
            case .success(let routines):
                self?.routines = routines
                self?.filterAndSortRoutineItems()
                
                DispatchQueue.main.async {
                    self?.didUpdateItems?()
                }
            case .failure(let error):
                print("데이터 가져오기 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.didFailWithError?(error)
                }
            }
        }
    }
    
    func deleteRoutineItem(at indexPath: IndexPath, completion: @escaping (Error?) -> Void) {
        guard indexPath.row < routines.count else { return }
        let routine = routines[indexPath.row].id
        guard let userId = keychain.getUserIdentifier() else {
            print("사용자 정보가 유효하지 않습니다.")
            return
        }
        
        firebaseService.deleteRoutineItem(userId: userId, routineId: routine) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                return
            }
            self.routines.remove(at: indexPath.row)
            self.filterAndSortRoutineItems()
            
            completion(nil)
        }
    }
    
    func toggleCompletionStatus(at indexPath: IndexPath, completion: @escaping (Error?) -> Void) {
        guard indexPath.row < routines.count else {
            print("잘못된 indexPath")
            return
        }
        let routineId = routines[indexPath.row].id
        
        guard let userId = keychain.getUserIdentifier() else {
            print("사용자 정보가 유효하지 않습니다.")
            return
        }
        
        firebaseService.toggleRoutineCompletion(userId: userId, routineId: routineId) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print("루틴 상태 토글 실패: \(error.localizedDescription)")
                completion(error)
                return
            }
            self.routines[indexPath.row].isCompleted.toggle()
            self.filterAndSortRoutineItems()
            
            completion(nil)
        }
    }
    
    func fixRoutineItem(_ routine: RoutineItem) {
        guard let index = routines.firstIndex(where: { $0.id == routine.id }) else { return }
        let fixedItem = routines.remove(at: index)
        routines.insert(fixedItem, at: 0)
        filterAndSortRoutineItems()
        didUpdateItems?()
    }

    func filterAndSortRoutineItems() {
        filteredRoutines = routines
            .filter { !$0.repeatDays.isEmpty && $0.repeatDays.contains(today) }
            .sorted {
                let time1 = ($0.routineTime.hour ?? 0, $0.routineTime.minute ?? 0)
                let time2 = ($1.routineTime.hour ?? 0, $1.routineTime.minute ?? 0)
                return time1 < time2
            }
    }
    
    func calculateRoutineListHeight() -> CGFloat {
        let cellHeight: CGFloat = 60
        let cellCount = filteredRoutines.count + 1
        return CGFloat(cellCount) * cellHeight
    }
    
    func calculateTodoListHeight() -> CGFloat {
        let cellHeight: CGFloat = 60
        let cellCount = todos.count + 1
        return CGFloat(cellCount) * cellHeight
    }
}

extension HomeViewModel {
    func indexPath(for routineItem: RoutineItem) -> IndexPath? {
        guard let index = routines.firstIndex(where: { $0.id == routineItem.id }) else { return nil }
        return IndexPath(row: index, section: 0)
    }
}
