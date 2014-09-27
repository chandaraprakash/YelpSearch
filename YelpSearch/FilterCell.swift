//
//  FilterCell.swift
//  YelpSearch
//
//  Created by Kumar, Chandaraprakash on 9/25/14.
//  Copyright (c) 2014 chantech. All rights reserved.
//

import UIKit

protocol FilterCellDelegate {
    func filterCell(filterSwitchCell: FilterCell, didChangeValue value: Bool) -> Void
}

class FilterCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    
    var delegate: FilterCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwitchChanged(sender: AnyObject) {
        delegate?.filterCell(self, didChangeValue: filterSwitch.on)
    }
}
