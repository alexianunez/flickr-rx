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
    case Photos = "photos"
    case Id = "id"
    case FarmId = "farm"
    case ServerID = "server"
    case Secret = "secret"
    case Title = "title"
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
                
                let photos: [Photo] = [Photo]()
                
                guard let
                    result = NSString(data: data, encoding: NSUTF8StringEncoding) as? String,
                    dict = self.convertStringToDictionary(result),
                    items = dict[FlickrAPIResponseKeys.Photos.rawValue]
                    else {
                        return photos
                }
                
                
                print("\(items)")

                
             
                
                
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
