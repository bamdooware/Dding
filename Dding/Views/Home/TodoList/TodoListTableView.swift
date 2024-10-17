//
//  TodoListTableView.swift
//  Dding
//
//  Created by 이지은 on 10/12/24.
//

import UIKit

protocol TodoListInteractionDelegate: AnyObject {
    func didSelectTodoItem(_ item: TodoItem)
    func didLongPressTodoItem(_ item: TodoItem)
}

class TodoListTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    var todoItems: [TodoItem] = [
        TodoItem(title: "test1", isCompleted: true, dueDate: Date(), reminderTime: 10, completionCheckTime: 10, tag: "test", memo: "test memo"),
        TodoItem(title: "test2", isCompleted: true, dueDate: Date(), reminderTime: 10, completionCheckTime: 10, tag: "test", memo: "test memo"),
        TodoItem(title: "test3", isCompleted: false, dueDate: Date(), reminderTime: 10, completionCheckTime: 10, tag: "test", memo: "test memo")
    ]

    var todayItems: [TodoItem] {
        return todoItems.filter { Calendar.current.isDateInToday($0.dueDate) }
    }

    let heightForCell: CGFloat = 50.0

    init() {
        super.init(frame: .zero, style: .plain)
        setupTableView()
        setupLongPressGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        self.register(TodoListCell.self, forCellReuseIdentifier: "TodoListCell")
        self.separatorStyle = .singleLine
        self.separatorColor = .clear
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoListCell
        let item = todayItems[indexPath.row]
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }

    // UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForCell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeaderView()
    }

    weak var interactionDelegate: TodoListInteractionDelegate?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = todayItems[indexPath.row]
        interactionDelegate?.didSelectTodoItem(selectedItem)  // 이벤트 위임
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.addGestureRecognizer(longPressGesture)
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: self)
            guard let indexPath = indexPathForRow(at: location) else { return }
            let selectedItem = todayItems[indexPath.row]
            interactionDelegate?.didLongPressTodoItem(selectedItem) // delegate 호출
        }
    }

    private func setupHeaderView() -> UIView {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "할 일 목록"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)

        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        return headerView
    }
}
