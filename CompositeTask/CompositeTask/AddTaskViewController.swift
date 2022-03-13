//
//  AddTaskViewController.swift
//  CompositeTask
//
//  Created by Andrey Rachitskiy on 09.03.2022.
//

import UIKit

class AddTaskViewController: UIViewController {

    var dataManager: DataManager
    var titleTextField: UITextField
    var subTitleTextField: UITextField
    var addButton: UIButton

    var closeHandler: (() -> ())?

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.titleTextField = UITextField.init(frame: .zero)
        self.subTitleTextField = UITextField.init(frame: .zero)
        self.addButton = UIButton.init(type: .custom)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }

    func setupView() {
        view.backgroundColor = .white
        view.addSubview(titleTextField)
        view.addSubview(subTitleTextField)

        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "Введите название задач"
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 70.0),
        titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
        titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
        titleTextField.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        subTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        subTitleTextField.placeholder = "Введите цели задачи"
        NSLayoutConstraint.activate([
            subTitleTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24.0),
            subTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            subTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            subTitleTextField.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        titleTextField.backgroundColor = .black.withAlphaComponent(0.15)
        subTitleTextField.backgroundColor = .black.withAlphaComponent(0.15)
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: subTitleTextField.bottomAnchor, constant: 24.0),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        addButton.setTitle("Add task", for: .normal)
        addButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        addButton.setTitleColor(.black, for: .normal)
    }

    @objc func tapButton() {
        let task = TaskModel(nameText: titleTextField.text ?? "-", descriptionText: subTitleTextField.text ?? "-")
        dataManager.addTask(task)
        dismiss(animated: true, completion: nil)
        closeHandler?()
    }
}

