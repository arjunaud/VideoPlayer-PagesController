//
//  VideoDataService.swift
//  VideoPlayer
//
//  Created by Arjuna on 5/22/21.
//

import Foundation

struct Video {
    let url:URL
}

struct VideoCategory {
    var title:String
    var videos:[Video]
}

protocol VideoDataService {
    func fetchVideoData(completion: ([VideoCategory]) -> Void)
}

class VideoDataProvider: VideoDataService {

    private func getJson(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func fetchVideoData(completion: ([VideoCategory]) -> Void) {
        do {
            // make sure this JSON is in the format we expect
            var categories:[VideoCategory] = []
            if let categoriesList = try JSONSerialization.jsonObject(with: getJson(forName: "assignment")!, options: []) as? [Dictionary<String, Any>] {
                // try to read out a string array
                for category in categoriesList {
                    let title = category["title"] as! String
                    var videos :[Video] = []
                    if let videoDicts = category["nodes"] as? [Dictionary<String, Dictionary<String, String>>] {
                        for videoDict in videoDicts {
                            if let url = URL(string:videoDict["video"]?["encodeUrl"] ?? "") {
                                let video = Video(url:url)
                                videos.append(video)
                            }
                        }
                    }
                    categories.append(VideoCategory(title:title, videos:videos))
                }
            }
            completion(categories)
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            completion([])
        }
    }
}
