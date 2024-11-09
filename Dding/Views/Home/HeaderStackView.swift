//
//  HeaderStackView.swift
//  Dding
//
//  Created by 이지은 on 10/11/24.
//

import UIKit

class HeaderStackView: UIStackView {
    
    let headerImageView = UIImageView(image: UIImage(named: "HomeLogo"))
    let headerTitle = UILabel()
    let settingsButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        headerTitle.text = "DDING!"
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        self.addArrangedSubview(headerTitle)
        self.addArrangedSubview(settingsButton)
        self.setCustomSpacing(20, after: headerImageView)
    }
}
