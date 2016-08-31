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

enum FlickrAPIResponseKeys: String {
    case PhotosDict = "photos"
    case PhotosArray = "photo"
    case PhotoId = "id"
    case PhotoFarmId = "farm"
    case PhotoServerID = "server"
    case PhotoSecret = "secret"
    case PhotoTitle = "title"
}

enum FlickrAPIError: ErrorType {
    
    case SystemError
    
}

enum FlickrAPIMethod: String {
    
    case PhotosSearch = "flickr.photos.search"
    
}

struct FlickrAPI {
    
    static let sharedInstance = FlickrAPI()
    
    var method: FlickrAPIMethod = .PhotosSearch
    
    private let apiKey = "d0e947f859d1f9d93c5a5c6e40e4670a"
    
    func getPhotos(searchTerm: String) -> Observable<[Photo]> {
        
        guard !searchTerm.isEmpty,
            let url = NSURL(string: "https://api.flickr.com/services/rest/?method=\(method.rawValue)&api_key=\(apiKey)&format=json&tags=\(searchTerm)")
            else {
                return Observable.just([])
        }
        
        return NSURLSession.sharedSession()
            
            .rx_data(NSURLRequest(URL: url))
            
            
            
            .retry(3)
            
            .map { data in
                
                var photos: [Photo] = [Photo]()
                
                guard let
                    result = NSString(data: data, encoding: NSUTF8StringEncoding) as? String,
                    dict = self.convertStringToDictionary(result),
                    photosDict = dict[FlickrAPIResponseKeys.PhotosDict.rawValue],
                    items = photosDict[FlickrAPIResponseKeys.PhotosArray.rawValue] as? [[String: AnyObject]]
                    
                    else {
                        return photos
                }
                
                for item in items {
                    
                    guard let
                        photoID     = item[FlickrAPIResponseKeys.PhotoId.rawValue] as? String,
                        photoTitle  = item[FlickrAPIResponseKeys.PhotoTitle.rawValue] as? String,
                        photoFarmID = item[FlickrAPIResponseKeys.PhotoFarmId.rawValue] as? Int,
                        photoServerID = item[FlickrAPIResponseKeys.PhotoServerID.rawValue] as? String,
                        photoSecret = item[FlickrAPIResponseKeys.PhotoSecret.rawValue] as? String
                        else {
                            break
                    }
                    
                    photos.append(Photo(ID: photoID, title: photoTitle, farmID: photoFarmID, serverID: photoServerID, secret: photoSecret))
                    
                }
                
                return photos
                
        }
        
    }
    
    
    
    private func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        
        var cleanString = text.stringByReplacingOccurrencesOfString("jsonFlickrApi(", withString: "")
        
        cleanString = cleanString.substringToIndex(cleanString.endIndex.predecessor())
        
        if let data = cleanString.dataUsingEncoding(NSUTF8StringEncoding) {
            
            do {
                
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                
            } catch {
                
                return nil
            }
        }
        
        return nil
    }
    
}
