//
//  ViewController.swift
//  CompositeTask
//
//  Created by Andrey Rachitskiy on 27.02.2022.
//

import UIKit

class ViewController: UIViewController {

    private var navController: UINavigationController = {
        return UINavigationController()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildController(navController)
        let viewController = TaskListViewController()
        navController.pushViewController(viewController, animated: true)
    }

    func addChildController(_ controller: UIViewController) {
        controller.willMove(toParent: self)
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
