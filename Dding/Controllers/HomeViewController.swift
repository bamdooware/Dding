//
//  HomeViewController.swift
//  Dding
//
//  Created by 이지은 on 9/30/24.
//

import UIKit

class HomeViewController: UIViewController, TodoListInteractionDelegate, AddButtonViewDelegate, TodoDetailViewDelegate {
    
    private var todoItems: [TodoItem] = []
    private var filteredTodoItems: [TodoItem] = []
    
    // MARK: - UI Components
    private let headerStackView = HeaderStackView()
    private let progressStackContainerView = UIView()
    private let progressStackView = ProgressStackView()
    private let todoListContainerView = UIView() // 새 컨테이너 뷰
    private let todoListTableView = TodoListTableView()
    private let addButtonView = AddButtonView()
    private let newTodoView = NewTodoView()
    private var todoDetailView: TodoDetailView?
    private var blurEffectView: UIVisualEffectView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        configureViews()
        configureDelegates()
        setupConstraints()
        loadData()
        filterAndSortTodoItems()
        updateTableView()
        updateProgressView()
    }
    
    private func loadData() {
        todoItems = [
            TodoItem(id: UUID(), title: "Morning Run", repeatDays: [2, 4, 6, 7], todoTime: DateComponents(hour: 6, minute: 0), isCompleted: false, reminderTime: 15, completionCheckTime: 10, tag: "Health", memo: "Run 5km"),
            TodoItem(id: UUID(), title: "Team Meeting", repeatDays: [2, 3, 4, 7], todoTime: DateComponents(hour: 10, minute: 0), isCompleted: false, reminderTime: 10, completionCheckTime: 5, tag: "Work", memo: "Discuss Q4 goals"),
            TodoItem(id: UUID(), title: "Lunch with Client", repeatDays: [2, 5, 7], todoTime: DateComponents(hour: 12, minute: 30), isCompleted: false, reminderTime: 20, completionCheckTime: 10, tag: "Work", memo: "Client feedback session"),
            TodoItem(id: UUID(), title: "Read Book", repeatDays: [1, 3, 5, 7], todoTime: DateComponents(hour: 20, minute: 0), isCompleted: true, reminderTime: 10, completionCheckTime: 10, tag: "Personal", memo: "Read 'Atomic Habits'"),
            TodoItem(id: UUID(), title: "Yoga Session", repeatDays: [1, 3, 6], todoTime: DateComponents(hour: 18, minute: 0), isCompleted: false, reminderTime: 15, completionCheckTime: 5, tag: "Health", memo: "Practice advanced poses")
        ]
    }
    
    private func filterAndSortTodoItems() {
        let today = Calendar.current.component(.weekday, from: Date())
        filteredTodoItems = todoItems
            .filter { $0.repeatDays.contains(today) }
            .sorted {
                ($0.todoTime.hour ?? 0, $0.todoTime.minute ?? 0) < ($1.todoTime.hour ?? 0, $1.todoTime.minute ?? 0)
            }
    }
    
    func didAddNewTodoItem(_ newItem: TodoItem) {
        todoItems.append(newItem)
        filterAndSortTodoItems()
        updateTableView()
        updateProgressView()
    }
    
    private func updateTableView() {
        todoListTableView.todoItems = filteredTodoItems
        todoListTableView.reloadData()
    }
    
    // MARK: - View Configuration
    private func configureViews() {
        [headerStackView, progressStackView, progressStackContainerView, todoListContainerView, addButtonView].forEach { view.addSubview($0) }

        todoListContainerView.layer.cornerRadius = 15
        todoListContainerView.clipsToBounds = true
        todoListContainerView.addSubview(todoListTableView)
        
        progressStackContainerView.layer.cornerRadius = 15
        progressStackView.clipsToBounds = true
        progressStackContainerView.addSubview(progressStackView)
        
        updateProgressView()
        setupNewTodoViewActions()
    }
    
    private func configureDelegates() {
        todoListTableView.interactionDelegate = self
        addButtonView.delegate = self
    }
    
    // MARK: - Blur Effect
    private func showBlurEffect() {
        guard blurEffectView == nil else { return }
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        view.addSubview(blurEffectView)
        UIView.animate(withDuration: 0.3) { blurEffectView.alpha = 0.6 }
        self.blurEffectView = blurEffectView
    }
    
    private func hideBlurEffect() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurEffectView?.alpha = 0
        }) { _ in
            self.blurEffectView?.removeFromSuperview()
            self.blurEffectView = nil
        }
    }
    
    // MARK: - Add New Todo
    private func setupNewTodoViewActions() {
        newTodoView.confirmButtonTapped = { [weak self] in self?.confirmNewTodoView() }
        newTodoView.closeButtonTapped = { [weak self] in self?.closeNewTodoView() }
    }
    
    @objc private func closeNewTodoView() {
        hideBlurEffect()
        tabBarController?.tabBar.isHidden = false
        newTodoView.fadeOut()
    }
    
    @objc private func confirmNewTodoView() {
        guard let title = newTodoView.titleTextField.text, !title.isEmpty else {
            print("제목이 입력되지 않았습니다.")
            return
        }
        
        let todo = createNewTodoItem(from: title)
        todoListTableView.todoItems.append(todo)
        todoListTableView.reloadData()
        updateProgressView()
        closeNewTodoView()
        didAddNewTodoItem(todo)
    }
    
    private func createNewTodoItem(from title: String) -> TodoItem {
        let todoTime = newTodoView.todoTimePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: todoTime)
        
        return TodoItem(
            id: UUID(),
            title: title,
            repeatDays: newTodoView.selectedDays,
            todoTime: components,
            isCompleted: false,
            reminderTime: Int(newTodoView.reminderTimePicker.countDownDuration),
            completionCheckTime: Int(newTodoView.completionTimePicker.countDownDuration),
            tag: "Add test",
            memo: newTodoView.memoTextField.text ?? "null"
        )
    }
    
    // MARK: - Progress View
    private func updateProgressView() {
        let completedTask = todoListTableView.todoItems.filter { $0.isCompleted }.count
        let totalTask = todoListTableView.todoItems.count
        let progress = totalTask > 0 ? Float(completedTask) / Float(totalTask) : 0
        
        progressStackView.updateProgress(completedTask: completedTask, totalTask: totalTask)
        progressStackView.progressView.setProgress(progress, animated: true)
    }
    
    // MARK: - TodoListInteractionDelegate
    func didSelectTodoItem(_ item: TodoItem) {
        let detailView = TodoDetailView()
        detailView.configure(with: item)
        showDetailView(detailView)
    }
    
    func didLongPressTodoItem(_ item: TodoItem) {
        if let index = todoListTableView.todoItems.firstIndex(where: { $0.id == item.id }) {
            todoListTableView.todoItems[index].isCompleted.toggle()
            todoListTableView.reloadRows(at: [IndexPath(row: index * 2, section: 0)], with: .automatic)
            updateProgressView()
        }
    }
    
    // MARK: - Detail View Management
    private func showDetailView(_ detailView: TodoDetailView) {
        tabBarController?.tabBar.isHidden = true
        showBlurEffect()
        
        detailView.delegate = self
        todoDetailView = detailView
        
        addSubviewToRootWindow(detailView)
        detailView.fadeIn()
    }
    
    func didTapCloseButton() {
        hideBlurEffect()
        tabBarController?.tabBar.isHidden = false
        todoDetailView?.fadeOut()
    }
    
    // MARK: - Add Button View Delegate
    func didTapAddButton() {
        showBlurEffect()
        tabBarController?.tabBar.isHidden = true
        addSubviewToRootWindow(newTodoView)
        newTodoView.fadeIn()
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
//        progressStackView.translatesAutoresizingMaskIntoConstraints = false
        progressStackContainerView.translatesAutoresizingMaskIntoConstraints = false
        todoListContainerView.translatesAutoresizingMaskIntoConstraints = false
        todoListTableView.translatesAutoresizingMaskIntoConstraints = false
        addButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            headerStackView.heightAnchor.constraint(equalToConstant: 55),
            
            progressStackContainerView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
            progressStackContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            progressStackContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            progressStackContainerView.heightAnchor.constraint(equalToConstant: 70),
            
            todoListContainerView.topAnchor.constraint(equalTo: progressStackView.bottomAnchor, constant: 25),
            todoListContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            todoListContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            todoListContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            todoListTableView.topAnchor.constraint(equalTo: todoListContainerView.topAnchor),
            todoListTableView.leadingAnchor.constraint(equalTo: todoListContainerView.leadingAnchor),
            todoListTableView.trailingAnchor.constraint(equalTo: todoListContainerView.trailingAnchor),
            todoListTableView.bottomAnchor.constraint(equalTo: todoListContainerView.bottomAnchor),
            
            addButtonView.widthAnchor.constraint(equalToConstant: 50),
            addButtonView.heightAnchor.constraint(equalToConstant: 50),
            addButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            addButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            todoListTableView.topAnchor.constraint(equalTo: progressStackView.bottomAnchor, constant: 10),
            todoListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            todoListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            todoListTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    // MARK: - Utility
    private func addSubviewToRootWindow(_ view: UIView) {
        guard let rootWindow = UIApplication.shared.windows.first else { return }
        
        rootWindow.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: rootWindow.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: rootWindow.centerYAnchor),
            view.widthAnchor.constraint(equalToConstant: 300),
            view.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
}

// MARK: - UIView Extension
extension UIView {
    func fadeIn(duration: TimeInterval = 0.3) {
        alpha = 0
        UIView.animate(withDuration: duration) { self.alpha = 1 }
    }
    
    func fadeOut(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { self.alpha = 0 }, completion: completion)
    }
}
