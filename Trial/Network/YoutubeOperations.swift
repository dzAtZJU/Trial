/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 An `Operation` subclass used by `AsyncFetcher` to mimic slow network requests for data.
 */

import Foundation
import UIKit
import GoogleAPIClientForREST

class ImageFetchOperation: Operation {
    let imageUrl: String
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    private(set) var image: UIImage?
    
    override func main() {
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
            image = UIImage(data: data)!
        }
    }
}

let youtubeService: GTLRYouTubeService = {
    let s = GTLRYouTubeService()
    s.apiKey = "AIzaSyCdC0q9pnE9t5uB9klpdaf_P7PICftusv0"
    return s
}()

class ThumbnailsUrlsOperation: Operation {
    
    let videoIds: [VideoId]
    
    private(set) var videoId2ThumbnailUrl = [VideoId: URLString]()
    
    init(videoIds: [VideoId]) {
        self.videoIds = videoIds
    }

    override func start() {
        _isExecuting = true
        let youtubeQuery = GTLRYouTubeQuery_VideosList.query(withPart: "snippet")
        youtubeQuery.identifier = videoIds.joined(separator: ",")
        youtubeService.executeQuery(youtubeQuery) { (ticket, response, error) in
            let response = response as! GTLRYouTube_VideoListResponse
            if let items = response.items {
                for item in items {
                    if let identifier = item.identifier, let url = item.snippet?.thumbnails?.high?.url {
                        self.videoId2ThumbnailUrl[identifier] = url
                    }
                }
            }
            self._isExecuting = false
            self._isFinished = true
        }
    }
    
    private var _isExecuting = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _isFinished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isExecuting: Bool {
        get {
            return _isExecuting
        }
    }
    
    override var isFinished: Bool {
        get {
            return _isFinished
        }
    }
    
    override var isAsynchronous: Bool {
        get {
            return true
        }
    }
}
