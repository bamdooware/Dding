//
//  RoutineCell.swift
//  Dding
//
//  Created by 이지은 on 11/23/24.
//

import UIKit

class RoutineCell: UITableViewCell {
    static let identifier = "RoutineCell"
    private let titleLabel = UILabel()
    private let tagView = UIView()
    private let timeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16))
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 15
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.masksToBounds = false
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tagView.layer.cornerRadius = 4
        tagView.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.tintColor = .systemGray4
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(tagView)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            tagView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagView.widthAnchor.constraint(equalToConstant: 8),
            tagView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            titleLabel.leadingAnchor.constraint(equalTo: tagView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func configure(with routine: RoutineItem) {
        let textAttributes: [NSAttributedString.Key: Any] = routine.isCompleted ?
            [.strikethroughStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.lightGray] :
            [.foregroundColor: UIColor.black]
        
        UIView.transition(with: titleLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.titleLabel.attributedText = NSAttributedString(string: routine.title, attributes: textAttributes)
        }
        
        UIView.transition(with: timeLabel, duration: 0.3, options: .transitionCrossDissolve) {
            let timeString = self.convertToTimeString(from: routine.routineTime) ?? "00:00"
            self.titleLabel.numberOfLines = 1
            self.timeLabel.attributedText = NSAttributedString(string: timeString, attributes: textAttributes)
        }
        tagView.backgroundColor = routine.tag.color
    }
    
    func convertToTimeString(from dateComponents: DateComponents) -> String? {
        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
}
