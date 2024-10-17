//
//  HeaderStackView.swift
//  Dding
//
//  Created by 이지은 on 10/11/24.
//

import UIKit

class HeaderStackView: UIStackView {
    
    let headerImageView = UIImageView(image: UIImage(named: "HomeLogo")) // 타이틀 포함된 이미지
    let settingsButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        headerImageView.contentMode = .scaleAspectFit
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true // 원하는 크기로 조정
        
        self.addArrangedSubview(headerImageView)
        self.addArrangedSubview(settingsButton)
        self.setCustomSpacing(20, after: headerImageView)
    }
}
