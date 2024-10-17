//
//  TodoDetailView.swift
//  Dding
//
//  Created by 이지은 on 10/12/24.
//

import UIKit

class NewTodoView: UIView {
    
    var confirmButtonTapped: (() -> Void)?
    var closeButtonTapped: (() -> Void)?
    
    // MARK: - UI Components
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할 일을 입력해주세요."
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    let dueDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ko-KR")
        
        return datePicker
    }()
    
    let reminderTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        
        return datePicker
    }()
    
    let completionTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        
        return datePicker
    }()
    
    let memo: UILabel = {
        let memo = UILabel()
        memo.text = String("testmemo")
        memo.textColor = .black
        
        return memo
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.backgroundColor = .cyan
        return stackView
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.addTarget(self, action: #selector(touchUpConfirmButton), for: .touchUpInside)
        button.backgroundColor = .clear
        
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.addTarget(self, action: #selector(touchUpCloseButton), for: .touchUpInside)
        button.backgroundColor = .clear
        
        return button
    }()
 
    let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        showViewWithAnimation()
        hideKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.addSubview(totalStackView)
        totalStackView.addSubview(titleTextField)
        totalStackView.addSubview(dueDatePicker)
        totalStackView.addSubview(timeStackView)
        timeStackView.addSubview(reminderTimePicker)
        timeStackView.addSubview(completionTimePicker)
        totalStackView.addSubview(memo)
        totalStackView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(confirmButton)
        buttonStackView.addArrangedSubview(closeButton)
    }
    
    private func setupLayout() {
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        dueDatePicker.translatesAutoresizingMaskIntoConstraints = false
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        reminderTimePicker.translatesAutoresizingMaskIntoConstraints = false
        completionTimePicker.translatesAutoresizingMaskIntoConstraints = false
        memo.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            totalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            totalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            totalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            totalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10),
            
            titleTextField.topAnchor.constraint(equalTo: totalStackView.topAnchor, constant: 20),
            titleTextField.centerXAnchor.constraint(equalTo: totalStackView.centerXAnchor),
            titleTextField.widthAnchor.constraint(equalToConstant: 200),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            dueDatePicker.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            dueDatePicker.centerXAnchor.constraint(equalTo: totalStackView.centerXAnchor),
            dueDatePicker.heightAnchor.constraint(equalToConstant: 50),
            
            timeStackView.topAnchor.constraint(equalTo: dueDatePicker.bottomAnchor, constant: 10),
            timeStackView.leadingAnchor.constraint(equalTo: totalStackView.leadingAnchor, constant: 10),
            timeStackView.trailingAnchor.constraint(equalTo: totalStackView.trailingAnchor, constant: 10),
            timeStackView.heightAnchor.constraint(equalToConstant: 80),
            
            reminderTimePicker.topAnchor.constraint(equalTo: timeStackView.topAnchor),
            reminderTimePicker.leadingAnchor.constraint(equalTo: timeStackView.leadingAnchor, constant: 10),
            reminderTimePicker.trailingAnchor.constraint(equalTo: timeStackView.trailingAnchor, constant: 10),
            reminderTimePicker.heightAnchor.constraint(equalToConstant: 40),
            
            completionTimePicker.bottomAnchor.constraint(equalTo: timeStackView.bottomAnchor),
            completionTimePicker.leadingAnchor.constraint(equalTo: timeStackView.leadingAnchor, constant: 10),
            completionTimePicker.trailingAnchor.constraint(equalTo: timeStackView.trailingAnchor, constant: 10),
            completionTimePicker.heightAnchor.constraint(equalToConstant: 40),
            
            memo.topAnchor.constraint(equalTo: timeStackView.bottomAnchor, constant: 10),
            memo.leadingAnchor.constraint(equalTo: timeStackView.leadingAnchor, constant: 10),
            memo.trailingAnchor.constraint(equalTo: timeStackView.trailingAnchor, constant: 10),
            memo.heightAnchor.constraint(equalToConstant: 50),
            
            buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    // MARK: - Dismiss
    @objc private func touchUpCloseButton() {
        closeButtonTapped?()
    }
    
    @objc private func touchUpConfirmButton() {
        confirmButtonTapped?()
    }
    
    func showViewWithAnimation() {
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapGesture)

//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let window = windowScene.windows.first {
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//            window.addGestureRecognizer(tapGesture)
//        }
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}
