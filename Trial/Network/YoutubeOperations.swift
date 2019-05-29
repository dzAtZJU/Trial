/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 An `Operation` subclass used by `AsyncFetcher` to mimic slow network requests for data.
 */

import Foundation
import UIKit
import GoogleAPIClientForREST

class WaitingOperation: Operation {
    let mainBlock: () -> ()
    
    init(mainBlock: @escaping () -> ()) {
        self.mainBlock = mainBlock
    }
    
    override func main() {
        mainBlock()
    }
}

class ImageFetchOperation: Operation {
    let urlString: String?
    
    let videoId: VideoId
    
    init(urlString: String?, videoId: VideoId) {
        self.urlString = urlString
        self.videoId = videoId
    }
    
    private(set) var image: UIImage!
    
    override func main() {
        if let urlString = urlString, let url = URL(string: urlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            self.image = image
            return
        }
        
        image = defaultThumbnail
        print("Image fetch fail. Url: \(urlString)")
    }
}

let youtubeService: GTLRYouTubeService = {
    let s = GTLRYouTubeService()
    s.apiKey = "AIzaSyCdC0q9pnE9t5uB9klpdaf_P7PICftusv0"
    return s
}()

let Default_ImageUrl = ""

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
            if let response = response as? GTLRYouTube_VideoListResponse, let items = response.items {
                for item in items {
                    if let identifier = item.identifier, let url = item.snippet?.thumbnails?.high?.url {
                        self.videoId2ThumbnailUrl[identifier] = url
                    }
                }
            }
            for videoId in self.videoIds {
                if self.videoId2ThumbnailUrl[videoId] == nil {
                    self.videoId2ThumbnailUrl[videoId] = Default_ImageUrl
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
