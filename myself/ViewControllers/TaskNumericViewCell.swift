//
//  TaskTableViewCell.swift
//  myself
//
//  Created by Kemal Taskin on 30.11.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import UIKit

class TaskNumericViewCell: UITableViewCell {

    @IBOutlet weak var lblLabel: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var imgMinus: UIImageView!
    
    public var entry: Entry?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
