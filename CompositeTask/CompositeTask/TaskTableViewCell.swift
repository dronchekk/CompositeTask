//
//  TaskTableViewCell.swift
//  CompositeTask
//
//  Created by Andrey Rachitskiy on 11.03.2022.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

private extension TaskTableViewCell {

    func setupView() {
        separatorView.backgroundColor = .black
    }
}
