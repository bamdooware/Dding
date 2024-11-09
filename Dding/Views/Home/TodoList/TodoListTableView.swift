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
    
    var todoItems: [TodoItem] = []

    let heightForCell: CGFloat = 50.0
    let cellSpacing: CGFloat = 10.0
    
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
        self.separatorStyle = .none
        self.backgroundColor = .white
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (todoItems.count * 2) - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoListCell
            let itemIndex = indexPath.row / 2
            let item = todoItems[itemIndex]
            cell.configure(with: item)
            cell.backgroundColor = .clear
            return cell
        } else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row % 2 == 0 ? heightForCell : cellSpacing
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemIndex = indexPath.row / 2
        guard itemIndex < todoItems.count else { return }
        let selectedItem = todoItems[itemIndex]
        interactionDelegate?.didSelectTodoItem(selectedItem)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    weak var interactionDelegate: TodoListInteractionDelegate?
    
    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: self)
            guard let indexPath = indexPathForRow(at: location), indexPath.row % 2 == 0 else { return }
            let selectedItem = todoItems[indexPath.row / 2]
            interactionDelegate?.didLongPressTodoItem(selectedItem)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    private func setupHeaderView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.text = "할 일 목록"
        label.backgroundColor = UIColor(red: 255, green: 250, blue: 205.0, alpha: 1.0)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
        ])
        return headerView
    }
}
