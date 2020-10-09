//
//  SongTableViewCell.swift
//  CPlayer
//
//  Created by Cedric Bahirwe on 10/9/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songAuthor: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        songImage.layer.cornerRadius = self.songImage.frame.height / 2
        songImage.layer.shadowColor = UIColor.white.cgColor
        songImage.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        songImage.layer.shadowRadius = 2.5
        songImage.layer.shadowOpacity = 0.6
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
