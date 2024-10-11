//
//  HomeViewController.swift
//  Dding
//
//  Created by 이지은 on 9/30/24.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var todoItems: [TodoItem] = [
        TodoItem(title: "test1", isCompleted: true, dueDate: Date(), reminderTime: 10, completionCheckTime: 10, tag: "test", memo: "test memo"),
        TodoItem(title: "test2", isCompleted: true, dueDate: Date(), reminderTime: 10, completionCheckTime: 10, tag: "test", memo: "test memo"),
        TodoItem(title: "test3", isCompleted: false, dueDate: Date(), reminderTime: 10, completionCheckTime: 10, tag: "test", memo: "test memo")
    ]
    var todayItems: [TodoItem] {
        return todoItems.filter { Calendar.current.isDateInToday($0.dueDate) }
    }
    
    let heightForCell = 50.0
    
    let headerStackView = UIStackView()
    let progressStackView = UIStackView()
    let progressView = UIProgressView(progressViewStyle: .bar)
    let todoListTableView = UITableView()
    let addButton = UIButton()
    let backgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .background
        
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        
        setupHeaderStackView()
        setupProgressStackView()
        setupProgressView()
        updateProgressView()
        setupTableView()
        setupAddButton()
        setupConstraints()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        todoListTableView.addGestureRecognizer(longPressGesture)
        
        view.addSubview(backgroundView)
    }
    
    private func setupHeaderStackView() {
        let headerImageView = UIImageView(image: UIImage(systemName: "icloud"))
        headerImageView.contentMode = .scaleAspectFit
        
        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.axis = .horizontal
        headerStackView.distribution = .equalSpacing
        headerStackView.alignment = .center
        headerStackView.backgroundColor = .green
        headerStackView.addArrangedSubview(headerImageView)
        headerStackView.addArrangedSubview(settingsButton)
        view.addSubview(headerStackView)
    }
    
    private func setupProgressStackView() {
        progressStackView.translatesAutoresizingMaskIntoConstraints = false
        progressStackView.axis = .horizontal
        progressStackView.backgroundColor = .systemPink
        view.addSubview(progressStackView)
    }
    
    private func setupProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.3
        progressView.tintColor = .blue
        progressView.trackTintColor = .lightGray
        view.addSubview(progressView)
    }
    
    private func updateProgressView() {
        let totalTodoCount = todayItems.count
        let completedTodoCount = todayItems.lazy.filter({ $0.isCompleted }).count
        let progress = totalTodoCount > 0 ? Float(completedTodoCount)/Float(totalTodoCount) : 0
        progressView.setProgress(progress, animated: true)
    }
    
    private func setupTableView() {
        todoListTableView.translatesAutoresizingMaskIntoConstraints = false
        todoListTableView.dataSource = self
        todoListTableView.delegate = self
        todoListTableView.register(TodoListCell.self, forCellReuseIdentifier: "TodoListCell")
        
        todoListTableView.backgroundColor = .none
        todoListTableView.separatorStyle = .singleLine
        todoListTableView.separatorColor = .clear // 구분선을 투명하게 설정
        
        view.addSubview(todoListTableView)
    }
    
    private func setupAddButton () {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        addButton.backgroundColor = .brown
        addButton.layer.cornerRadius = 25
        
        addButton.addTarget(self, action: #selector(addNewTodoItem), for: .touchUpInside)
        
        view.addSubview(addButton)
    }
    
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
            
            progressView.centerXAnchor.constraint(equalTo: progressStackView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: progressStackView.centerYAnchor),
            progressView.widthAnchor.constraint(equalTo: progressStackView.widthAnchor, multiplier: 0.8),
            progressView.heightAnchor.constraint(equalToConstant: 5),
            
            todoListTableView.topAnchor.constraint(equalTo: progressStackView.bottomAnchor, constant: 10),
            todoListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            todoListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            todoListTableView.heightAnchor.constraint(equalToConstant: heightForCell*CGFloat(todoItems.count + 3)),
            
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayItems.count
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
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .none
        cell.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as? TodoListCell else {
            return UITableViewCell()
        }
        
        let item = todayItems[indexPath.row]
        cell.configure(with: item)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = todoItems[indexPath.row]
        showDetailPopup(for: selectedItem)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func showDetailPopup(for item: TodoItem) {
        hideKeyboard()
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.alpha = 0
        } completion: { _ in
            self.tabBarController?.tabBar.isHidden = true
        }
        
        let popupView: UIView = {
            let popupView = UIView()
            popupView.backgroundColor = UIColor.white
            popupView.layer.cornerRadius = 10
            
            return popupView
        }()
        
        let totalStackView: UIStackView = {
            let totalStackView = UIStackView()
            totalStackView.axis = .vertical
            totalStackView.distribution = .equalSpacing
            
            return totalStackView
        }()
        
        let titleLabel: UILabel = {
            let titleLabel = UILabel()
            titleLabel.text = item.title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.textColor = .black
            
            return titleLabel
        }()
        
        let dueDate: UILabel = {
            let dueDate = item.dueDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 원하는 날짜 형식을 지정
            let dateString = dateFormatter.string(from: dueDate)
            let dueDateLabel = UILabel()
            dueDateLabel.text = dateString
            dueDateLabel.textColor = .black
            
            return dueDateLabel
        }()
        
        let timeStackView: UIStackView = {
            let timeStackView = UIStackView()
            timeStackView.axis = .horizontal
            timeStackView.distribution = .equalSpacing
            
            return timeStackView
        }()
        
        let reminderTime: UILabel = {
            let time = UILabel()
            time.text = String(item.reminderTime)
            time.textColor = .black
            
            return time
        }()
        
        let completionCheckTime: UILabel = {
            let time = UILabel()
            time.text = String(item.completionCheckTime)
            time.textColor = .black
            
            return time
        }()
        
        let memo: UILabel = {
            let memo = UILabel()
            memo.text = String(item.memo)
            memo.textColor = .black
            
            return memo
        }()
        
        view.addSubview(popupView)
        popupView.addSubview(totalStackView)
        totalStackView.addSubview(titleLabel)
        totalStackView.addSubview(dueDate)
        totalStackView.addSubview(timeStackView)
        timeStackView.addArrangedSubview(reminderTime)
        timeStackView.addArrangedSubview(completionCheckTime)
        totalStackView.addSubview(memo)

        popupView.translatesAutoresizingMaskIntoConstraints = false
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dueDate.translatesAutoresizingMaskIntoConstraints = false
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        reminderTime.translatesAutoresizingMaskIntoConstraints = false
        completionCheckTime.translatesAutoresizingMaskIntoConstraints = false
        memo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("닫기", for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        
        popupView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalToConstant: 300),
            popupView.heightAnchor.constraint(equalToConstant: 500),
            
            totalStackView.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 10),
            totalStackView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 10),
            totalStackView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: 10),
            totalStackView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: 10),

            titleLabel.topAnchor.constraint(equalTo: totalStackView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: totalStackView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            dueDate.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            dueDate.centerXAnchor.constraint(equalTo: totalStackView.centerXAnchor),
            dueDate.widthAnchor.constraint(equalToConstant: 300),
            dueDate.heightAnchor.constraint(equalToConstant: 50),
            
            timeStackView.topAnchor.constraint(equalTo: dueDate.bottomAnchor, constant: 10),
            timeStackView.leadingAnchor.constraint(equalTo: totalStackView.leadingAnchor, constant: 10),
            timeStackView.trailingAnchor.constraint(equalTo: totalStackView.trailingAnchor, constant: 10),
            timeStackView.heightAnchor.constraint(equalToConstant: 50),
            
            memo.topAnchor.constraint(equalTo: timeStackView.bottomAnchor, constant: 10),
            memo.leadingAnchor.constraint(equalTo: timeStackView.leadingAnchor, constant: 10),
            memo.trailingAnchor.constraint(equalTo: timeStackView.trailingAnchor, constant: 10),
            memo.heightAnchor.constraint(equalToConstant: 50),
            
            closeButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20),
            closeButton.centerXAnchor.constraint(equalTo: popupView.centerXAnchor)
        ])
        
        popupView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            popupView.alpha = 1
            self.backgroundView.alpha = 0.7
        }
    }
    
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할 일을 입력해주세요."
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    let dueDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ko-KR")
        
        return datePicker
    }()
    
    let reminderTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        
        return datePicker
    }()
    
    let completionTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        
        return datePicker
    }()

    let memo: UILabel = {
        let memo = UILabel()
        memo.text = String("testmemo")
        memo.textColor = .black
        
        return memo
    }()
    
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.backgroundColor = .cyan
        return stackView
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.addTarget(HomeViewController.showAddTodoPopup, action: #selector(touchUpConfirmButton), for: .touchUpInside)
        button.backgroundColor = .clear
        
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.addTarget(HomeViewController.showAddTodoPopup, action: #selector(dismissPopup), for: .touchUpInside)
        button.backgroundColor = .clear
        
        return button
    }()
    
    func showAddTodoPopup() {
        hideKeyboard()
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.alpha = 0
        } completion: { _ in
            self.tabBarController?.tabBar.isHidden = true
        }
        
        let popupView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 10
            
            return view
        }()
        
        let totalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            
            return stackView
        }()
        
        view.addSubview(popupView)
        popupView.addSubview(totalStackView)
        totalStackView.addSubview(titleTextField)
        totalStackView.addSubview(dueDatePicker)
        totalStackView.addSubview(timeStackView)
        timeStackView.addSubview(reminderTimePicker)
        timeStackView.addSubview(completionTimePicker)
        totalStackView.addSubview(memo)
        totalStackView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(confirmButton)
        buttonStackView.addArrangedSubview(closeButton)

        popupView.translatesAutoresizingMaskIntoConstraints = false
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        dueDatePicker.translatesAutoresizingMaskIntoConstraints = false
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        reminderTimePicker.translatesAutoresizingMaskIntoConstraints = false
        completionTimePicker.translatesAutoresizingMaskIntoConstraints = false
        memo.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalToConstant: 300),
            popupView.heightAnchor.constraint(equalToConstant: 500),
            
            totalStackView.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 10),
            totalStackView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 10),
            totalStackView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: 10),
            totalStackView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: 10),
            
            titleTextField.topAnchor.constraint(equalTo: totalStackView.topAnchor, constant: 20),
            titleTextField.centerXAnchor.constraint(equalTo: totalStackView.centerXAnchor),
            titleTextField.widthAnchor.constraint(equalToConstant: 200),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            dueDatePicker.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            dueDatePicker.centerXAnchor.constraint(equalTo: totalStackView.centerXAnchor),
            dueDatePicker.heightAnchor.constraint(equalToConstant: 50),
            
            timeStackView.topAnchor.constraint(equalTo: dueDatePicker.bottomAnchor, constant: 10),
            timeStackView.leadingAnchor.constraint(equalTo: totalStackView.leadingAnchor, constant: 10),
            timeStackView.trailingAnchor.constraint(equalTo: totalStackView.trailingAnchor, constant: 10),
            timeStackView.heightAnchor.constraint(equalToConstant: 80),
            
            reminderTimePicker.topAnchor.constraint(equalTo: timeStackView.topAnchor),
            reminderTimePicker.leadingAnchor.constraint(equalTo: timeStackView.leadingAnchor, constant: 10),
            reminderTimePicker.trailingAnchor.constraint(equalTo: timeStackView.trailingAnchor, constant: 10),
            reminderTimePicker.heightAnchor.constraint(equalToConstant: 40),
            
            completionTimePicker.bottomAnchor.constraint(equalTo: timeStackView.bottomAnchor),
            completionTimePicker.leadingAnchor.constraint(equalTo: timeStackView.leadingAnchor, constant: 10),
            completionTimePicker.trailingAnchor.constraint(equalTo: timeStackView.trailingAnchor, constant: 10),
            completionTimePicker.heightAnchor.constraint(equalToConstant: 40),

            memo.topAnchor.constraint(equalTo: timeStackView.bottomAnchor, constant: 10),
            memo.leadingAnchor.constraint(equalTo: timeStackView.leadingAnchor, constant: 10),
            memo.trailingAnchor.constraint(equalTo: timeStackView.trailingAnchor, constant: 10),
            memo.heightAnchor.constraint(equalToConstant: 50),
            
            buttonStackView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -10),
            buttonStackView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),

        ])
        
        popupView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            popupView.alpha = 1
            self.backgroundView.alpha = 0.7
        }
    }
    
    @objc private func touchUpConfirmButton() {
        guard let title = titleTextField.text, !title.isEmpty else {
                    print("제목이 입력되지 않았습니다.")
                    return
                }
        let dueDate = dueDatePicker.date
        let memo = memo.text ?? "null"
        let todo = TodoItem(title: title, isCompleted: false, dueDate: dueDate,  reminderTime: 0, completionCheckTime: 0, tag: "Add test", memo: memo)
        todoItems.append(todo)
        
        todoListTableView.reloadData()
        
        guard let popupView = view.subviews.last else { return }
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            popupView.alpha = 0
            self.backgroundView.alpha = 0
            self.tabBarController?.tabBar.alpha = 1
        }) { _ in
            popupView.removeFromSuperview()
        }
    }
    
    @objc private func dismissPopup() {
        guard let popupView = view.subviews.last else { return }
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            popupView.alpha = 0
            self.backgroundView.alpha = 0
            self.tabBarController?.tabBar.alpha = 1
        }) { _ in
            popupView.removeFromSuperview()
        }
    }
    
    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: todoListTableView)
            guard let indexPath = todoListTableView.indexPathForRow(at: location) else { return }
            var selectedItem = todoItems[indexPath.row]
            selectedItem.isCompleted.toggle()
            todoItems[indexPath.row] = selectedItem
            todoListTableView.reloadRows(at: [indexPath], with: .automatic)
            updateProgressView()
        }
    }
    
    @objc private func addNewTodoItem() {
        showAddTodoPopup()
    }
}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
