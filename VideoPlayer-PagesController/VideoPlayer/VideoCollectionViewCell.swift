//
//  VideoCollectionViewCell.swift
//  VideoPlayer
//
//  Created by Arjuna on 5/31/21.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        self.thumbnailImageView.layer.cornerRadius = 10
    }
}
