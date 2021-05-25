//
//  MemeTableViewCell.swift
//  MemeMe 1.0
//
//  Created by Meemi on 25/05/2021.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    @IBOutlet var topText: UILabel!
    @IBOutlet var bottomText: UILabel!
    @IBOutlet var memeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
