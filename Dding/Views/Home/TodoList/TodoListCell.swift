//
//  TodoListCell.swift
//  Dding
//
//  Created by 이지은 on 10/1/24.
//

import UIKit

class TodoListCell: UITableViewCell {
    
    private let cellStackView: UIView = {
        let view = UIView()
        view.layer.borderColor = CGColor(red: 125.0/255.0, green: 125.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        view.layer.borderWidth = 1.5
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let emojiView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let todoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(cellStackView)
        cellStackView.addSubview(emojiView)
        cellStackView.addSubview(todoTitleLabel)
    }
    
    private func setupConstraints() {
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        todoTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            emojiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiView.widthAnchor.constraint(equalToConstant: 16),
            emojiView.heightAnchor.constraint(equalToConstant: 16),
            
            todoTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            todoTitleLabel.leadingAnchor.constraint(equalTo: emojiView.trailingAnchor, constant: 8),
            todoTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func configure(with item: TodoItem) {
        todoTitleLabel.textColor = item.isCompleted ? .lightGray : .black
        let titleAttributes: [NSAttributedString.Key: Any] = item.isCompleted ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue] : [:]
        todoTitleLabel.attributedText = NSAttributedString(string: item.title, attributes: titleAttributes)
    }
}
