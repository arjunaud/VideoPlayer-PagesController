//
//  CategoryTableViewCell.swift
//  VideoPlayer
//
//  Created by Arjuna on 5/31/21.
//

import UIKit
import Kingfisher

class CategoryTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let videoCellSize = CGSize(width: 112, height: 200)
    
    var category: VideoCategory!  {
        didSet {
            self.titleLabel.text = self.category.title
            self.videoCollectionView.reloadData()
        }
    }

    var didSelectedVideoAtIndex: ((Int, VideoCategory) -> ())?
    
    var collectionViewOffset: CGFloat {
        get {
            return self.videoCollectionView.contentOffset.x
        }

        set {
            self.videoCollectionView.contentOffset.x = newValue
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.category.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCollectionViewCell
        videoCell.thumbnailImageView.kf.indicatorType = .activity
        
        let provider = AVAssetImageDataProvider(
            assetURL: self.category.videos[indexPath.item].url,
            seconds: 3.0
        )
        let placeholderImage = UIImage(named: "placeholder-image")

        videoCell.thumbnailImageView.kf.setImage(with: provider, placeholder: placeholderImage, options: [.processor(DownsamplingImageProcessor(size: videoCellSize))])
        videoCell.title.text = ""//"\(self.category.title) \(indexPath.item)"
        return videoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return videoCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectedVideoAtIndex?(indexPath.row, self.category)
    }
}
