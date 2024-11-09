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
    private var dayButtons: [UIButton] = []
    private let weekdayButton = UIButton(type: .system)
    private let weekendButton = UIButton(type: .system)
    private let everydayButton = UIButton(type: .system)
    private var days: [Int: String] = [1: "일", 2: "월", 3: "화", 4: "수", 5: "목", 6: "금", 7: "토"]
    var selectedDays: [Int] {
        return dayButtons.enumerated().compactMap { index, button in
            guard button.isSelected else { return nil }
            let dayValue = (index + 2) % 7
            return dayValue == 0 ? 7 : dayValue
        }
    }
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할 일을 입력해주세요."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let todoTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    private let weekdayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let specialButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
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
    
    let memoTextField: UITextField = {
        let textView = UITextField()
        textView.text = "testmemo"
        textView.textColor = .black
        return textView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.backgroundColor = .cyan
        return stackView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.addTarget(self, action: #selector(touchUpConfirmButton), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.addTarget(self, action: #selector(touchUpCloseButton), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
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
        setupDayButtons()
        setupSpecialButtons()
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.addSubview(totalStackView)
        
        totalStackView.addArrangedSubview(titleTextField)
        totalStackView.addArrangedSubview(todoTimePicker)
        totalStackView.addArrangedSubview(weekdayStackView)
        totalStackView.addArrangedSubview(specialButtonsStackView)
        totalStackView.addArrangedSubview(timeStackView)
        totalStackView.addArrangedSubview(memoTextField)
        totalStackView.addArrangedSubview(buttonStackView)
        
        timeStackView.addArrangedSubview(reminderTimePicker)
        timeStackView.addArrangedSubview(completionTimePicker)
        
        buttonStackView.addArrangedSubview(confirmButton)
        buttonStackView.addArrangedSubview(closeButton)
    }
    
    private func setupDayButtons() {
        for i in 2...8 {
            let button = UIButton(type: .system)
            button.setTitle(days[i] ?? "일", for: .normal)
            button.backgroundColor = .systemGray5
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
            dayButtons.append(button)
            weekdayStackView.addArrangedSubview(button)
        }
    }
    
    private func setupSpecialButtons() {
        weekdayButton.setTitle("평일", for: .normal)
        weekendButton.setTitle("주말", for: .normal)
        everydayButton.setTitle("매일", for: .normal)
        
        [weekdayButton, weekendButton, everydayButton].forEach { button in
            button.backgroundColor = .systemGray5
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(specialButtonTapped(_:)), for: .touchUpInside)
            specialButtonsStackView.addArrangedSubview(button)
        }
    }
    
    private func setupLayout() {
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        todoTimePicker.translatesAutoresizingMaskIntoConstraints = false
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        memoTextField.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        weekdayStackView.translatesAutoresizingMaskIntoConstraints = false
        specialButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleTextField.centerXAnchor.constraint(equalTo: totalStackView.centerXAnchor),
            titleTextField.widthAnchor.constraint(equalToConstant: 200),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            todoTimePicker.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            todoTimePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            todoTimePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            todoTimePicker.heightAnchor.constraint(equalToConstant: 50),
            
            weekdayStackView.topAnchor.constraint(equalTo: todoTimePicker.bottomAnchor, constant: 10),
            weekdayStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            weekdayStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            weekdayStackView.heightAnchor.constraint(equalToConstant: 30),
            
            specialButtonsStackView.topAnchor.constraint(equalTo: weekdayStackView.bottomAnchor, constant: 20),
            specialButtonsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            specialButtonsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            specialButtonsStackView.heightAnchor.constraint(equalToConstant: 30),
            
            totalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            totalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            totalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            totalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            timeStackView.topAnchor.constraint(equalTo: weekendButton.bottomAnchor, constant: 10),
            timeStackView.leadingAnchor.constraint(equalTo: totalStackView.leadingAnchor, constant: 10),
            timeStackView.trailingAnchor.constraint(equalTo: totalStackView.trailingAnchor, constant: -10),
            timeStackView.heightAnchor.constraint(equalToConstant: 80),
            
            memoTextField.topAnchor.constraint(equalTo: timeStackView.bottomAnchor, constant: 10),
            memoTextField.leadingAnchor.constraint(equalTo: timeStackView.leadingAnchor, constant: 10),
            memoTextField.trailingAnchor.constraint(equalTo: timeStackView.trailingAnchor, constant: -10),
            memoTextField.heightAnchor.constraint(equalToConstant: 50),
            
            buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func showViewWithAnimation() {
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    private func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc private func dayButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
//        sender.backgroundColor = sender.isSelected ? UIColor(red: 255, green: 250, blue: 205, alpha: 0) : .systemGray5
    }
    
    @objc private func specialButtonTapped(_ sender: UIButton) {
        dayButtons.enumerated().forEach { index, button in
            if sender == weekdayButton {
                button.isSelected = (index < 5)
            } else if sender == weekendButton {
                button.isSelected = (index >= 5)
            } else {
                button.isSelected = true
            }
        }
    }
    
    @objc private func touchUpConfirmButton() {
        confirmButtonTapped?()
        resetNewTodoView()
    }
    
    @objc private func touchUpCloseButton() {
        closeButtonTapped?()
        resetNewTodoView()
    }
    
    private func resetNewTodoView() {
        titleTextField.text = ""
        titleTextField.placeholder = "할 일을 입력해주세요."
        memoTextField.text = "testmemo"

        dayButtons.forEach { button in
            button.isSelected = false
            button.backgroundColor = .systemGray5
        }
        
        todoTimePicker.setDate(Date(), animated: false)
        reminderTimePicker.countDownDuration = 0
        completionTimePicker.countDownDuration = 0
    }

}
