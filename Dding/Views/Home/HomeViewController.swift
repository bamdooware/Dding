//
//  HomeViewController.swift
//  Dding
//
//  Created by 이지은 on 9/30/24.
//

import UIKit

class HomeViewController: UIViewController, TodoListInteractionDelegate {
    
    let headerStackView = HeaderStackView()
    let progressStackView = ProgressStackView()
    let todoListTableView = TodoListTableView()
    let addButtonView = AddButtonView()
    let newTodoView = NewTodoView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        setupHeaderStackView()
        setupProgressStackView()
        setupAddButtonView()
        setupTodoListTableView()
        setupNewTodoConfirmButton()
        setupNewTodoCloseButton()
        
        setupConstraints()
    }
    
    private func setupHeaderStackView() {
        view.addSubview(headerStackView)
    }
    
    private func setupProgressStackView() {
        view.addSubview(progressStackView)
        updateProgressView()
    }
    
    private func updateProgressView() {
        let completedTask = todoListTableView.todoItems.filter { $0.isCompleted }.count
        let totalTask = todoListTableView.todoItems.count
        let progress = totalTask > 0 ? Float(completedTask) / Float(totalTask) : 0
        progressStackView.progressView.setProgress(progress, animated: true)
    }
    
    private func setupTodoListTableView() {
        todoListTableView.interactionDelegate = self
        view.addSubview(todoListTableView)
    }
    
    func didSelectTodoItem(_ item: TodoItem) {
        let detailView = TodoDetailView()
        detailView.configure(with: item)
        showDetailView(detailView)
    }
    
    private func showDetailView(_ detailView: TodoDetailView) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.addSubview(detailView)
            detailView.translatesAutoresizingMaskIntoConstraints = false
            
            detailView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                detailView.alpha = 1
            }
            
            NSLayoutConstraint.activate([
                detailView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                detailView.centerYAnchor.constraint(equalTo: window.centerYAnchor),
                detailView.widthAnchor.constraint(equalToConstant: 300),
                detailView.heightAnchor.constraint(equalToConstant: 400)
            ])
        }
    }
    
    func didLongPressTodoItem(_ item: TodoItem) {
        if let index = todoListTableView.todoItems.firstIndex(where: { $0.title == item.title }) {
            todoListTableView.todoItems[index].isCompleted.toggle()
            todoListTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            updateProgressView()
        }
    }

    private func setupAddButtonView() {
        view.addSubview(addButtonView)
        addButtonView.buttonTapped = { [weak self] in
            guard let self = self else { return }
            self.showNewTodoView()
        }
    }
    
    private func setupNewTodoConfirmButton() {
        newTodoView.confirmButtonTapped = { [weak self] in
            self?.confirmNewTodoView()
        }
    }
    
    private func setupNewTodoCloseButton() {
        newTodoView.closeButtonTapped = { [weak self] in
            self?.closeNewTodoView()
        }
    }
    
    @objc func showNewTodoView() {
        print("touch up add button")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.addSubview(newTodoView)
            newTodoView.translatesAutoresizingMaskIntoConstraints = false
            newTodoView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.newTodoView.alpha = 1
            }
            
            NSLayoutConstraint.activate([
                newTodoView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                newTodoView.centerYAnchor.constraint(equalTo: window.centerYAnchor),
                newTodoView.widthAnchor.constraint(equalToConstant: 300),
                newTodoView.heightAnchor.constraint(equalToConstant: 400)
            ])
        }
    }
    
    @objc func closeNewTodoView() {
        print("touch up close button")
        
        NewTodoView.animate(withDuration: 0.3, animations: {
            self.newTodoView.alpha = 0
        }) { _ in
            self.newTodoView.removeFromSuperview()
        }
    }
    
    @objc func confirmNewTodoView() {
        print("touch up confirm button")
        guard let title = newTodoView.titleTextField.text, !title.isEmpty else {
            print("제목이 입력되지 않았습니다.")
            return
        }
        let dueDate = newTodoView.dueDatePicker.date
        let memo = newTodoView.memo.text ?? "null"
        let todo = TodoItem(title: title, isCompleted: false, dueDate: dueDate,  reminderTime: 0, completionCheckTime: 0, tag: "Add test", memo: memo)
        todoListTableView.todoItems.append(todo)
        
        todoListTableView.reloadData()
        NewTodoView.animate(withDuration: 0.3, animations: {
            self.newTodoView.alpha = 0
        }) { _ in
            self.newTodoView.removeFromSuperview()
        }
        
        updateProgressView()
        print(todoListTableView.todoItems)
    }
    
    private func setupConstraints() {
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        progressStackView.translatesAutoresizingMaskIntoConstraints = false
        addButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            headerStackView.heightAnchor.constraint(equalToConstant: 55),
            
            progressStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
            progressStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            progressStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            progressStackView.heightAnchor.constraint(equalToConstant: 50),
            
            addButtonView.widthAnchor.constraint(equalToConstant: 50),
            addButtonView.heightAnchor.constraint(equalToConstant: 50),
            addButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            addButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            todoListTableView.topAnchor.constraint(equalTo: progressStackView.bottomAnchor, constant: 10),
            todoListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            todoListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            todoListTableView.heightAnchor.constraint(equalToConstant: todoListTableView.heightForCell * CGFloat(todoListTableView.todoItems.count + 3)),
            
        ])
    }
}
