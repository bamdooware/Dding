//
//  RoutineListView.swift
//  Dding
//
//  Created by 이지은 on 11/23/24.
//

import UIKit

protocol RoutineListViewDelegate: AnyObject {
    func didSelectRoutineItem(_ routineItem: RoutineItem)
    func didLongPressRoutineItem(_ routineItem: RoutineItem)
    func didTapAddButton()
    func didTapFixButton()
    func deleteRoutineItem(at indexPath: IndexPath)
    func showAlertForRoutineItem(_ routineItem: RoutineItem, completion: @escaping (Bool) -> Void)
}

class RoutineListView: UIView {
    weak var interactionDelegate: RoutineListViewDelegate?
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var routines: [RoutineItem] = []
    
    init(title: String) {
        super.init(frame: .zero)
        setupUI()
        setupLongPressGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateRoutines(_ routines: [RoutineItem]) {
        self.routines = routines
        tableView.reloadData()
    }
    
    func updateRoutineItem(at indexPath: IndexPath, with routine: RoutineItem) {
        guard indexPath.row < routines.count else { return }
        routines[indexPath.row] = routine
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func deleteRoutineItem(at indexPath: IndexPath) {
        guard indexPath.row < routines.count else { return }
        routines.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    private func setupUI() {
        tableView.backgroundColor = .systemBackground
        tableView.sectionHeaderTopPadding = 0
        tableView.register(RoutineCell.self, forCellReuseIdentifier: RoutineCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupLongPressGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let touchPoint = gesture.location(in: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: touchPoint), indexPath.row < routines.count {
            let selectedItem = routines[indexPath.row]
            interactionDelegate?.didLongPressRoutineItem(selectedItem)
        }
    }
    
    @objc private func didTapAddButton() {
        interactionDelegate?.didTapAddButton()
    }
}

extension RoutineListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoutineCell.identifier, for: indexPath) as! RoutineCell
        cell.configure(with: routines[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemIndex = indexPath.row
        guard itemIndex < routines.count else { return }
        let selectedItem = routines[itemIndex]
        tableView.deselectRow(at: indexPath, animated: true)
        interactionDelegate?.didSelectRoutineItem(selectedItem)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < routines.count else { return nil }
        let routineItem = routines[indexPath.row]
        
        let fixAction = UIContextualAction(style: .destructive, title: routineItem.isFixed ? "고정 해제" : "고정") { [weak self] _, _, completionHandler in
            self?.interactionDelegate?.didTapFixButton()
            completionHandler(true)
        }
        fixAction.backgroundColor = .systemYellow
        
        return UISwipeActionsConfiguration(actions: [fixAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < routines.count else { return nil }
        let routineItem = routines[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            self.interactionDelegate?.showAlertForRoutineItem(routineItem) { shouldDelete in
                if shouldDelete {
                    self.interactionDelegate?.deleteRoutineItem(at: indexPath)
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension RoutineListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear

        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.setTitle("  추가하기", for: .normal)
        addButton.tintColor = .systemBlue
        addButton.setTitleColor(.systemBlue, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)

        footerView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            addButton.widthAnchor.constraint(equalToConstant: 160)
        ])
        return footerView
    }
}
