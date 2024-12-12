//
//  AddNewItemViewController.swift
//  Dding
//
//  Created by 이지은 on 12/3/24.
//

import UIKit

protocol AddNewItemViewControllerDelegate: AnyObject {
    func didSaveNewRoutine()
}

class AddNewItemViewController: UIViewController {
    weak var delegate: AddNewItemViewControllerDelegate?
    
    private let keychain = KeychainManager.shared
    private let addNewItemView = AddNewItemView()
    private let viewModel: AddNewItemViewModel
    
    init(viewModel: AddNewItemViewModel = AddNewItemViewModel(firebaseService: FirebaseService.shared)) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = addNewItemView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableKeyboardDismissOnTap()
        addNewItemView.interactionDelegate = self
    }
}

extension AddNewItemViewController: AddNewItemViewDelegate {
    func didTapSaveButton() {
        guard let title = addNewItemView.titleTextField.text, !title.isEmpty else {
            showAlert(title: "오류", message: "루틴 이름을 입력해주세요.")
            return
        }
        
        guard let userId = keychain.getUserIdentifier() else {
            print("사용자 정보가 유효하지 않습니다.")
            return
        }
        
        let routineItem = RoutineItem(
            id: UUID().uuidString,
            title: addNewItemView.titleTextField.text ?? "",
            tag: addNewItemView.selectedTag,
            repeatDays: addNewItemView.selectedRepeatDays,
            routineTime: DateComponents(hour: Calendar.current.component(.hour, from: addNewItemView.routineTimePicker.date),
                                        minute: Calendar.current.component(.minute, from: addNewItemView.routineTimePicker.date)),
            isCompleted: false,
            reminderTime: Int(addNewItemView.reminderTimeStepper.value),
            completionCheckTime: Int(addNewItemView.completionCheckTimeStepper.value),
            memo: addNewItemView.memoTextView.text
        )
        viewModel.saveRoutineItem(for: userId, routine: routineItem) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.showAlert(title: "성공", message: "루틴이 저장되었습니다.") { [weak self] in
                        self?.dismiss(animated: true)
                        self?.delegate?.didSaveNewRoutine()
                    }
                case .failure(let error):
                    self?.showAlert(title: "저장실패", message: "저장에 실패하였습니다.: \(error.localizedDescription)")
                }
            }
        }
    }
}

