//
//  RoutineHeaderView.swift
//  Dding
//
//  Created by 이지은 on 11/23/24.
//

import UIKit

protocol RoutineHeaderViewDelegate: AnyObject {
    func didTapToggleButton(in headerView: RoutineHeaderView)
}

class RoutineHeaderView: UIView {
    weak var delegate: RoutineHeaderViewDelegate?
    var sectionIndex: Int = 0
    
    let titleLabel = UILabel()
    let progressView = UIProgressView(progressViewStyle: .default)
    private let toggleButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = .systemGray3 /*UIColor(red: 151.0/255.0, green: 153.0/255.0, blue: 155.0/255.0, alpha: 1.0)*/
        progressView.progressTintColor = UIColor(red: 0.0/255.0, green: 114.0/255.0, blue: 206/255.0, alpha: 1.0)
        progressView.progress = 0.0
        
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        
        addSubview(toggleButton)
        addSubview(titleLabel)
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            progressView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 15),
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            progressView.trailingAnchor.constraint(equalTo: toggleButton.leadingAnchor, constant: -10),
            
            toggleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            toggleButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            toggleButton.widthAnchor.constraint(equalToConstant: 24),
            toggleButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    func updateProgress(progress: Float) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.progressView.setProgress(progress, animated: true)
        }
    }
    
    @objc private func toggleButtonTapped() {
        delegate?.didTapToggleButton(in: self)
    }
    
    static func createAndAdd(to view: UIView, title: String, progress: Float, topAnchor: NSLayoutYAxisAnchor) -> RoutineHeaderView {
        let headerView = RoutineHeaderView()
        headerView.configure(with: title)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return headerView
    }
}
