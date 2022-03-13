//
//  DataModel.swift
//  CompositeTask
//
//  Created by Andrey Rachitskiy on 03.03.2022.
//

import Foundation

class TaskModel {

    var nameText: String
    var descriptionText: String

    weak var parantTask: TaskModel?
    var childTaskList: [TaskModel] = []

    init(nameText: String, descriptionText: String, parant task: TaskModel?, childTask list: [TaskModel]) {
        self.nameText = nameText
        self.descriptionText = descriptionText
        self.parantTask = task
        self.childTaskList = list
    }

    init(nameText: String, descriptionText: String) {
        self.nameText = nameText
        self.descriptionText = descriptionText
    }
}

class DataManager {

    var rootTask: TaskModel?

    weak var curruntTask: TaskModel?

    /// Для перекладки задач из одного UI в другой UI
    var newTask: TaskModel? {
        didSet {
            guard let model = newTask else { return }
            addTask(model)
        }
    }

    init(root task: TaskModel?) {
        self.rootTask = task
    }

    func addTask(_ task: TaskModel) {
        if rootTask == nil {
            rootTask = task
            curruntTask = task
        } else {
            task.parantTask = curruntTask
            curruntTask?.childTaskList.append(task)
        }
        newTask = nil
    }
}

