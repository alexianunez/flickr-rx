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

struct FlickrViewModel {

    let searchText = Variable("")
    
    let disposeBag = DisposeBag()
    
    lazy var data: Driver<[Photo]> = {
        
        return self.searchText.asObservable()
            
            .throttle(0.5, scheduler: MainScheduler.instance)
            
            .distinctUntilChanged()
            
            .flatMapLatest {
            
                self.getPhotos($0)
            }
            
            .asDriver(onErrorJustReturn: [])
        
    }()
    
    func getPhotos(searchTerm: String) -> Observable<[Photo]> {
        
        return FlickrAPI.sharedInstance.getPhotos(searchTerm)
        
    }
    
}
