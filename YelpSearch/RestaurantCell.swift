//
//  RestaurantCell.swift
//  YelpSearch
//
//  Created by Kumar, Chandaraprakash on 9/25/14.
//  Copyright (c) 2014 chantech. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var restaurant : Restaurant! {
        willSet(restaurant) {
            nameLabel.text      = restaurant.name
            categoryLabel.text       = restaurant.categories
            addressLabel.text   = restaurant.address
            reviewLabel.text = String(restaurant.reviewsCount) + " Reviews"
            if let url = restaurant.thumbImage {
                thumbView.setImageWithURL(NSURL(string:  restaurant.thumbImage))
            }
            ratingImageView.setImageWithURL(NSURL(string:  restaurant.ratingImage))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
