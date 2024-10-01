//
//  TodoListCell.swift
//  Dding
//
//  Created by 이지은 on 10/1/24.
//

import UIKit

class TodoListCell: UITableViewCell {

    // UI 요소들
    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI() // 셀의 UI를 설정
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 셀 UI 설정
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(checkmarkImageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            checkmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    // 셀을 구성하는 메서드 (모델 데이터로 UI 설정)
    func configure(with item: TodoItem) {
        
        if item.isCompleted {
            // 완료된 항목의 스타일 설정 (예: 취소선)
            textLabel?.textColor = .lightGray
            textLabel?.attributedText = NSAttributedString(string: item.title, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        } else {
            // 미완료 항목의 스타일 설정
            textLabel?.textColor = .black
            textLabel?.attributedText = NSAttributedString(string: item.title, attributes: [:])
        }
        checkmarkImageView.image = item.isCompleted ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
    }
}
