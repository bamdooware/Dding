//
//  HomeViewController.swift
//  Dding
//
//  Created by 이지은 on 11/23/24.
//

import UIKit

class HomeViewController: UIViewController {
    private let keychain = KeychainManager.shared
    let viewModel: HomeViewModel
    private var routineListView: RoutineListView!
    private var todoListView: RoutineListView!
    private var routineHeaderView: RoutineHeaderView!
    private var todoHeaderView: RoutineHeaderView!
    private var isSectionExpanded = [true, true]
    
    init(viewModel: HomeViewModel = HomeViewModel(firebaseService: FirebaseService.shared)) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndLayout()
        setupBindings()
        view.backgroundColor = .systemBackground
        guard let userId = keychain.getUserIdentifier() else {
            print("사용자 정보가 유효하지 않습니다.")
            return
        }
        viewModel.fetchRoutineItems(for: userId)
    }
    
    private func setupBindings() {
        viewModel.didUpdateItems = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.routineHeaderView.updateProgress(progress: self.viewModel.progress)
                self.routineListView.updateRoutines(self.viewModel.filteredRoutines)
                self.todoListView.updateRoutines(self.viewModel.todos)
                self.updateRoutineListViewHeight()
                self.updateTodoListViewHeight()
            }
        }
    }
    
    private func updateRoutineListViewHeight() {
        let newHeight = viewModel.calculateRoutineListHeight()
        if let heightConstraint = routineListView.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = newHeight
        } else {
            routineListView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
        }
    }
    
    private func updateTodoListViewHeight() {
        let newHeight = viewModel.calculateRoutineListHeight()
        if let heightConstraint = todoListView.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = newHeight
        } else {
            todoListView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
        }
    }
    
    @objc private func didTapProfileButton() {
        let profileVC = ProfileViewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }

    private func setupViewsAndLayout() {
        self.navigationItem.title = "DDING!"
        
        let profileButton = UIBarButtonItem(
            image: UIImage(systemName: "person"),
            style: .plain,
            target: self,
            action: #selector(didTapProfileButton)
        )
        self.navigationItem.rightBarButtonItem = profileButton
        
        routineListView = RoutineListView(title: "오늘 루틴")
        routineListView.interactionDelegate = self
        todoListView = RoutineListView(title: "할 일")
        todoListView.interactionDelegate = self
        
        routineHeaderView = createHeaderView(title: "오늘 루틴")
        todoHeaderView = createHeaderView(title: "할 일")
        routineHeaderView.updateProgress(progress: viewModel.progress)
        todoHeaderView.updateProgress(progress: viewModel.progress)
        
        [routineHeaderView, routineListView, todoHeaderView, todoListView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            routineHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            routineHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            routineHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            routineHeaderView.heightAnchor.constraint(equalToConstant: 50),
            
            routineListView.topAnchor.constraint(equalTo: routineHeaderView.bottomAnchor),
            routineListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            routineListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            todoHeaderView.topAnchor.constraint(equalTo: routineListView.bottomAnchor),
            todoHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            todoHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            todoHeaderView.heightAnchor.constraint(equalToConstant: 50),
            
            todoListView.topAnchor.constraint(equalTo: todoHeaderView.bottomAnchor),
            todoListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func createHeaderView(title: String) -> RoutineHeaderView {
        let headerView = RoutineHeaderView()
        headerView.titleLabel.text = title
        return headerView
    }

    func fixRoutineItem(_ routine: RoutineItem) {
        viewModel.fixRoutineItem(routine)
    }
        
    func fetchAndReloadRoutines() {
        guard let userId = keychain.getUserIdentifier() else {
            print("사용자 정보가 유효하지 않습니다.")
            return
        }
        viewModel.fetchRoutineItems(for: userId)
    }
    
}

extension HomeViewController: RoutineListViewDelegate {
    func didSelectRoutineItem(_ routineItem: RoutineItem) {
        print("Routine Selected: \(routineItem.title)")
        viewModel.delegate?.didSelectRoutineItem(routineItem)
    }
    
    func didLongPressRoutineItem(_ routineItem: RoutineItem) {
        guard let indexPath = viewModel.indexPath(for: routineItem) else { return }
        
        viewModel.toggleCompletionStatus(at: indexPath) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print("완료 상태 토글 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "루틴 완료 상태를 변경하는 데 문제가 발생했습니다.")
                }
            } else {
                print("완료 상태 토글 성공")
                
                let updatedRoutine = self.viewModel.filteredRoutines[indexPath.row]
                
                DispatchQueue.main.async {
                    self.routineListView.updateRoutineItem(at: indexPath, with: updatedRoutine)
                    self.routineHeaderView.updateProgress(progress: self.viewModel.progress)
                }
            }
        }
    }

    
    func deleteRoutineItem(at indexPath: IndexPath) {
        viewModel.deleteRoutineItem(at: indexPath) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("루틴 삭제 실패: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "루틴 삭제 중 문제가 발생했습니다.")
                }
            } else {
                DispatchQueue.main.async {
                    self.routineListView.deleteRoutineItem(at: indexPath)
                }
            }
        }
    }
    
    func showAlertForRoutineItem(_ routineItem: RoutineItem, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "삭제 확인",
                                      message: "이 루틴을 삭제하시겠습니까?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            completion(false)
        }
        let confirmAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            completion(true)
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    func didTapAddButton() {
        let addNewItemVC = AddNewItemViewController()
        addNewItemVC.modalPresentationStyle = .formSheet
        addNewItemVC.delegate = self
        present(addNewItemVC, animated: true)
    }
    
    func didTapFixButton() {
        
    }
}

extension HomeViewController: AddNewItemViewControllerDelegate {
    func didSaveNewRoutine() {
        fetchAndReloadRoutines()
    }
}
