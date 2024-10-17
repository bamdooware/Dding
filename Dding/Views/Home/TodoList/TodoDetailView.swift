//
//  TodoDetailView.swift
//  Dding
//
//  Created by 이지은 on 10/12/24.
//

import UIKit

class TodoDetailView: UIView {

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let dueDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let reminderTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let completionCheckTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dueDateLabel)
        stackView.addArrangedSubview(reminderTimeLabel)
        stackView.addArrangedSubview(completionCheckTimeLabel)
        stackView.addArrangedSubview(memoLabel)
        stackView.addArrangedSubview(closeButton)

        closeButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
    }
    
    private func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Public Method
    func configure(with item: TodoItem) {
        titleLabel.text = item.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dueDateLabel.text = "Due: \(dateFormatter.string(from: item.dueDate))"
        reminderTimeLabel.text = "Reminder: \(item.reminderTime) min"
        completionCheckTimeLabel.text = "Completion Check: \(item.completionCheckTime) min"
        memoLabel.text = "Memo: \(item.memo)"
    }
    
    // MARK: - Dismiss
    @objc private func dismissPopup() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
