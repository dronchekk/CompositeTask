//
//  TaskListViewController.swift
//  CompositeTask
//
//  Created by Andrey Rachitskiy on 03.03.2022.
//

import UIKit

class TaskListViewController: UIViewController {

    private var backButton: UIButton!
    private var plusButton: UIButton!

    private var wrapperView: UIView = {
        return UIView(frame: .zero)
    }()
    private var titleLabel: UILabel = {
        return UILabel(frame: .zero)
    }()
    private var subtitleLabel: UILabel = {
        return UILabel(frame: .zero)
    }()
    private var childTaskCountLabel: UILabel = {
        return UILabel(frame: .zero)
    }()

    private var tableView: UITableView = {
        return UITableView(frame: .zero, style: .plain)
    }()

    private let manager: DataManager = DataManager(root: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.isHidden = manager.curruntTask?.parantTask == nil
        reload()
    }
}

private extension TaskListViewController {

    func setupView() {
        title = "Список задач"

        let safe: UIEdgeInsets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero

        setupWrapperView(safeAreaInsets: safe)
        setupTableView(safeAreaInsets: safe)
        setupNavBarItems()
    }

    func setupNavBarItems() {
        let backButton = UIButton(type: .custom)
        backButton.backgroundColor = .clear
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = .blue
        backButton.addTarget(self, action: #selector(didTouchBackButton(_:)), for: .touchUpInside)

        let backItem = UIBarButtonItem(customView: backButton)
        navigationItem.setLeftBarButtonItems([backItem], animated: true)
        self.backButton = backButton

        let addButton = UIButton(frame: .zero)
        addButton.backgroundColor = .clear
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .blue
        addButton.addTarget(self, action: #selector(didTouchPlusButton(_:)), for: .touchUpInside)

        let addItem = UIBarButtonItem(customView: addButton)
        navigationItem.setRightBarButtonItems([addItem], animated: true)
        plusButton = addButton
    }

    @objc
    func didTouchBackButton(_ button: UIButton) {
        guard let currentTask = manager.curruntTask else { return }
        manager.curruntTask = currentTask.parantTask
        backButton.isHidden = manager.curruntTask?.parantTask == nil
        reload()
    }

    @objc
    func didTouchPlusButton(_ button: UIButton) {

        let adding = AddTaskViewController(dataManager: manager)
        adding.closeHandler = { [weak self] in
            guard let self = self else { return }
            self.backButton.isHidden = self.manager.curruntTask?.parantTask == nil
            self.reload()
        }
        present(adding, animated: true, completion: nil)
    }

    func setupWrapperView(safeAreaInsets: UIEdgeInsets) {
        wrapperView.backgroundColor = .clear
        view.addSubview(wrapperView)
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wrapperView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70.0),
            wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: safeAreaInsets.left),
            wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -safeAreaInsets.right)
        ])

        setupTitleLabel()
        setupSubtitleLabel()
        setupTaskCountLabel()
    }

    func setupTitleLabel() {
        titleLabel.numberOfLines = 3
        titleLabel.text = "Root task title:"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        wrapperView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 32.0),
            titleLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16.0)
        ])
    }

    func setupSubtitleLabel() {
        subtitleLabel.numberOfLines = 3
        subtitleLabel.text = "Root task description:"
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        wrapperView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16.0)
        ])
    }

    func setupTaskCountLabel() {
        childTaskCountLabel.numberOfLines = 1
        childTaskCountLabel.text = "Кол-во: "
        childTaskCountLabel.translatesAutoresizingMaskIntoConstraints = false

        wrapperView.addSubview(childTaskCountLabel)
        NSLayoutConstraint.activate([
            childTaskCountLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12.0),
            childTaskCountLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16.0),
            childTaskCountLabel.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -8.0),
            childTaskCountLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16.0)
        ])
    }

    func setupTableView(safeAreaInsets: UIEdgeInsets) {
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 57.0
        tableView.separatorStyle = .none

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.register(UINib(nibName: String(describing: TaskTableViewCell.self), bundle: .main),
                           forCellReuseIdentifier: String(describing: TaskTableViewCell.self))

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: wrapperView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: safeAreaInsets.left),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -safeAreaInsets.bottom),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -safeAreaInsets.right)
        ])

        tableView.delegate = self
        tableView.dataSource = self
    }

    func reload() {
        titleLabel.text = "Root task title:" + "\n" + (manager.curruntTask?.nameText ?? "-")
        subtitleLabel.text = "Root task description:" + "\n" + (manager.curruntTask?.descriptionText ?? "-")
        childTaskCountLabel.text = "Кол-во дочерних задач: " + "\(manager.curruntTask?.childTaskList.count ?? 0)"

        backButton.isHidden = self.manager.curruntTask?.parantTask == nil

        tableView.reloadData()
    }
}

extension TaskListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (manager.curruntTask?.childTaskList.count ?? 0) > indexPath.item,
              let selectedTask = manager.curruntTask?.childTaskList[indexPath.item]
        else { return }
        manager.curruntTask = selectedTask
        reload()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
}

extension TaskListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.curruntTask?.childTaskList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard (manager.curruntTask?.childTaskList.count ?? 0) > indexPath.item,
              let task = manager.curruntTask?.childTaskList[indexPath.item]
        else {
            return tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskTableViewCell.self),
                                                 for: indexPath) as! TaskTableViewCell
        cell.nameLabel.text = "Task title:" + "\n" + task.nameText
        cell.descriptionLabel.text = "Task description:" + "\n" + task.descriptionText

        return cell
    }
}
