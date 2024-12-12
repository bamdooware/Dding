//
//  SubjectViewController.swift
//  Dding
//
//  Created by 이지은 on 9/30/24.
//

import UIKit

class SubjectViewController: UIViewController {
    
    let headerStackView = HeaderStackView()
    let tagListView = TagListView()
    let calendarView = CalendarView()
    
    private let segmentedControl: UISegmentedControl = {
        var control = UISegmentedControl(items: ["태그별", "날짜별"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeaderStackView()
        setupSegmentedView()
        setupConstraints()
        
    }
    private func setupHeaderStackView() {
        view.addSubview(headerStackView)
    }
    
    private func setupSegmentedView() {
        view.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        view.addSubview(calendarView)
        view.addSubview(tagListView)
        
        setupConstraints()
    }
    
    private func updateSegmentedView() {
        let showCalendarView = segmentedControl.selectedSegmentIndex == 0
        calendarView.isHidden = !showCalendarView
        tagListView.isHidden = showCalendarView
    }
    
    private func setupConstraints() {
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        tagListView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            headerStackView.heightAnchor.constraint(equalToConstant: 55),
            
            segmentedControl.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            calendarView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            tagListView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            tagListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tagListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tagListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func segmentedControlValueChanged() {
        updateSegmentedView()
    }
    

    
}
