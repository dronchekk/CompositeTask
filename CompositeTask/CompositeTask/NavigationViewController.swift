//
//  NavigationViewController.swift
//  CompositeTask
//
//  Created by Andrey Rachitskiy on 09.03.2022.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        view.backgroundColor = .white

        let child = TaskListViewController()
        child.view.backgroundColor = .white

        viewControllers = [child]
    }
}
