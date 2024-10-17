//
//  ProgressStackView.swift
//  Dding
//
//  Created by 이지은 on 10/11/24.
//

import UIKit

class ProgressStackView: UIStackView {

    let progressView = UIProgressView(progressViewStyle: .bar)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProgressStackView() {
        progressView.tintColor = .blue
        progressView.trackTintColor = .lightGray
        
        self.axis = .horizontal
        self.alignment = .center
        self.addArrangedSubview(progressView)
//        
//        progressView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            progressView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            progressView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
//            progressView.heightAnchor.constraint(equalToConstant: 5)
//        ])
    }
}
