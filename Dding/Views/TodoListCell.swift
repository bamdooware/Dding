//
//  TodoListCell.swift
//  Dding
//
//  Created by 이지은 on 10/1/24.
//

import UIKit

class TodoListCell: UITableViewCell {
    
    private lazy var emojiView: UIView = {
        let view = UIView(frame: .init(x: 0, y: 0, width: 16, height: 16))
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var todoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    func configure() {
        contentView.backgroundColor = .yellow
        contentView.layer.cornerRadius = 8
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(emojiView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(todoTitleLabel)
        stackView.addArrangedSubview(checkImageView)
    }
    
    private func makeConstraints() {
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        todoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        checkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emojiView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emojiView.widthAnchor.constraint(equalToConstant: 16),
            emojiView.heightAnchor.constraint(equalToConstant: 16),
            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: emojiView.trailingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
        ])
        todoTitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        checkImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    
    //    private let titleLabel = UILabel()
    //    private let checkmarkImageView = UIImageView()
    //
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //
    //    private func setupUI() {
    //        addSubview(titleLabel)
    //        addSubview(checkmarkImageView)
    //
    //        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    //        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
    //
    //        NSLayoutConstraint.activate([
    //            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
    //            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
    //
    //            checkmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
    //            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
    //            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
    //            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
    //        ])
    //    }
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16.0, left: 16, bottom: 16, right: 16))
    //    }
    //
    func configure(with item: TodoItem) {
        
        if item.isCompleted {
            textLabel?.textColor = .lightGray
            textLabel?.attributedText = NSAttributedString(string: item.title, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        } else {
            textLabel?.textColor = .black
            textLabel?.attributedText = NSAttributedString(string: item.title, attributes: [:])
        }
        checkImageView.image = item.isCompleted ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
    }
}
