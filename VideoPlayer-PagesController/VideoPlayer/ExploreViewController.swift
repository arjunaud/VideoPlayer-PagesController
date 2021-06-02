//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Arjuna on 5/20/21.
//

import UIKit
import AVKit
import AVFoundation
import Kingfisher

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var videoCategories:[VideoCategory] = []
    var videoCollectionViewContentOffsets = [Int: CGFloat]()
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
        VideoDataProvider().fetchVideoData { (videoCategories) in
            DispatchQueue.main.async {
                self.videoCategories = videoCategories
                self.categoriesTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        self.navigationItem.title = "Explore"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        categoryCell.category =  self.videoCategories[indexPath.row]
        categoryCell.didSelectedVideoAtIndex = showVideoAtIndex(videoIndex:category:)
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CategoryTableViewCell else { return }

        tableViewCell.collectionViewOffset = videoCollectionViewContentOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CategoryTableViewCell else { return }

        videoCollectionViewContentOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    func showVideoAtIndex(videoIndex:Int, category:VideoCategory) -> Void {
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        let pagesVideoController = VideoPlayerPagesViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        pagesVideoController.videos = category.videos
        pagesVideoController.currentIndex = videoIndex
        self.navigationController?.pushViewController(pagesVideoController, animated: true)

        if #available(iOS 14.0, *) {
            self.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
    }
}

