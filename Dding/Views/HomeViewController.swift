//
//  HomeViewController.swift
//  Dding
//
//  Created by 이지은 on 9/30/24.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Properties
    var todoItems: [TodoItem] = [
        TodoItem(title: "test", isCompleted: true, dueDate: Date(), reminderTime: 10, completionCheckTime: 10, tag: "test", memo: "test memo"),
        TodoItem(title: "test", isCompleted: true, dueDate: Date(), reminderTime: 10, completionCheckTime: 10, tag: "test", memo: "test memo"),
        TodoItem(title: "test", isCompleted: false, dueDate: Date(), reminderTime: 10, completionCheckTime: 10, tag: "test", memo: "test memo")
    ]
    
    let headerStackView = UIStackView()
    let progressStackView = UIStackView()
    let progressView = UIProgressView(progressViewStyle: .bar)
    let todoListTableView = UITableView()
    let backgroundView = UIView() // 배경을 어둡게 할 UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        // 배경 뷰 설정
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0 // 미리 alpha 설정
        
        setupHeaderStackView()
        setupProgressStackView()
        setupProgressView()
        setupTableView()
        setupConstraints()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        todoListTableView.addGestureRecognizer(longPressGesture)
        
        view.addSubview(backgroundView)
    }
    
    // Setup Header Stack View
    private func setupHeaderStackView() {
        let headerImageView = UIImageView(image: UIImage(systemName: "icloud"))
        headerImageView.contentMode = .scaleAspectFit
        
        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        
        headerStackView.axis = .horizontal
        headerStackView.distribution = .equalSpacing
        headerStackView.alignment = .center
        headerStackView.backgroundColor = .green
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.addArrangedSubview(headerImageView)
        headerStackView.addArrangedSubview(settingsButton)
        view.addSubview(headerStackView)
    }
    
    // Setup Progress Stack View
    private func setupProgressStackView() {
        progressStackView.axis = .horizontal
        progressStackView.backgroundColor = .systemPink
        progressStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressStackView)
    }
    
    private func setupProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.0 // 초기 진행률
        progressView.tintColor = .blue // 진행률 색상
        progressView.trackTintColor = .lightGray // 배경 색상
        view.addSubview(progressView)
    }
    
    // Setup TableView
    private func setupTableView() {
        todoListTableView.translatesAutoresizingMaskIntoConstraints = false
        todoListTableView.dataSource = self
        todoListTableView.delegate = self
        
        // Register the custom cell
        todoListTableView.register(TodoListCell.self, forCellReuseIdentifier: "TodoListCell")
        view.addSubview(todoListTableView)
    }
    
    // Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            headerStackView.heightAnchor.constraint(equalToConstant: 55),
            
            progressStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
            progressStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            progressStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            progressStackView.heightAnchor.constraint(equalToConstant: 50),
            
            progressView.widthAnchor.constraint(equalTo: progressStackView.widthAnchor, multiplier: 0.8), // 너비 설정
            progressView.centerXAnchor.constraint(equalTo: progressStackView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: progressStackView.centerYAnchor),
            
            todoListTableView.topAnchor.constraint(equalTo: progressStackView.bottomAnchor, constant: 10),
            todoListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            todoListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            todoListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as? TodoListCell else {
            return UITableViewCell()
        }
        
        let todoItem = todoItems[indexPath.row]
        cell.configure(with: todoItem) // 커스텀 셀에 데이터를 설정
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    // UITableViewDelegate 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = todoItems[indexPath.row]
        showDetailPopup(for: selectedItem)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 팝업을 보여주는 메서드
    private func showDetailPopup(for item: TodoItem) {
        // 팝업 뷰 생성
        let popupView = UIView()
        popupView.backgroundColor = UIColor.white
        popupView.layer.cornerRadius = 10
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(popupView)
        
        // 팝업 레이블 생성
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        popupView.addSubview(titleLabel)
        
        // 팝업 닫기 버튼 추가
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        
        popupView.addSubview(closeButton)
        
        // 팝업의 Auto Layout 설정
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalToConstant: 300),
            popupView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            
            closeButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20),
            closeButton.centerXAnchor.constraint(equalTo: popupView.centerXAnchor)
        ])
        
        // 팝업 애니메이션
        popupView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            popupView.alpha = 1
            self.backgroundView.alpha = 0.7
        }
    }
    
    // 팝업을 닫는 메서드
    @objc private func dismissPopup() {
        guard let popupView = view.subviews.last else { return }
        
        // 애니메이션으로 팝업 닫기
        UIView.animate(withDuration: 0.3, animations: {
            popupView.alpha = 0
            self.backgroundView.alpha = 0 // 배경도 함께 사라짐
        }) { _ in
            popupView.removeFromSuperview() // 팝업 제거
            self.backgroundView.alpha = 0 // 배경 뷰는 남겨둠
        }
    }
    
    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: todoListTableView)
            guard let indexPath = todoListTableView.indexPathForRow(at: location) else { return }
            
            var selectedItem = todoItems[indexPath.row]
            
            // 완료 여부 토글 및 셀 애니메이션
            selectedItem.isCompleted.toggle()
            todoItems[indexPath.row] = selectedItem
            
            if let cell = todoListTableView.cellForRow(at: indexPath) {
                UIView.animate(withDuration: 0.3) {
                    cell.backgroundColor = selectedItem.isCompleted ? .green.withAlphaComponent(0.5) : UIColor.red.withAlphaComponent(0.5) // 상태에 따라 색상 변경
                }
            }

            todoListTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

