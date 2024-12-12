//
//  AddNewItemView.swift
//  Dding
//
//  Created by 이지은 on 12/4/24.
//

import UIKit

protocol AddNewItemViewDelegate: AnyObject {
    func didTapSaveButton()
}

class AddNewItemView: UIView {
    weak var interactionDelegate: AddNewItemViewDelegate?

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let titleStackView = UIStackView()
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    
    let tagLabel = UILabel()
    let tagSelectionView = UIStackView()
    
    let repeatDaysStackView = UIStackView()
    var repeatDayButtons: [UIButton] = []
    
    let timeStackView = UIStackView()
    
    let routineTimeStackView = UIStackView()
    let routineTimeLabel = UILabel()
    let routineTimePicker = UIDatePicker()
    
    let reminderStackView = UIStackView()
    let reminderTimeLabel = UILabel()
    let reminderTimeStepper = UIStepper()
    let reminderTimeValueLabel = UILabel()
    
    let completionStackView = UIStackView()
    let completionCheckTimeLabel = UILabel()
    let completionCheckTimeStepper = UIStepper()
    let completionCheckTimeValueLabel = UILabel()
    
    let memoLabel = UILabel()
    let memoTextView = UITextView()
    
    let saveButton = UIButton(type: .system)
    
    var selectedTag: TagColor = .red
    var selectedRepeatDays: [Int] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .systemBackground
        
        setupScrollView()
        setupTitleSection()
        setupTagSection()
        setupRepeatDaysSection()
        setupRoutineTimeSection()
        setupTimeAdjustmentsSection()
        setupMemoSection()
        setupSaveButton()
    }
    
    private func setupScrollView() {
        contentView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupTitleSection() {
        titleTextField.borderStyle = .roundedRect
        titleTextField.placeholder = "루틴 이름을 입력해주세요"
        titleTextField.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleTextField)
    }
    
    private func setupTagSection() {
        tagSelectionView.axis = .vertical
        tagSelectionView.spacing = 8
        tagSelectionView.alignment = .fill
        tagSelectionView.distribution = .fillEqually
        tagSelectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tagSelectionView)
        
        let row1 = UIStackView()
        row1.axis = .horizontal
        row1.spacing = 8
        row1.distribution = .equalSpacing
        row1.alignment = .fill
        row1.translatesAutoresizingMaskIntoConstraints = false
        
        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.spacing = 8
        row2.distribution = .equalSpacing
        row2.alignment = .fill
        row2.translatesAutoresizingMaskIntoConstraints = false
        
        let colors = TagColor.allCases
        for (index, color) in colors.enumerated() {
            let colorView = UIView()
            colorView.backgroundColor = color.color
            colorView.layer.cornerRadius = 18
            colorView.layer.borderWidth = color == selectedTag ? 2 : 0
            colorView.layer.borderColor = UIColor.black.cgColor
            colorView.translatesAutoresizingMaskIntoConstraints = false
            colorView.widthAnchor.constraint(equalToConstant: 36).isActive = true
            colorView.heightAnchor.constraint(equalToConstant: 36).isActive = true
            colorView.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tagColorTapped(_:)))
            colorView.addGestureRecognizer(tapGesture)
            
            if index < 5 {
                row1.addArrangedSubview(colorView)
            } else {
                row2.addArrangedSubview(colorView)
            }
        }
        
        tagSelectionView.addArrangedSubview(row1)
        tagSelectionView.addArrangedSubview(row2)
    }

    
    private func setupRepeatDaysSection() {
        repeatDaysStackView.axis = .horizontal
        repeatDaysStackView.alignment = .center
        repeatDaysStackView.distribution = .equalSpacing
        repeatDaysStackView.spacing = 10
        repeatDaysStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(repeatDaysStackView)
        
        let dayTags = [2, 3, 4, 5, 6, 7, 1]
        
        for i in 0..<7 {
            let button = UIButton(type: .system)
            button.setTitle(["월", "화", "수", "목", "금", "토", "일"][i], for: .normal)
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 8
            button.backgroundColor = .systemBackground
            button.titleLabel?.font = .systemFont(ofSize: 16)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 36),
                button.heightAnchor.constraint(equalToConstant: 36)
            ])
            
            button.tag = dayTags[i]
            button.addTarget(self, action: #selector(repeatDayButtonTapped(_:)), for: .touchUpInside)
            repeatDaysStackView.addArrangedSubview(button)
            repeatDayButtons.append(button)
        }
    }

    
    private func setupRoutineTimeSection() {
        routineTimeLabel.text = "시간"
        routineTimeLabel.font = .boldSystemFont(ofSize: 16)
        routineTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        routineTimeStackView.axis = .horizontal
        routineTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        routineTimePicker.datePickerMode = .time
        routineTimePicker.preferredDatePickerStyle = .compact
        routineTimePicker.translatesAutoresizingMaskIntoConstraints = false
        
        routineTimeStackView.addArrangedSubview(routineTimeLabel)
        routineTimeStackView.addArrangedSubview(routineTimePicker)
        contentView.addSubview(routineTimeStackView)
    }
    
    private func setupTimeAdjustmentsSection() {
        timeStackView.axis = .vertical
        timeStackView.spacing = 16
        timeStackView.distribution = .fillEqually
        timeStackView.alignment = .center
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeStackView)
        
        setupReminderStack()
        setupCompletionStack()
    }
    
    private func setupReminderStack() {
        reminderTimeLabel.text = "미리 알림"
        reminderTimeLabel.font = .boldSystemFont(ofSize: 16)
        
        reminderStackView.axis = .horizontal
        reminderStackView.addArrangedSubview(reminderTimeLabel)
        
        reminderTimeStepper.minimumValue = 0
        reminderTimeStepper.maximumValue = 120
        reminderTimeStepper.stepValue = 5
        reminderTimeValueLabel.text = "0"
        reminderStackView.addArrangedSubview(reminderTimeValueLabel)
        reminderTimeStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        reminderStackView.addArrangedSubview(reminderTimeStepper)

        timeStackView.addArrangedSubview(reminderStackView)
    }
    
    private func setupCompletionStack() {
        completionCheckTimeLabel.text = "완료 확인 알림"
        completionCheckTimeLabel.font = .boldSystemFont(ofSize: 16)
        
        completionStackView.axis = .horizontal
        completionStackView.addArrangedSubview(completionCheckTimeLabel)
        
        completionCheckTimeStepper.minimumValue = 0
        completionCheckTimeStepper.maximumValue = 120
        completionCheckTimeStepper.stepValue = 5
        completionCheckTimeValueLabel.text = "0"
        completionStackView.addArrangedSubview(completionCheckTimeValueLabel)
        completionCheckTimeStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        completionStackView.addArrangedSubview(completionCheckTimeStepper)

        timeStackView.addArrangedSubview(completionStackView)
    }
    
    private func setupMemoSection() {
        memoLabel.text = "간단한 메모"
        memoLabel.font = .boldSystemFont(ofSize: 16)
        memoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(memoLabel)
        
        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = UIColor.lightGray.cgColor
        memoTextView.layer.cornerRadius = 4
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(memoTextView)
    }
    
    private func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        contentView.addSubview(saveButton)
    }

    @objc private func saveButtonTapped() {
        interactionDelegate?.didTapSaveButton()
    }
    
    // MARK: - Constraints Setup
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),

            tagSelectionView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 25),
            tagSelectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            tagSelectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),

            repeatDaysStackView.topAnchor.constraint(equalTo: tagSelectionView.bottomAnchor, constant: 25),
            repeatDaysStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            repeatDaysStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            routineTimeStackView.topAnchor.constraint(equalTo: repeatDaysStackView.bottomAnchor, constant: 16),
            routineTimeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            routineTimeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            timeStackView.topAnchor.constraint(equalTo: routineTimeStackView.bottomAnchor, constant: 16),
            timeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            timeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            memoLabel.topAnchor.constraint(equalTo: timeStackView.bottomAnchor, constant: 16),
            memoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            memoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            memoTextView.topAnchor.constraint(equalTo: memoLabel.bottomAnchor, constant: 8),
            memoTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            memoTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            memoTextView.heightAnchor.constraint(equalToConstant: 100),
            
            saveButton.topAnchor.constraint(equalTo: memoTextView.bottomAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func tagColorTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view else { return }
        let colors = TagColor.allCases
        if let index = tagSelectionView.arrangedSubviews.firstIndex(of: selectedView),
           index < colors.count {
            selectedTag = colors[index]
        }
        for subview in tagSelectionView.arrangedSubviews {
            subview.layer.borderWidth = 0
        }
        selectedView.layer.borderWidth = 2
    }
    
    @objc private func repeatDayButtonTapped(_ sender: UIButton) {
        if selectedRepeatDays.contains(sender.tag) {
            selectedRepeatDays.removeAll { $0 == sender.tag }
            sender.backgroundColor = .white
        } else {
            selectedRepeatDays.append(sender.tag)
            sender.backgroundColor = .systemBlue
        }
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        if sender == reminderTimeStepper {
            reminderTimeValueLabel.text = "\(Int(sender.value)) min"
        } else if sender == completionCheckTimeStepper {
            completionCheckTimeValueLabel.text = "\(Int(sender.value)) min"
        }
    }
}
