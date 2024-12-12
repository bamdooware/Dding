//
//  ProgressStackView.swift
//  Dding
//
//  Created by 이지은 on 10/11/24.
//

import UIKit

class ProgressStackView: UIStackView {

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter
    }()
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.tintColor = UIColor(red: 255.0/255.0, green: 250.0/255.0, blue: 205.0/255.0, alpha: 1.0)
        progressView.trackTintColor = .lightGray
        return progressView
    }()
    
    private let dayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        return stackView
    }()
    
    private let previousDayBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let nextDayBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
        return label
    }()
    
    private let buttonSize: CGFloat = 24
    private var selectedDate = Date()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        updateButtonStates()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        dayStackView.addArrangedSubview(previousDayBtn)
        dayStackView.addArrangedSubview(dayLabel)
        dayStackView.addArrangedSubview(nextDayBtn)
        
        self.axis = .vertical
        self.addArrangedSubview(dayStackView)
        self.addArrangedSubview(progressView)

        previousDayBtn.addTarget(self, action: #selector(previousDayTapped), for: .touchUpInside)
        nextDayBtn.addTarget(self, action: #selector(nextDayTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            dayStackView.heightAnchor.constraint(equalToConstant: 55),
            previousDayBtn.widthAnchor.constraint(equalToConstant: buttonSize),
            previousDayBtn.heightAnchor.constraint(equalToConstant: buttonSize),
            nextDayBtn.widthAnchor.constraint(equalToConstant: buttonSize),
            nextDayBtn.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
    }

    func updateProgress(completedTask: Int, totalTask: Int) {
        let progress = totalTask > 0 ? Float(completedTask) / Float(totalTask) : 0
        animateProgress(to: progress)
    }
    
    private func animateProgress(to progress: Float) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.progressView.setProgress(progress, animated: true)
        }
    }

    private func updateButtonStates() {
        let today = dateFormatter.string(from: Date())
        let selectedDateStr = dateFormatter.string(from: selectedDate)
        
        nextDayBtn.isEnabled = selectedDateStr != today
        nextDayBtn.alpha = nextDayBtn.isEnabled ? 1.0 : 0.5
    }

    func changeDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            selectedDate = newDate
            dayLabel.text = dateFormatter.string(from: selectedDate)
            updateButtonStates()
        }
    }
    
    @objc private func previousDayTapped() {
        changeDate(by: -1)
    }

    @objc private func nextDayTapped() {
        changeDate(by: 1)
    }
}
