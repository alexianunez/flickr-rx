//
//  FlickrViewModel.swift
//  FlickrTest
//
//  Created by Alexia Nunez on 8/30/16.
//  Copyright © 2016 Alexia Nunez. All rights reserved.
//

import Foundation
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

struct FlickrViewModel {

    let searchText = Variable("")
    
    let disposeBag = DisposeBag()
    
    lazy var data: Driver<[Photo]> = {
        
        return self.searchText.asObservable()
            
            .throttle(0.3, scheduler: MainScheduler.instance)
            
            .distinctUntilChanged()
            
            .flatMapLatest {
            
                self.getPhotos($0)
            }
            
            .asDriver(onErrorJustReturn: [])
        
    }()
    
    func getPhotos(searchTerm: String) -> Observable<[Photo]> {
        
        guard !searchTerm.isEmpty,
            let url = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d0e947f859d1f9d93c5a5c6e40e4670a&format=json&tags=\(searchTerm)")
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
                
                
                print(items)
                
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
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        
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
