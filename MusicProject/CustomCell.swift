//
//  CustomCell.swift
//  MusicProject
//
//  Created by Ilan Zerdoun on 04/04/2019.
//  Copyright © 2019 Ilan Zerdoun. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var deleteFav: UIButton!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var imageAlbum: UIImageView!
    @IBOutlet weak var favoritesButton: UIButton!
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
