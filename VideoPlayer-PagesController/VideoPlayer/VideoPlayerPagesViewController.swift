//
//  VideoPlayerPagesViewController.swift
//  VideoPlayer
//
//  Created by Arjuna on 5/31/21.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerPagesViewController: UIPageViewController {

    var videos:[Video] = []
    var currentIndex: Int!
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      if let viewController = avPlayerViewController(currentIndex ?? 0) {
        let viewControllers = [viewController]
        
        setViewControllers(viewControllers,
                           direction: .forward,
                           animated: false,
                           completion: nil)
        viewController.player?.play()
      }
      
      dataSource = self
      delegate = self
    }

    
    func avPlayerViewController(_ index: Int) -> AVPlayerViewController? {
      let page = AVPlayerViewController()
      let player = AVPlayer(url: videos[index].url)
      page.player = player
      return page
    }
}

extension VideoPlayerPagesViewController: UIPageViewControllerDataSource {
   
    func indexOfController(playerVC: AVPlayerViewController) -> Int {
        var videoIndex = -1
        let url = (playerVC.player!.currentItem!.asset as! AVURLAsset).url
        
        for index in 0..<videos.count  {
            if videos[index].url == url {
                videoIndex = index
                break
            }
        }
        return videoIndex
    }
    
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if let viewController = viewController as? AVPlayerViewController {
       let index = indexOfController(playerVC: viewController)
        if index > 0 {
            return avPlayerViewController(index - 1)
        }
    }
    return nil
  }
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if let viewController = viewController as? AVPlayerViewController {
       let index = indexOfController(playerVC: viewController)
        if index < self.videos.count - 1 {
            return avPlayerViewController(index + 1)
        }
    }
    return nil
  }
  
}

extension VideoPlayerPagesViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
        for vc in previousViewControllers {
            (vc as! AVPlayerViewController).player?.pause()
        }
        (self.viewControllers?.last as! AVPlayerViewController).player?.play()
    }
  }
}
