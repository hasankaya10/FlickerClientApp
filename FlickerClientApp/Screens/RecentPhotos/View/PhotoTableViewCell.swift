//
//  PhotoTableViewCell.swift
//  FlickerClientApp
//
//  Created by Hasan Kaya on 20.07.2022.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        ownerImageView.layer.cornerRadius = 24.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
