//
//  FlickrAPI.swift
//  FlickrTest
//
//  Created by Alexia Nunez on 8/29/16.
//  Copyright © 2016 Alexia Nunez. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum FlickrAPIError: ErrorType {
    
    case SystemError
    
}

struct Photo {
    
    let ID: String
    let farmID: String
    let serverID: String
    let secret: String
    let url: String
    let title: String
    
    init(ID: String, title: String, farmID: String, serverID: String, secret: String) {
        
        self.ID = ID
        self.title = title
        self.farmID = farmID
        self.serverID = serverID
        self.secret = secret
        self.url = "https://farm\(self.farmID).staticflickr.com/\(self.serverID)/\(self.ID)_\(self.secret).jpg"
        
    }
    
}

struct FlickrAPI {
    
    func getPhotos(searchTerm: String) -> Observable<[Photo]> {
        
        guard
            !searchTerm.isEmpty,
            let url = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d0e947f859d1f9d93c5a5c6e40e4670a&format=json&tags=\(searchTerm)")
            else {
                return Observable.just([])
        }
        
        return NSURLSession.sharedSession()
            .rx_JSON(NSURLRequest(URL: url))
            .retry(3)
            .catchErrorJustReturn([])
            .map {
                
                var photos = [Photo]()
                
                if let items = $0 as? [[String: AnyObject]] {
                    
                    items.forEach({ (dict: [String : AnyObject]) in
                        
                        guard let
                            id          = dict["id"] as? String,
                            title       = dict["title"] as? String,
                            farmID      = dict["farm"] as? String,
                            serverID    = dict["server"] as? String,
                            secret      = dict["secret"] as? String
                            else {
                                return
                        }
                        
                        photos.append(Photo(ID: id, title: title, farmID: farmID, serverID: serverID, secret: secret))
                        
                    })
                    
                }
                
                return photos
        }
        
    }
    
    
}
